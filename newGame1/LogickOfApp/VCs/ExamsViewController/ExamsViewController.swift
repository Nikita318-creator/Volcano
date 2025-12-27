import UIKit
import SnapKit

class ExamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categories: [GeoCategory] = [
        GeoCategory(title: "Plate Tectonics", imageName: "tectonics_thumb"),
        GeoCategory(title: "Mineralogy", imageName: "minerals_thumb"),
        GeoCategory(title: "Sedimentary Rocks", imageName: "sedimentary_thumb"),
        GeoCategory(title: "Volcanic Activity", imageName: "volcano_thumb"),
        GeoCategory(title: "Paleontology", imageName: "paleo_thumb"),
        GeoCategory(title: "Soil Science", imageName: "soil_thumb"),
        GeoCategory(title: "Oceanography", imageName: "ocean_thumb"),
        GeoCategory(title: "Metamorphic Rocks", imageName: "metamorphic_thumb"),
        GeoCategory(title: "Crystal Systems", imageName: "crystals_thumb"),
        GeoCategory(title: "Erosion Processes", imageName: "erosion_thumb")
    ]
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Exams"
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Перезагружаем таблицу, чтобы обновить баллы при возврате с теста
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 90 // Чуть увеличил для красоты
        tableView.separatorStyle = .none // Убираем стандартные полоски
        tableView.backgroundColor = .systemBackground
        tableView.register(ExamCell.self, forCellReuseIdentifier: "ExamCell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExamCell", for: indexPath) as! ExamCell
        let category = categories[indexPath.row]
        
        cell.titleLabel.text = category.title
        
        // Подтягиваем результат из UserDefaults
        let key = "Score_\(category.title)"
        let savedScore = UserDefaults.standard.integer(forKey: key)
        
        // Выводим баллы [X/100]
        cell.scoreLabel.text = "\(savedScore)/100"
        
        // Красим баллы в оранжевый, если есть прогресс
        cell.scoreLabel.textColor = savedScore > 0 ? .systemOrange : .systemGray
        
        cell.imgView.image = UIImage(named: category.imageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        let quizVC = QuizProcessViewController()
        quizVC.categoryData = category
        quizVC.modalPresentationStyle = .fullScreen
        present(quizVC, animated: true)
    }
}
