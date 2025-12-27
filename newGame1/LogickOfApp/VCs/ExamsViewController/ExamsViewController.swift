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
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.register(ExamCell.self, forCellReuseIdentifier: "ExamCell")
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExamCell", for: indexPath) as! ExamCell
        cell.titleLabel.text = categories[indexPath.row].title
        cell.scoreLabel.text = "[0/100]" // test111 из юзер дефолтс подтянем
        cell.imgView.image = UIImage(named: categories[indexPath.row].imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
