import UIKit
import SnapKit

// MARK: - Game Models
struct GridPosition: Hashable {
    let row: Int
    let col: Int
}

class Tile {
    var emoji: String
    let id = UUID()
    
    init(emoji: String) {
        self.emoji = emoji
    }
}

// MARK: - Main Game Controller
class MiniGameScreenVC: UIViewController {
    
    // MARK: - Configuration
    private let elements = ["⚛️", "💠", "🧬", "🧪", "🦠", "🔭"] // "🌋", "💎", "🪨", "🔥", "⚛️"
    private let rows = 8
    private let cols = 6
    private let cellSize: CGFloat = 54
    
    // Game State
    private var grid: [[Tile]] = []
    private var selectedPosition: GridPosition?
    private var isProcessing = false
    private var comboMultiplier = 1
    
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
        label.text = "MOLECULAR REACTOR"
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.textColor = UIColor(red: 0.4, green: 0.8, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
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
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    
    private var cellViews: [[UIView]] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        generateInitialGrid()
        createCellViews()
        updateAllCells(animated: false)
        
        // Check initial matches and clear them
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.checkAndProcessMatches()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        // Title
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // Score Container
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
        
        // Grid Container
        view.addSubview(gridContainerView)
        let gridWidth = CGFloat(cols) * cellSize
        let gridHeight = CGFloat(rows) * cellSize
        
        gridContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scoreContainerView.snp.bottom).offset(30)
            make.width.equalTo(gridWidth + 20)
            make.height.equalTo(gridHeight + 20)
        }
    }
    
    // MARK: - Grid Generation
    private func generateInitialGrid() {
        grid = []
        for row in 0..<rows {
            var rowTiles: [Tile] = []
            // Сначала создаем "пустую" строку в grid, чтобы willCreateMatch не падал
            grid.append([])
            
            for col in 0..<cols {
                var emoji = ""
                var attempts = 0
                repeat {
                    emoji = elements.randomElement()!
                    attempts += 1
                } while checkPotentialMatch(emoji: emoji, row: row, col: col, currentLabels: rowTiles)
                
                let newTile = Tile(emoji: emoji)
                rowTiles.append(newTile)
                grid[row].append(newTile) // Сразу кладем в grid
            }
        }
    }

    // Вспомогательный метод для генерации (чистый от крашей)
    private func checkPotentialMatch(emoji: String, row: Int, col: Int, currentLabels: [Tile]) -> Bool {
        // Горизонталь: смотрим в только что созданный список элементов текущей строки
        if col >= 2 {
            if currentLabels[col-1].emoji == emoji && currentLabels[col-2].emoji == emoji {
                return true
            }
        }
        // Вертикаль: смотрим в уже добавленные в grid верхние строки
        if row >= 2 {
            if grid[row-1][col].emoji == emoji && grid[row-2][col].emoji == emoji {
                return true
            }
        }
        return false
    }
    
    private func willCreateMatch(emoji: String, at position: GridPosition) -> Bool {
        let row = position.row
        let col = position.col
        
        // ПРОВЕРКА ПО ГОРИЗОНТАЛИ
        // Убеждаемся, что в ТЕКУЩЕЙ строке уже есть хотя бы 2 элемента
        if col >= 2 {
            // Проверяем текущую строку, которую мы как раз наполняем в rowTiles
            // Но так как метод обращается к grid[row], нам нужно изменить логику
            // или передавать текущую наполняемую строку.
            // Самый простой хак — проверить, создана ли уже эта строка в grid:
            if grid.indices.contains(row) && grid[row].count > col - 1 {
                if grid[row][col-1].emoji == emoji && grid[row][col-2].emoji == emoji {
                    return true
                }
            }
        }
        
        // ПРОВЕРКА ПО ВЕРТИКАЛИ
        // Убеждаемся, что выше уже есть 2 готовые строки
        if row >= 2 {
            // Здесь grid[row-1] и grid[row-2] уже точно существуют,
            // так как мы идем сверху вниз
            if grid[row-1][col].emoji == emoji && grid[row-2][col].emoji == emoji {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Cell Views
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
                rowViews.append(cellView)
                
                // Add tap gesture
                let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
                cellView.addGestureRecognizer(tap)
                cellView.tag = row * 100 + col
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
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 34)
        label.textAlignment = .center
        label.tag = 999
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
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
        
        if let label = cellView.viewWithTag(999) as? UILabel {
            if animated {
                UIView.transition(with: label, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    label.text = tile.emoji
                })
            } else {
                label.text = tile.emoji
            }
        }
    }
    
    // MARK: - Interaction
    @objc private func cellTapped(_ gesture: UITapGestureRecognizer) {
        guard !isProcessing, let view = gesture.view else { return }
        
        let row = view.tag / 100
        let col = view.tag % 100
        let position = GridPosition(row: row, col: col)
        
        if let selected = selectedPosition {
            if selected == position {
                // Deselect
                deselectCell(at: selected)
                selectedPosition = nil
            } else if isAdjacent(selected, position) {
                // Swap
                deselectCell(at: selected)
                selectedPosition = nil
                performSwap(from: selected, to: position)
            } else {
                // Select new
                deselectCell(at: selected)
                selectCell(at: position)
                selectedPosition = position
            }
        } else {
            // First selection
            selectCell(at: position)
            selectedPosition = position
        }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    private func selectCell(at position: GridPosition) {
        let cellView = cellViews[position.row][position.col]
        cellView.layer.borderWidth = 3
        cellView.layer.borderColor = UIColor(red: 0.3, green: 0.9, blue: 1, alpha: 1).cgColor
        cellView.backgroundColor = UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 0.5)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.autoreverse, .repeat], animations: {
            cellView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        })
    }
    
    private func deselectCell(at position: GridPosition) {
        let cellView = cellViews[position.row][position.col]
        cellView.layer.removeAllAnimations()
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor(white: 0.3, alpha: 0.3).cgColor
        cellView.backgroundColor = UIColor(white: 0.15, alpha: 0.8)
        cellView.transform = .identity
    }
    
    private func isAdjacent(_ p1: GridPosition, _ p2: GridPosition) -> Bool {
        let rowDiff = abs(p1.row - p2.row)
        let colDiff = abs(p1.col - p2.col)
        return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
    }
    
    // MARK: - Swap Logic
    private func performSwap(from: GridPosition, to: GridPosition) {
        isProcessing = true
        
        // Swap in model
        let temp = grid[from.row][from.col]
        grid[from.row][from.col] = grid[to.row][to.col]
        grid[to.row][to.col] = temp
        
        // Animate swap
        animateSwap(from: from, to: to) {
            // Check for matches
            let matches = self.findAllMatches()
            
            if matches.isEmpty {
                // Invalid move - swap back
                let tempBack = self.grid[from.row][from.col]
                self.grid[from.row][from.col] = self.grid[to.row][to.col]
                self.grid[to.row][to.col] = tempBack
                
                self.animateSwap(from: from, to: to) {
                    self.isProcessing = false
                }
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            } else {
                // Valid move
                self.comboMultiplier = 1
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                self.processMatches(matches)
            }
        }
    }
    
    private func animateSwap(from: GridPosition, to: GridPosition, completion: @escaping () -> Void) {
        let fromView = cellViews[from.row][from.col]
        let toView = cellViews[to.row][to.col]
        
        // Вычисляем целевые точки заранее
        let targetFromCenter = toView.center
        let targetToCenter = fromView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            fromView.center = targetFromCenter
            toView.center = targetToCenter
        }) { _ in
            // СИНХРОНИЗАЦИЯ: меняем местами в массиве вьюх
            self.cellViews[from.row][from.col] = toView
            self.cellViews[to.row][to.col] = fromView
            
            // ОБНОВЛЯЕМ ТЭГИ (чтобы cellTapped работал верно)
            fromView.tag = to.row * 100 + to.col
            toView.tag = from.row * 100 + from.col
            
            completion()
        }
    }
    
    private func forceLayoutUpdate() {
        for row in 0..<rows {
            for col in 0..<cols {
                let x = 10 + CGFloat(col) * cellSize
                let y = 10 + CGFloat(row) * cellSize
                let view = cellViews[row][col]
                view.frame = CGRect(x: x, y: y, width: cellSize, height: cellSize)
                view.tag = row * 100 + col // Гарантируем правильность тэгов
            }
        }
    }
    
    // MARK: - Match Detection
    private func findAllMatches() -> Set<GridPosition> {
        var matches = Set<GridPosition>()
        
        // Horizontal matches
        for row in 0..<rows {
            var col = 0
            while col < cols {
                let emoji = grid[row][col].emoji
                var matchLength = 1
                
                while col + matchLength < cols && grid[row][col + matchLength].emoji == emoji {
                    matchLength += 1
                }
                
                if matchLength >= 3 {
                    for i in 0..<matchLength {
                        matches.insert(GridPosition(row: row, col: col + i))
                    }
                }
                
                col += matchLength
            }
        }
        
        // Vertical matches
        for col in 0..<cols {
            var row = 0
            while row < rows {
                let emoji = grid[row][col].emoji
                var matchLength = 1
                
                while row + matchLength < rows && grid[row + matchLength][col].emoji == emoji {
                    matchLength += 1
                }
                
                if matchLength >= 3 {
                    for i in 0..<matchLength {
                        matches.insert(GridPosition(row: row + i, col: col))
                    }
                }
                
                row += matchLength
            }
        }
        
        return matches
    }
    
    // MARK: - Match Processing
    private func processMatches(_ matches: Set<GridPosition>) {
        let points = matches.count * 10 * comboMultiplier
        score += points
        comboMultiplier += 1
        
        // Animate matched cells
        for position in matches {
            let cellView = cellViews[position.row][position.col]
            UIView.animate(withDuration: 0.2, animations: {
                cellView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                cellView.alpha = 0.3
            }) { _ in
                cellView.transform = .identity
                cellView.alpha = 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.removeMatches(matches)
        }
    }
    
    private func removeMatches(_ matches: Set<GridPosition>) {
        isProcessing = true
        
        for col in 0..<cols {
            // 1. Собираем вьюхи, которые "сгорели" в этой колонке
            var viewsToRemove: [UIView] = []
            for row in 0..<rows {
                if matches.contains(GridPosition(row: row, col: col)) {
                    viewsToRemove.append(cellViews[row][col])
                }
            }
            
            var emptySpaces = 0
            // 2. Сдвигаем выжившие данные и вьюхи вниз
            for row in stride(from: rows - 1, through: 0, by: -1) {
                let position = GridPosition(row: row, col: col)
                if matches.contains(position) {
                    emptySpaces += 1
                } else if emptySpaces > 0 {
                    let fromPos = GridPosition(row: row, col: col)
                    let toPos = GridPosition(row: row + emptySpaces, col: col)
                    
                    // Переносим данные
                    grid[toPos.row][toPos.col] = grid[fromPos.row][fromPos.col]
                    
                    // Переносим вьюху в массиве
                    let movingView = cellViews[fromPos.row][fromPos.col]
                    cellViews[toPos.row][toPos.col] = movingView
                    
                    // Анимируем падение
                    animateCellDrop(to: toPos, view: movingView)
                }
            }
            
            // 3. Заполняем верхние освободившиеся ячейки "сгоревшими" вьюхами (реюз)
            for i in 0..<emptySpaces {
                let newEmoji = elements.randomElement()!
                grid[i][col] = Tile(emoji: newEmoji)
                
                let recycledView = viewsToRemove[i]
                cellViews[i][col] = recycledView // Кладём обратно в массив на новую позицию
                
                setupNewCellView(recycledView, row: i, col: col, emoji: newEmoji)
            }
        }
        
        // 4. Ждем окончания анимаций и проверяем на новые комбо
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.forceLayoutUpdate()
            self.checkAndProcessMatches()
        }
    }

    private func animateCellDrop(to: GridPosition, view: UIView) {
        let targetY = 10 + CGFloat(to.row) * cellSize
        let targetX = 10 + CGFloat(to.col) * cellSize
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            view.frame.origin = CGPoint(x: targetX, y: targetY)
        } completion: { _ in
            view.tag = to.row * 100 + to.col
        }
    }

    private func setupNewCellView(_ view: UIView, row: Int, col: Int, emoji: String) {
        view.alpha = 0
        // Считаем целевой X и Y
        let targetX = 10 + CGFloat(col) * cellSize
        let targetY = 10 + CGFloat(row) * cellSize
        
        // Выносим вьюху за верхнюю границу
        view.frame.origin = CGPoint(x: targetX, y: targetY - (cellSize * 3))
        view.tag = row * 100 + col
        
        if let label = view.viewWithTag(999) as? UILabel {
            label.text = emoji
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.05 * Double(row), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            view.alpha = 1
            view.frame.origin.y = targetY
        }
    }
    
    private func checkAndProcessMatches() {
        let matches = findAllMatches()
        if !matches.isEmpty {
            processMatches(matches)
        } else {
            isProcessing = false
            comboMultiplier = 1
        }
    }
}
