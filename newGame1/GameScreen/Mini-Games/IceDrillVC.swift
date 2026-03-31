
import UIKit
import SnapKit

// MARK: - Game Models
class IceTile {
    var imageName: String
    init(imageName: String) { self.imageName = imageName }
}

class IceDrillVC: BaseGameVC {
    
    // MARK: - Config
    private let symbols = ["symbol_1", "symbol_2", "symbol_3", "symbol_4", "symbol_5", "symbol_6"]
    private let rows = 6
    private let cols = 6
    private let targetScore = 200
    
    // UI
    private let progressContainer = UIView()
    private let progressFill = UIView()
    private var progressWidthConstraint: Constraint?
    
    private var gridContainer = UIView()
    private var cellViews: [[UIView]] = []
    private var grid: [[IceTile]] = []
    
    private var currentScore = 0 {
        didSet { updateProgress() }
    }
    private var isProcessing = false
    private var selectedPosition: (row: Int, col: Int)?
    private var cellSize: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.image = UIImage(named: "bg_story")
        setupUI()
        generateInitialGrid()
        createCells()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.checkAndProcessMatches()
        }
    }

    private func setupUI() {
        // Прогресс бар
        progressContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        progressContainer.layer.cornerRadius = 15
        progressContainer.layer.borderWidth = 2
        progressContainer.layer.borderColor = UIColor.white.cgColor
        progressContainer.clipsToBounds = true
        
        view.addSubview(progressContainer)
        progressContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(30)
        }
        
        progressFill.backgroundColor = .systemYellow
        progressContainer.addSubview(progressFill)
        progressFill.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            self.progressWidthConstraint = make.width.equalTo(0).constraint
        }
        
        // Контейнер для сетки
        gridContainer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        gridContainer.layer.cornerRadius = 12
        view.addSubview(gridContainer)
        
        let side = (UIScreen.main.bounds.width - 40)
        gridContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(side)
        }
        
        let gridPadding: CGFloat = 10
        let spacing: CGFloat = 4
        let availableWidth = side - (gridPadding * 2) - (spacing * CGFloat(cols - 1))
        self.cellSize = availableWidth / CGFloat(cols)
    }
    
    // MARK: - Logic (Ported from MiniGame)
    private func generateInitialGrid() {
        grid = (0..<rows).map { _ in (0..<cols).map { _ in IceTile(imageName: "") } }
        for r in 0..<rows {
            for c in 0..<cols {
                var name: String
                repeat {
                    name = symbols.randomElement()!
                } while (c >= 2 && grid[r][c-1].imageName == name && grid[r][c-2].imageName == name) ||
                        (r >= 2 && grid[r-1][c].imageName == name && grid[r-2][c].imageName == name)
                grid[r][c].imageName = name
            }
        }
    }
    
    private func createCells() {
        gridContainer.subviews.forEach { $0.removeFromSuperview() }
        cellViews = []
        
        let spacing: CGFloat = 4
        let padding: CGFloat = 10
        
        for r in 0..<rows {
            var rowViews: [UIView] = []
            for c in 0..<cols {
                let container = UIView()
                container.backgroundColor = UIColor(white: 1, alpha: 0.1)
                container.layer.cornerRadius = 8
                container.clipsToBounds = true
                
                gridContainer.addSubview(container)
                let x = padding + CGFloat(c) * (cellSize + spacing)
                let y = padding + CGFloat(r) * (cellSize + spacing)
                container.frame = CGRect(x: x, y: y, width: cellSize, height: cellSize)
                
                let iv = UIImageView(image: UIImage(named: grid[r][c].imageName))
                iv.contentMode = .scaleAspectFit
                iv.tag = 777
                container.addSubview(iv)
                iv.snp.makeConstraints { $0.edges.equalToSuperview().inset(5) }
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                container.addGestureRecognizer(tap)
                container.tag = r * 100 + c
                rowViews.append(container)
            }
            cellViews.append(rowViews)
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard !isProcessing, let v = gesture.view else { return }
        let r = v.tag / 100
        let c = v.tag % 100
        
        if let sel = selectedPosition {
            if sel.row == r && sel.col == c {
                deselect(sel)
                selectedPosition = nil
            } else if abs(sel.row - r) + abs(sel.col - c) == 1 {
                deselect(sel)
                let from = sel
                selectedPosition = nil
                performSwap(from: from, to: (r, c))
            } else {
                deselect(sel)
                select((r, c))
                selectedPosition = (r, c)
            }
        } else {
            select((r, c))
            selectedPosition = (r, c)
        }
    }

    private func performSwap(from: (row: Int, col: Int), to: (row: Int, col: Int)) {
        isProcessing = true
        let t1 = grid[from.row][from.col]
        grid[from.row][from.col] = grid[to.row][to.col]
        grid[to.row][to.col] = t1
        
        animateSwap(from: from, to: to) {
            let matches = self.findAllMatches()
            if matches.isEmpty {
                let t = self.grid[from.row][from.col]
                self.grid[from.row][from.col] = self.grid[to.row][to.col]
                self.grid[to.row][to.col] = t
                self.animateSwap(from: from, to: to) { self.isProcessing = false }
            } else {
                self.processMatches(matches)
            }
        }
    }

    private func animateSwap(from: (row: Int, col: Int), to: (row: Int, col: Int), completion: @escaping () -> Void) {
        let v1 = cellViews[from.row][from.col]
        let v2 = cellViews[to.row][to.col]
        
        UIView.animate(withDuration: 0.3, animations: {
            let p1 = v1.center
            v1.center = v2.center
            v2.center = p1
        }) { _ in
            self.cellViews[from.row][from.col] = v2
            self.cellViews[to.row][to.col] = v1
            v1.tag = to.row * 100 + to.col
            v2.tag = from.row * 100 + from.col
            completion()
        }
    }

    private func findAllMatches() -> Set<[Int]> {
        var matches = Set<[Int]>()
        for r in 0..<rows {
            var c = 0
            while c < cols {
                let name = grid[r][c].imageName
                var len = 1
                while c + len < cols && grid[r][c + len].imageName == name { len += 1 }
                if len >= 3 { for i in 0..<len { matches.insert([r, c + i]) } }
                c += len
            }
        }
        for c in 0..<cols {
            var r = 0
            while r < rows {
                let name = grid[r][c].imageName
                var len = 1
                while r + len < rows && grid[r + len][c].imageName == name { len += 1 }
                if len >= 3 { for i in 0..<len { matches.insert([r + i, c]) } }
                r += len
            }
        }
        return matches
    }

    private func processMatches(_ matches: Set<[Int]>) {
        currentScore += matches.count * 10
        
        for m in matches {
            let v = cellViews[m[0]][m[1]]
            UIView.animate(withDuration: 0.25, animations: {
                v.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                v.alpha = 0
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { self.removeMatches(matches) }
    }

    private func removeMatches(_ matches: Set<[Int]>) {
        let matchSet = Set(matches.map { "\($0[0]),\($0[1])" })
        
        for c in 0..<cols {
            var viewsToRemove: [UIView] = []
            for r in 0..<rows {
                if matchSet.contains("\(r),\(c)") {
                    viewsToRemove.append(cellViews[r][c])
                }
            }
            
            var emptySpaces = 0
            for r in stride(from: rows - 1, through: 0, by: -1) {
                if matchSet.contains("\(r),\(c)") {
                    emptySpaces += 1
                } else if emptySpaces > 0 {
                    let movingView = cellViews[r][c]
                    grid[r + emptySpaces][c] = grid[r][c]
                    cellViews[r + emptySpaces][c] = movingView
                    animateCellDrop(to: (r + emptySpaces, c), view: movingView)
                }
            }
            
            for i in 0..<emptySpaces {
                let targetRow = emptySpaces - 1 - i
                let name = symbols.randomElement()!
                let recycledView = viewsToRemove[i]
                grid[targetRow][c] = IceTile(imageName: name)
                cellViews[targetRow][c] = recycledView
                setupNewCellView(recycledView, row: targetRow, col: c, imageName: name)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.checkAndProcessMatches()
        }
    }

    private func animateCellDrop(to: (row: Int, col: Int), view: UIView) {
        let spacing: CGFloat = 4
        let padding: CGFloat = 10
        let targetY = padding + CGFloat(to.row) * (cellSize + spacing)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            view.frame.origin.y = targetY
        } completion: { _ in
            view.tag = to.row * 100 + to.col
        }
    }

    private func setupNewCellView(_ view: UIView, row: Int, col: Int, imageName: String) {
        view.transform = .identity
        view.alpha = 1
        let spacing: CGFloat = 4
        let padding: CGFloat = 10
        let tx = padding + CGFloat(col) * (cellSize + spacing)
        let ty = padding + CGFloat(row) * (cellSize + spacing)
        
        // Начальная позиция выше контейнера
        view.frame = CGRect(x: tx, y: -cellSize * 2, width: cellSize, height: cellSize)
        view.tag = row * 100 + col
        if let iv = view.viewWithTag(777) as? UIImageView { iv.image = UIImage(named: imageName) }
        
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(row), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            view.frame.origin.y = ty
        }
    }

    private func checkAndProcessMatches() {
        let matches = findAllMatches()
        if !matches.isEmpty { processMatches(matches) }
        else { isProcessing = false }
    }

    private func updateProgress() {
        let percentage = min(CGFloat(currentScore) / CGFloat(targetScore), 1.0)
        let totalWidth = UIScreen.main.bounds.width * 0.8
        
        UIView.animate(withDuration: 0.3) {
            self.progressWidthConstraint?.update(offset: totalWidth * percentage)
            self.view.layoutIfNeeded()
        }
        
        if currentScore >= targetScore {
            isProcessing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.present(CatchVC(), animated: true)
            }
        }
    }

    private func select(_ p: (Int, Int)) {
        cellViews[p.0][p.1].backgroundColor = .systemBlue.withAlphaComponent(0.5)
        UIView.animate(withDuration: 0.2, animations: {
            self.cellViews[p.0][p.1].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    private func deselect(_ p: (Int, Int)) {
        cellViews[p.0][p.1].backgroundColor = UIColor(white: 1, alpha: 0.1)
        UIView.animate(withDuration: 0.2, animations: {
            self.cellViews[p.0][p.1].transform = .identity
        })
    }
}
