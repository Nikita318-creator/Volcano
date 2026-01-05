import UIKit
import SnapKit

// MARK: - Game Models
struct GridPosition: Hashable {
    let row: Int
    let col: Int
}

class Tile {
    var imageName: String
    let id = UUID()
    
    init(imageName: String) {
        self.imageName = imageName
    }
}

// MARK: - Main Game Controller
class MiniGameScreenVC: UIViewController {
    
    // MARK: - Configuration
    private let elements = ["miniGame1", "miniGame2", "miniGame3", "miniGame4", "miniGame5", "miniGame6"]
    private let rows = 8
    private let cols = 6
    private let cellSize: CGFloat = 54
    
    // Game State
    private var grid: [[Tile]] = []
    private var selectedPosition: GridPosition?
    private var isProcessing = false
    private var comboMultiplier = 1
    private static var hasShownRulesThisSession = false
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    // MARK: - UI Components
    private let backgroundGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.05, green: 0.08, blue: 0.15, alpha: 1).cgColor,
            UIColor(red: 0.08, green: 0.12, blue: 0.20, alpha: 1).cgColor
        ]
        gradient.locations = [0, 1]
        return gradient
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "GEOLOGICAL ANALYZER"
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.textColor = UIColor(red: 0.4, green: 0.8, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        button.setImage(UIImage(systemName: "info.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(red: 0.3, green: 0.9, blue: 1, alpha: 1)
        return button
    }()
    
    private let resetBoardButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        button.setImage(UIImage(systemName: "arrow.2.circlepath", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(red: 0.3, green: 0.9, blue: 1, alpha: 1)
        return button
    }()
    
    private let scoreContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.15, alpha: 0.6)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.3, green: 0.6, blue: 1, alpha: 0.3).cgColor
        return view
    }()
    
    private let scoreTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "STABILITY"
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .monospacedSystemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(red: 0.3, green: 0.9, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let gridContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 0.4).cgColor
        return view
    }()
    
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap adjacent elements to swap and match 3 in a row"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(white: 0.7, alpha: 0.8)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var cellViews: [[UIView]] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        generateInitialGrid()
        createCellViews()
        updateAllCells(animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.checkAndProcessMatches()
            self.showRulesIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    private func showRulesIfNeeded() {
        if !Self.hasShownRulesThisSession {
            showInfoAlert()
            Self.hasShownRulesThisSession = true
        }
    }
    
    @objc private func showInfoAlert() {
        let alert = UIAlertController(
            title: "Geological Break",
            message: "Take a break from testing and sharpen your mind with this geological puzzle!\n\nStory: You are stabilizing rare crystal structures. Swap adjacent elements to create a line of three or more identical minerals to process them.\n\nMore matches increase the stability level!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Let's Start", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(infoButton)
        infoButton.addTarget(self, action: #selector(showInfoAlert), for: .touchUpInside)
        infoButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().inset(24)
        }
        
        view.addSubview(resetBoardButton)
        resetBoardButton.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        resetBoardButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalToSuperview().inset(24)
        }
        
        view.addSubview(scoreContainerView)
        scoreContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(70)
        }
        
        scoreContainerView.addSubview(scoreTitleLabel)
        scoreTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        scoreContainerView.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreTitleLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(gridContainerView)
        let gridWidth = CGFloat(cols) * cellSize
        let gridHeight = CGFloat(rows) * cellSize
        
        gridContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scoreContainerView.snp.bottom).offset(30)
            make.width.equalTo(gridWidth + 20)
            make.height.equalTo(gridHeight + 20)
        }
        
        view.addSubview(hintLabel)
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(gridContainerView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(40)
        }
    }
    
    @objc private func handleReset() {
        guard !isProcessing else { return }
        score = 0
        comboMultiplier = 1
        generateInitialGrid()
        updateAllCells(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.checkAndProcessMatches()
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    // MARK: - Grid Logic
    private func generateInitialGrid() {
        grid = []
        for row in 0..<rows {
            var rowTiles: [Tile] = []
            grid.append([])
            for col in 0..<cols {
                var imgName = ""
                repeat {
                    imgName = elements.randomElement()!
                } while checkPotentialMatch(imgName: imgName, row: row, col: col, currentLabels: rowTiles)
                
                let newTile = Tile(imageName: imgName)
                rowTiles.append(newTile)
                grid[row].append(newTile)
            }
        }
    }

    private func checkPotentialMatch(imgName: String, row: Int, col: Int, currentLabels: [Tile]) -> Bool {
        if col >= 2 {
            if currentLabels[col-1].imageName == imgName && currentLabels[col-2].imageName == imgName { return true }
        }
        if row >= 2 {
            if grid[row-1][col].imageName == imgName && grid[row-2][col].imageName == imgName { return true }
        }
        return false
    }
    
    private func createCellViews() {
        cellViews = []
        for row in 0..<rows {
            var rowViews: [UIView] = []
            for col in 0..<cols {
                let cellView = createCellView()
                gridContainerView.addSubview(cellView)
                let x = 10 + CGFloat(col) * cellSize
                let y = 10 + CGFloat(row) * cellSize
                cellView.frame = CGRect(x: x, y: y, width: cellSize, height: cellSize)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
                cellView.addGestureRecognizer(tap)
                cellView.tag = row * 100 + col
                rowViews.append(cellView)
            }
            cellViews.append(rowViews)
        }
    }
    
    private func createCellView() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(white: 0.15, alpha: 0.8)
        container.layer.cornerRadius = 10
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(white: 0.3, alpha: 0.3).cgColor
        container.clipsToBounds = true
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tag = 999
        container.addSubview(imageView)
        imageView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        return container
    }
    
    private func updateAllCells(animated: Bool) {
        for row in 0..<rows {
            for col in 0..<cols {
                updateCell(at: GridPosition(row: row, col: col), animated: animated)
            }
        }
    }
    
    private func updateCell(at position: GridPosition, animated: Bool) {
        let cellView = cellViews[position.row][position.col]
        let tile = grid[position.row][position.col]
        if let imageView = cellView.viewWithTag(999) as? UIImageView {
            let image = UIImage(named: tile.imageName)
            if animated {
                UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: { imageView.image = image })
            } else {
                imageView.image = image
            }
        }
    }
    
    @objc private func cellTapped(_ gesture: UITapGestureRecognizer) {
        guard !isProcessing, let view = gesture.view else { return }
        let row = view.tag / 100
        let col = view.tag % 100
        let position = GridPosition(row: row, col: col)
        
        if let selected = selectedPosition {
            if selected == position {
                deselectCell(at: selected)
                selectedPosition = nil
            } else if isAdjacent(selected, position) {
                deselectCell(at: selected)
                selectedPosition = nil
                performSwap(from: selected, to: position)
            } else {
                deselectCell(at: selected)
                selectCell(at: position)
                selectedPosition = position
            }
        } else {
            selectCell(at: position)
            selectedPosition = position
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    private func selectCell(at position: GridPosition) {
        let cellView = cellViews[position.row][position.col]
        cellView.layer.borderColor = UIColor(red: 0.3, green: 0.9, blue: 1, alpha: 1).cgColor
        cellView.backgroundColor = UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 0.5)
        UIView.animate(withDuration: 0.6, delay: 0, options: [.autoreverse, .repeat], animations: {
            cellView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        })
    }
    
    private func deselectCell(at position: GridPosition) {
        let cellView = cellViews[position.row][position.col]
        cellView.layer.removeAllAnimations()
        cellView.layer.borderColor = UIColor(white: 0.3, alpha: 0.3).cgColor
        cellView.backgroundColor = UIColor(white: 0.15, alpha: 0.8)
        cellView.transform = .identity
    }
    
    private func isAdjacent(_ p1: GridPosition, _ p2: GridPosition) -> Bool {
        return abs(p1.row - p2.row) + abs(p1.col - p2.col) == 1
    }
    
    private func performSwap(from: GridPosition, to: GridPosition) {
        isProcessing = true
        let tempTile = grid[from.row][from.col]
        grid[from.row][from.col] = grid[to.row][to.col]
        grid[to.row][to.col] = tempTile
        
        animateSwap(from: from, to: to) {
            let matches = self.findAllMatches()
            if matches.isEmpty {
                let tempBack = self.grid[from.row][from.col]
                self.grid[from.row][from.col] = self.grid[to.row][to.col]
                self.grid[to.row][to.col] = tempBack
                self.animateSwap(from: from, to: to) { self.isProcessing = false }
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            } else {
                self.comboMultiplier = 1
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                self.processMatches(matches)
            }
        }
    }
    
    private func animateSwap(from: GridPosition, to: GridPosition, completion: @escaping () -> Void) {
        let fromView = cellViews[from.row][from.col]
        let toView = cellViews[to.row][to.col]
        let targetFromCenter = toView.center
        let targetToCenter = fromView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            fromView.center = targetFromCenter
            toView.center = targetToCenter
        }) { _ in
            self.cellViews[from.row][from.col] = toView
            self.cellViews[to.row][to.col] = fromView
            fromView.tag = to.row * 100 + to.col
            toView.tag = from.row * 100 + from.col
            completion()
        }
    }

    private func findAllMatches() -> Set<GridPosition> {
        var matches = Set<GridPosition>()
        for row in 0..<rows {
            var col = 0
            while col < cols {
                let name = grid[row][col].imageName
                var matchLen = 1
                while col + matchLen < cols && grid[row][col + matchLen].imageName == name { matchLen += 1 }
                if matchLen >= 3 { for i in 0..<matchLen { matches.insert(GridPosition(row: row, col: col + i)) } }
                col += matchLen
            }
        }
        for col in 0..<cols {
            var row = 0
            while row < rows {
                let name = grid[row][col].imageName
                var matchLen = 1
                while row + matchLen < rows && grid[row + matchLen][col].imageName == name { matchLen += 1 }
                if matchLen >= 3 { for i in 0..<matchLen { matches.insert(GridPosition(row: row + i, col: col)) } }
                row += matchLen
            }
        }
        return matches
    }

    private func processMatches(_ matches: Set<GridPosition>) {
        score += matches.count * 10 * comboMultiplier
        comboMultiplier += 1
        for pos in matches {
            let view = cellViews[pos.row][pos.col]
            UIView.animate(withDuration: 0.25, animations: {
                view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                view.alpha = 0
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { self.removeMatches(matches) }
    }

    private func removeMatches(_ matches: Set<GridPosition>) {
        for col in 0..<cols {
            var viewsToRemove: [UIView] = []
            for row in 0..<rows {
                if matches.contains(GridPosition(row: row, col: col)) {
                    viewsToRemove.append(cellViews[row][col])
                }
            }
            
            var emptySpaces = 0
            for row in stride(from: rows - 1, through: 0, by: -1) {
                let pos = GridPosition(row: row, col: col)
                if matches.contains(pos) {
                    emptySpaces += 1
                } else if emptySpaces > 0 {
                    let fromPos = GridPosition(row: row, col: col)
                    let toPos = GridPosition(row: row + emptySpaces, col: col)
                    grid[toPos.row][toPos.col] = grid[fromPos.row][fromPos.col]
                    let movingView = cellViews[fromPos.row][fromPos.col]
                    cellViews[toPos.row][toPos.col] = movingView
                    animateCellDrop(to: toPos, view: movingView)
                }
            }
            
            for i in 0..<emptySpaces {
                let newImg = elements.randomElement()!
                let targetRow = emptySpaces - 1 - i
                grid[targetRow][col] = Tile(imageName: newImg)
                let recycledView = viewsToRemove[i]
                cellViews[targetRow][col] = recycledView
                setupNewCellView(recycledView, row: targetRow, col: col, imageName: newImg)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.forceLayoutUpdate()
            self.checkAndProcessMatches()
        }
    }

    private func animateCellDrop(to: GridPosition, view: UIView) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            view.frame.origin = CGPoint(x: 10 + CGFloat(to.col) * self.cellSize, y: 10 + CGFloat(to.row) * self.cellSize)
        } completion: { _ in
            view.tag = to.row * 100 + to.col
        }
    }

    private func setupNewCellView(_ view: UIView, row: Int, col: Int, imageName: String) {
        // Сначала возвращаем вью в дефолтное состояние, чтобы избежать багов размера
        view.transform = .identity
        view.alpha = 1
        
        let targetX = 10 + CGFloat(col) * cellSize
        let targetY = 10 + CGFloat(row) * cellSize
        
        // Устанавливаем начальную позицию сверху
        view.frame = CGRect(x: targetX, y: targetY - (cellSize * 4), width: cellSize, height: cellSize)
        view.tag = row * 100 + col
        
        if let iv = view.viewWithTag(999) as? UIImageView {
            iv.image = UIImage(named: imageName)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.05 * Double(row), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            view.frame.origin.y = targetY
        }
    }

    private func forceLayoutUpdate() {
        for row in 0..<rows {
            for col in 0..<cols {
                let view = cellViews[row][col]
                view.transform = .identity
                view.alpha = 1
                view.frame = CGRect(x: 10 + CGFloat(col) * cellSize, y: 10 + CGFloat(row) * cellSize, width: cellSize, height: cellSize)
                view.tag = row * 100 + col
            }
        }
    }

    private func checkAndProcessMatches() {
        let matches = findAllMatches()
        if !matches.isEmpty { processMatches(matches) }
        else { isProcessing = false; comboMultiplier = 1 }
    }
}
