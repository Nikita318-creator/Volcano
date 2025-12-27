import UIKit
import SnapKit

struct GeoCategory {
    let title: String
    let imageName: String
    var score: Int = 0
}

class VolcanoGuideViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Volcano Guide"
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GuideCell.self, forCellWithReuseIdentifier: "GuideCell")
        
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GuideCell", for: indexPath) as! GuideCell
        let cat = categories[indexPath.item]
        cell.titleLabel.text = cat.title
        cell.imageView.image = UIImage(named: cat.imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 40
        let width = (view.frame.width - padding) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected category: \(categories[indexPath.item].title)")
    }
}
