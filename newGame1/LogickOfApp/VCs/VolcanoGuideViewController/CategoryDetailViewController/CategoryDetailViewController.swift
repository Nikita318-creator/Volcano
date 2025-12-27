import UIKit
import SnapKit

// Расширенная модель для контента
struct DetailedContent {
    let mainTitle: String
    let sections: [ContentSection]
}

struct ContentSection {
    let subTitle: String
    let text: String
}

class CategoryDetailViewController: UIViewController {
    
    var categoryData: GeoCategory?
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let blurOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        btn.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let circleIconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.systemOrange.cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 25
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circleIconView.layer.cornerRadius = circleIconView.frame.width / 2
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // 1. Background Image
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 2. Blur/Dark Overlay
        view.addSubview(blurOverlay)
        blurOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 3. Scroll View
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // 4. Circle Icon (На всю ширину почти)
        contentView.addSubview(circleIconView)
        circleIconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(circleIconView.snp.width)
        }
        
        // 5. Stack View for Text content
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(circleIconView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        // 6. Back Button
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private func loadData() {
        guard let data = categoryData else { return }
        
        backgroundImageView.image = UIImage(named: data.imageName)
        circleIconView.image = UIImage(named: data.imageName)
        
        // Получаем уникальный контент на основе тайтла категории
        let content = getContent(for: data.title)
        renderContent(content)
    }
    
    private func getContent(for title: String) -> DetailedContent {
        switch title {
        case "Plate Tectonics":
            return DetailedContent(
                mainTitle: "Plate Tectonics",
                sections: [
                    ContentSection(subTitle: "1. Continental Drift", text: "The revolutionary theory of Continental Drift posits that Earth's continents are not stationary but have moved significantly over vast periods of geologic time. Proposed by Alfred Wegener in 1912, this hypothesis was initially met with skepticism because the underlying mechanism was unknown. Wegener's evidence was multifaceted: he pointed out the striking 'jigsaw puzzle' fit between the coastlines of South America and Africa, and he identified identical fossil remains of plants and animals, such as the Mesosaurus, on continents now separated by thousands of miles of ocean. Furthermore, he noted similar geological formations and mountain ranges that seemed to continue from one continent to another. This theory laid the essential groundwork for the modern synthesis of plate tectonics, transforming our understanding of the planet's dynamic history and the constant reshaping of its surface."),
                    
                    
                    
                    
                    ContentSection(subTitle: "2. Divergent Boundaries", text: "Divergent boundaries represent constructive margins where two tectonic plates move away from each other, primarily driven by the upwelling of magma from the underlying mantle. This process most commonly occurs along the ocean floor, creating massive underwater mountain ranges known as mid-ocean ridges, such as the Mid-Atlantic Ridge. As the lithospheric plates pull apart, the decrease in pressure allows the mantle to partially melt, sending basaltic magma upward to fill the gap. This magma cools and solidifies, forming brand-new oceanic crust—a process known as seafloor spreading. On land, this process creates rift valleys, like the East African Rift, which may eventually widen enough to form a new ocean basin. These areas are characterized by frequent but relatively shallow earthquakes and consistent volcanic activity, marking the birth of new lithosphere."),
                    
                    
                    
                    ContentSection(subTitle: "3. Convergent Boundaries", text: "Convergent boundaries are regions of intense geological activity where tectonic plates collide, leading to the destruction of lithosphere or the creation of massive orogenic belts. There are three primary types: oceanic-continental, oceanic-oceanic, and continental-continental. In subduction zones (oceanic-continental), the denser oceanic plate is forced beneath the lighter continental plate, melting as it sinks into the asthenosphere. This process generates deep ocean trenches and chains of explosive volcanoes, such as the Andes Mountains. When two oceanic plates collide, they form volcanic island arcs like Japan. However, when two continental plates meet, neither can subduct due to their low density; instead, the crust is violently crumpled, folded, and uplifted. This colossal impact is responsible for the formation of the world's highest mountain ranges, including the Himalayas, and causes profound metamorphic changes in the surrounding rock."),
                    
                    
                    
                    ContentSection(subTitle: "4. Transform Faults", text: "Transform fault boundaries occur where two tectonic plates slide horizontally past one another, neither creating nor destroying crust. These are often referred to as conservative plate margins. Despite the lack of volcanic activity, these boundaries are site of significant seismic danger. The contact line between the plates is rarely smooth; the massive slabs of rock become locked together due to immense friction, while the underlying tectonic forces continue to push them. This builds up a staggering amount of elastic strain energy within the rocks. When the accumulated stress finally exceeds the frictional strength of the fault, the plates slip suddenly, releasing the stored energy in the form of powerful seismic waves. The San Andreas Fault in California is the most famous example of such a boundary, where the Pacific Plate and the North American Plate grind past each other, causing frequent and sometimes devastating earthquakes that reshape the landscape."),
                    
                    
                    
                    ContentSection(subTitle: "5. Tectonic Plates Today", text: "In the modern era, the study of plate tectonics has transitioned from hypothesis to precise measurement, thanks to advanced GPS (Global Positioning System) technology and satellite interferometry (InSAR). These tools allow geophysicists to track the movement of continents with millimeter-level precision in real-time. We now understand that the movement of these massive plates, typically ranging from 2 to 10 centimeters per year, is fueled by a complex heat-transfer system within the Earth. This includes mantle convection—the slow crawling of Earth's rocky mantle—along with 'slab pull' (the sinking of cold, dense plates) and 'ridge push' (the gravitational sliding away from ridges). This continuous movement governs the global distribution of earthquakes, volcanoes, and mineral resources, and it plays a critical role in regulating Earth's long-term climate by cycling carbon between the interior and the atmosphere."),
                ]
            )
            
        case "Mineralogy":
            return DetailedContent(
                mainTitle: "Mineralogy Essentials",
                sections: [
                    ContentSection(subTitle: "1. Crystal Lattice", text: "At its core, mineralogy is the study of the solid, inorganic, and naturally occurring substances that make up our planet. Every mineral is defined by its specific chemical composition and, most importantly, its highly ordered internal atomic structure. This internal arrangement is known as a crystal lattice—a three-dimensional, repeating geometric framework of atoms or ions. The specific symmetry and spacing within this lattice dictate every physical property the mineral possesses. For instance, the way a mineral breaks (cleavage), its hardness, and its external crystal shape (habit) are all direct results of the strength and orientation of the atomic bonds within the lattice. Halite (table salt), for example, forms cubic crystals because of its simple, repeating cubic arrangement of sodium and chlorine ions, demonstrating the beautiful marriage between chemistry and geometry in the natural world."),
                    
                    
                    
                    ContentSection(subTitle: "2. Hardness Scale", text: "The Mohs scale of mineral hardness, developed by Friedrich Mohs in 1812, remains one of the most practical and widely used tools in mineralogy for field identification. This qualitative scale ranks minerals from 1 to 10 based on their ability to scratch one another. At the bottom is Talc (1), which is so soft it can be scratched with a fingernail, while at the top is Diamond (10), the hardest known natural substance, consisting of carbon atoms in a dense, tetrahedral covalent bond structure. The scale is non-linear; for example, the jump in actual hardness between Corundum (9) and Diamond (10) is much greater than the difference between the first nine minerals. For students and geologists, the Mohs scale is indispensable because it allows for the rapid narrowing down of possibilities when identifying an unknown specimen using simple tools like a copper penny, a steel nail, or a glass plate."),
                    
                    ContentSection(subTitle: "3. Optical Properties", text: "The interaction of light with a mineral provides a wealth of diagnostic information. Luster is the first property observed, describing how light is reflected from the surface; it is categorized as metallic (shiny like chrome or gold) or non-metallic (vitreous, pearly, or dull). The streak of a mineral—the color of its powder when dragged across an unglazed porcelain plate—is often more reliable than its outward color, which can be altered by impurities. More advanced optical studies involve 'double refraction,' where a single ray of light entering a mineral (like Calcite) is split into two, creating a double image. Some minerals also exhibit pleochroism, appearing to change color when viewed from different angles under polarized light. These optical signatures are essential for petrography, where thin slices of rock are examined under a microscope to determine their mineralogical history and formation conditions."),
                    ContentSection(subTitle: "4. Silicate Group", text: "Silicates are the most significant and abundant class of minerals, comprising approximately 90% of the Earth's crust and nearly the entire mantle. The fundamental 'building block' of all silicates is the silicon-oxygen tetrahedron ($SiO_4^{4-}$), a structure consisting of four oxygen atoms surrounding a single silicon atom. These tetrahedra can link together in various ways—forming isolated units, single chains, double chains, sheets, or complex three-dimensional frameworks. This structural variety leads to a diverse range of minerals: Olivine forms from isolated tetrahedra, while Quartz and Feldspar are framework silicates. Because they are the primary constituents of igneous rocks, understanding the silicate group is vital for deciphering the cooling history of magmas and the chemical evolution of the Earth's crust over billions of years."),
                    
                    ContentSection(subTitle: "5. Economic Minerals", text: "The study of mineralogy is not merely academic; it is the foundation of global industry and modern technology. Economic minerals are those that can be extracted for profit and are divided into metallic ores and non-metallic industrial minerals. Ores like Chalcopyrite (for copper), Hematite (for iron), and Native Gold are the raw materials for infrastructure and manufacturing. In the 21st century, 'Rare Earth Elements' (REEs), found in minerals like Monazite and Bastnäsite, have become strategically critical. These elements are essential for high-tech applications, including the powerful magnets in electric vehicle motors, high-capacity batteries, smartphone screens, and sophisticated aerospace guidance systems. As the world transitions to renewable energy, the demand for these specific mineral resources continues to grow, making the identification and sustainable extraction of minerals a key challenge for future geologists."),
                ]
            )
            
        case "Sedimentary Rocks":
            return DetailedContent(
                mainTitle: "Sedimentary Systems",
                sections: [
                    ContentSection(subTitle: "1. Weathering and Erosion", text: "The lifecycle of a sedimentary rock begins with the relentless process of weathering, which breaks down existing igneous, metamorphic, or older sedimentary rocks. Mechanical weathering, such as frost wedging and thermal expansion, physically shatters rock into smaller fragments without changing its chemistry. Chemical weathering, driven by rainwater and organic acids, decomposes minerals like feldspar into clay. Once the rock is broken down, erosion takes over; gravity, wind, flowing water, and moving glaciers act as transport agents. During transport, the sediment particles undergo 'sorting' and 'rounding'—the further they travel from their source, the smoother and more uniform in size they become. This journey eventually ends in a depositional environment, such as a river delta, a desert dune, or the deep ocean floor, where the energy of the transport medium drops enough for the sediment to settle."),
                    ContentSection(subTitle: "2. Lithification", text: "Lithification is the complex geological transformation of loose, unconsolidated sediment into solid, cohesive rock. This process consists of two primary stages: compaction and cementation. As layers of sediment accumulate over thousands or millions of years, the sheer weight of the overlying material exerts massive pressure on the deeper layers. This compaction squeezes out water and air from the pore spaces between grains, significantly reducing the volume of the sediment. Following compaction, cementation occurs when mineral-rich groundwater pervasively circulates through the remaining pore spaces. Minerals such as Calcite, Silica (Quartz), or Iron Oxide precipitate out of the water and act as a natural mineral 'glue,' binding the individual sediment grains together into a solid mass. The result is a rock that preserves the history of its deposition, locked in a durable matrix."),
                    
                    ContentSection(subTitle: "3. Clastic vs. Chemical", text: "Sedimentary rocks are broadly classified into two main categories based on their origin: clastic and chemical/organic. Clastic sedimentary rocks, such as Sandstone, Siltstone, and Shale, are composed of discrete fragments (clasts) of pre-existing rocks and minerals that have been physically transported and deposited. They are classified primarily by grain size. In contrast, chemical sedimentary rocks form when dissolved mineral components precipitate directly from a water solution. A classic example is Rock Salt (Halite), which forms as ancient seas evaporate. Organic sedimentary rocks, like Limestone or Coal, are a sub-set formed from the accumulation of biological debris, such as seashells or decayed plant matter. Limestone, for instance, often originates from the calcium carbonate skeletons of coral and microscopic marine organisms, making it a direct record of ancient oceanic life and chemistry."),
                    ContentSection(subTitle: "4. Stratification", text: "Stratification, or bedding, is the most defining characteristic of sedimentary rocks, appearing as distinct horizontal layers or 'strata.' Each layer represents a specific interval of time and a particular set of environmental conditions during deposition. A single bed might represent a seasonal flood, a massive dust storm, or a slow accumulation of organic matter on the seafloor. The Principle of Superposition dictates that in an undisturbed sequence, the oldest layers are at the bottom and the youngest at the top. Geologists study features within these layers, such as cross-bedding (indicating ancient wind or water currents), ripple marks, and mud cracks, to reconstruct 'paleoenvironments.' By reading these 'pages' of the Earth's history book, we can visualize how landscapes have shifted from lush tropical forests to arid deserts over millions of years."),
                    
                    
                    
                    ContentSection(subTitle: "5. Fossil Preservation", text: "Sedimentary rocks serve as the planet's primary biological archive, as they are the only rocks capable of preserving fossils effectively. Because these rocks form at the Earth's surface under relatively low temperature and pressure, the delicate remains of plants and animals—such as bones, shells, leaves, and even footprints—can be buried and protected before they decompose. Over time, these remains may undergo permineralization, where minerals replace the organic structure, turning it into stone. This fossil record is indispensable for the science of Paleontology, allowing us to track the evolution of life through the Phanerozoic Eon, identify mass extinction events, and correlate the ages of rock layers across different continents. Without the preservation provided by sedimentary systems, our understanding of the history of life on Earth would be virtually non-existent."),
                    
                ]
            )
            
        case "Volcanic Activity":
            return DetailedContent(
                mainTitle: "Volcanic Activity",
                sections: [
                    ContentSection(subTitle: "1. Magma Genesis", text: "Magma formation is a complex thermodynamic process occurring deep within the Earth's mantle or lower crust through the partial melting of solid silicate rocks. This process is primarily triggered by three mechanisms: decompression melting, where upward-moving mantle rock experiences a drop in pressure at mid-ocean ridges; flux melting, where volatiles like water lower the melting point of the mantle at subduction zones; and heat transfer, where rising basaltic magma melts the surrounding crust. The behavior of the resulting magma is heavily dictated by its viscosity, which is a function of its temperature and silica ($SiO_2$) content. High-silica rhyolitic magmas are extremely viscous and trap gases, leading to explosive potential, whereas low-silica basaltic magmas flow easily, resulting in more peaceful, effusive activity."),
                    ContentSection(subTitle: "2. Types of Volcanoes", text: "Volcanoes manifest in diverse morphologies dictated by the chemistry of their lava and the nature of their eruptions. Shield volcanoes, such as Mauna Loa in Hawaii, feature broad, gentle slopes formed by the accumulation of highly fluid, low-viscosity basaltic lava that can travel great distances. In stark contrast, Stratovolcanoes (or composite volcanoes), like Mount Fuji or Mount St. Helens, exhibit steep profiles built from alternating layers of viscous lava flows and explosive pyroclastic debris. These are often associated with subduction zones and are prone to violent eruptions. Cinder cones represent the simplest form, consisting of small, steep-sided mounds built from ejected 'scoria' or volcanic cinders that accumulate around a single vent during short-lived eruptive episodes."),
                    ContentSection(subTitle: "3. Eruption Styles", text: "The eruptive style of a volcano is fundamentally determined by the volatile gas content and the magma's resistance to flow (viscosity). Effusive eruptions occur when magma is fluid enough to allow gas bubbles to escape easily, resulting in steady streams of lava that gracefully coat the landscape. Conversely, explosive eruptions occur when high-viscosity magma prevents gas escape, causing pressure to build until it catastrophically shatters the magma into ash and tephra, often sending plumes into the stratosphere. To quantify these events, volcanologists use the Volcanic Explosivity Index (VEI), a logarithmic scale ranging from 0 to 8 based on the volume of ejected material and plume height. For context, a VEI-8 'super-eruption' can eject over 1,000 cubic kilometers of material, altering global geography."),
                    ContentSection(subTitle: "4. Pyroclastic Flows", text: "Among the most lethal of all volcanic phenomena is the pyroclastic flow, a searing, high-density current of incandescent gas and rock fragments (tephra). These flows are typically generated by the collapse of an eruption column or the failure of a viscous lava dome. Moving under the force of gravity, they race down volcanic flanks at velocities exceeding 100 km/h and can reach temperatures of up to 1,000°C. Because they are ground-hugging and incredibly fast, they bypass almost all topographic obstacles, incinerating organic matter and leveling man-made structures instantly. Historical disasters like the destruction of Pompeii by Mount Vesuvius or the 1902 eruption of Mount Pelée underscore the terrifying destructive power of these gravity-driven density currents."),
                    ContentSection(subTitle: "5. Global Climate Link", text: "Large-scale volcanic activity serves as a powerful driver of global climate fluctuation. During major explosive events, massive quantities of sulfur dioxide ($SO_2$) gas are injected into the stratosphere. These gases react with water vapor to form fine sulfate aerosol mists that linger for years. These aerosols act as a planetary mirror, reflecting incoming solar radiation back into space and preventing it from reaching the surface. This results in 'volcanic winters,' characterized by a significant drop in average global temperatures. A famous example is the 1815 eruption of Mount Tambora, which led to the 'Year Without a Summer' in 1816, causing widespread crop failures and famine across Europe and North America, proving that a single geological event can destabilize human civilization globally.")
                ]
            )
            
        case "Paleontology":
            return DetailedContent(
                mainTitle: "Paleontology & History",
                sections: [
                    ContentSection(subTitle: "1. Fossilization Process", text: "Fossilization is an extraordinarily rare geological occurrence, as the natural tendency of organic matter is to decompose and recycle back into the ecosystem. For a fossil to form, an organism must usually undergo rapid burial by sediment shortly after death, which isolates the remains from oxygen, scavengers, and aerobic bacteria. Over millennia, as layers of sediment accumulate, the resulting pressure and mineral-rich groundwater facilitate permineralization. In this process, microscopic pores in bones or shells are filled with minerals like silica or calcite, effectively turning the biological remains into stone. Other forms include carbonization, where only a thin film of carbon remains, or mold-and-cast preservation, where the original material dissolves entirely but leaves a perfect three-dimensional impression in the surrounding rock matrix."),
                    ContentSection(subTitle: "2. Types of Fossils", text: "Paleontology extends far beyond the study of fossilized skeletons; it encompasses all evidence of prehistoric life. Body fossils include the actual remains of an organism, such as teeth, bones, or petrified wood. However, trace fossils (ichnofossils) provide crucial insights into the ethology, or behavior, of extinct species. These include footprints (trackways), which reveal speed and gait; burrows, which show housing habits; and coprolites (fossilized dung), which provide a direct record of ancient diets and digestive health. Additionally, chemical fossils or 'biomarkers' consist of organic compounds that can persist for billions of years, allowing scientists to detect the presence of microscopic life in rocks that are too old or too deformed to contain visible structural fossils."),
                    ContentSection(subTitle: "3. Geologic Time Scale", text: "Fossils serve as the primary biological clocks used to calibrate the Geologic Time Scale. The practice of biostratigraphy relies on 'index fossils'—species that were geographically widespread, easily recognizable, and existed for a very narrow window of geologic time. By identifying the same index fossils in different rock layers across the globe, geologists can perform 'correlation,' proving that those layers were deposited simultaneously. This allowed early scientists to divide Earth's 4.6-billion-year history into distinct Eons, Eras, Periods, and Epochs. For instance, the presence of certain Trilobite species immediately identifies a rock layer as belonging to the Paleozoic Era, providing a relative dating framework that was used long before the invention of absolute radiometric dating techniques."),
                    ContentSection(subTitle: "4. Mass Extinctions", text: "The history of life is punctuated by five major mass extinction events, where the global biodiversity was slashed by over 75% in a geologically brief period. The most iconic is the Cretaceous-Paleogene (K-Pg) extinction 66 million years ago, which terminated the reign of non-avian dinosaurs. Current evidence points to a 'double-whammy' cause: the impact of a 10-km wide asteroid in the Yucatan Peninsula (the Chicxulub crater) and massive volcanic outpourings in India (the Deccan Traps). These events triggered a collapse of the food chain by blocking sunlight and causing acid rain. Studying these past catastrophes is not just about understanding the death of dinosaurs; it is essential for assessing the 'Sixth Extinction' currently driven by human activity, as it reveals how ecosystems respond to rapid environmental stress and how long they take to recover."),
                    ContentSection(subTitle: "5. Evolution Records", text: "The fossil record provides the only tangible, chronological evidence of the grand patterns of evolution over eons. By meticulously documenting transitional fossils—'missing links'—paleontologists can trace the anatomical transformations of lineages. Famous examples include *Tiktaalik*, which shows the transition from lobe-finned fish to four-legged amphibians, and *Archaeopteryx*, which bridges the gap between feathered theropod dinosaurs and modern birds. These records allow us to observe how complex structures, like the vertebrate eye or the mammalian inner ear, developed through incremental changes. While the fossil record is inherently incomplete due to the selective nature of preservation, it offers an irrefutable narrative of life's resilience and its constant adaptation to an ever-changing planet, from the first single-celled organisms to the rise of hominids.")
                ]
            )
            
        case "Soil Science":
            return DetailedContent(
                mainTitle: "Soil Science (Pedology)",
                sections: [
                    ContentSection(subTitle: "1. Soil Formation", text: "Soil is much more than mere 'dirt'; it is a dynamic, living skin of the Earth known as the pedosphere. It forms through the slow, relentless weathering of parent rock (lithic material) through physical, chemical, and biological means. This process is governed by five main factors: parent material, climate, topography, biological organisms, and time. Over centuries, lichens and mosses begin to break down rock surfaces, while water and temperature fluctuations shatter the mineral matrix. As organic matter from dead plants and animals (humus) mixes with these mineral particles, a complex matrix is created that can support higher plant life. It can take anywhere from 100 to 1,000 years to form just one centimeter of topsoil, making it a precious, finite resource that is essential for all terrestrial life."),
                    ContentSection(subTitle: "2. Soil Horizons", text: "A mature soil profile is organized into distinct horizontal layers known as horizons, each with unique physical and chemical characteristics. At the surface lies the 'O' horizon, composed of fresh and decaying organic litter. Below it is the 'A' horizon (topsoil), where decomposed organic matter mixes with mineral grains, creating a dark, nutrient-rich layer vital for plant growth. The 'E' horizon is a zone of leaching (eluviation), where minerals are washed downward by rainwater. These minerals accumulate in the 'B' horizon (subsoil), often rich in clays or iron oxides. Finally, the 'C' horizon consists of partially disintegrated parent rock, which sits atop the unweathered 'R' horizon or bedrock. Understanding this stratigraphy is crucial for civil engineering, agriculture, and environmental contamination assessments."),
                    ContentSection(subTitle: "3. Texture and Structure", text: "Soil texture is a fundamental physical property defined by the relative proportions of sand (large particles), silt (medium), and clay (microscopic). Sand provides excellent drainage but poor nutrient retention, while clay holds water and nutrients tenaciously but can become waterlogged and compacted, preventing root respiration. The 'gold standard' for agriculture is Loam, a balanced mixture that provides the ideal ratio of aeration, drainage, and nutrient-holding capacity. Beyond texture is 'soil structure,' or how these particles clump together into aggregates called 'peds.' A healthy soil structure allows for pore spaces that hold both water (for hydration) and air (for root oxygen). If the structure is destroyed by heavy machinery or over-tilling, the soil loses its productivity and becomes susceptible to catastrophic erosion."),
                    ContentSection(subTitle: "4. Nutrient Cycling", text: "Soil serves as a massive biochemical laboratory where the essential elements of life are recycled through the 'Soil Food Web.' Decomposers, including earthworms, fungi, and billions of bacteria per gram of soil, break down complex organic molecules into simple inorganic forms that plants can absorb. This process, known as mineralization, releases critical macronutrients: Nitrogen (for leaf growth), Phosphorus (for root and fruit development), and Potassium (for overall cellular health), often abbreviated as N-P-K. This cycle is a delicate balance; for instance, certain bacteria live in symbiotic relationships with plant roots to 'fix' nitrogen from the air into the soil. Without this constant biological processing, the Earth's surface would be a sterile wasteland, and the movement of energy through the terrestrial food chain would ground to a complete halt."),
                    ContentSection(subTitle: "5. Erosion and Conservation", text: "Soil erosion is one of the most pressing environmental challenges of the modern age, as it is a non-renewable resource on human timescales. Natural erosion by wind and water is drastically accelerated by human activities such as deforestation, overgrazing, and industrial monoculture, which strip away the protective vegetative cover. When topsoil is lost, the land loses its fertility and its ability to sequester carbon, leading to desertification and increased atmospheric $CO_2$. Soil conservation strategies are therefore vital for global food security. These include 'no-till' farming to maintain soil structure, contour plowing to slow water runoff on slopes, and the use of cover crops to protect the surface during the off-season. Preserving the integrity of the soil is not just an agricultural concern; it is a fundamental requirement for maintaining the stability of the global biosphere.")
                ]
            )
            
        case "Oceanography":
            return DetailedContent(
                mainTitle: "Oceanography & Seafloor",
                sections: [
                    ContentSection(subTitle: "1. Ocean Basins", text: "The ocean floor is far from being a monotonous, flat expanse; it boasts the most dramatic and extreme topography found anywhere on our planet. The transition from land to the deep ocean begins with the continental shelf, a relatively shallow, gently sloping submerged edge of the continent that is biologically rich and economically significant. Beyond the shelf break lies the steep continental slope, which plunges down to the deep ocean floor, often scarred by massive submarine canyons carved by turbidity currents. At the base of the slope is the continental rise, where sediments accumulate before giving way to the vast abyssal plains. These plains, lying at depths of 3,000 to 6,000 meters, are among the flattest places on Earth, covered by thick layers of fine-grained pelagic sediment that have settled over millions of years, masking the rugged volcanic crust beneath."),
                    ContentSection(subTitle: "2. Mid-Ocean Ridges", text: "The mid-ocean ridge system is a continuous, 65,000-kilometer-long underwater mountain range that effectively circles the entire globe like the seams on a baseball. These ridges are the sites of active seafloor spreading, a fundamental process of plate tectonics where divergent boundaries pull apart. As the oceanic plates separate, the underlying mantle undergoes decompression melting, allowing basaltic magma to rise and solidify, creating brand-new oceanic lithosphere. Along the axis of these ridges, seawater seeps into cracks, is heated by the underlying magma, and erupts as mineral-rich hydrothermal vents, or 'black smokers.' These vents support unique chemosynthetic ecosystems that exist in total darkness, relying on chemical energy rather than sunlight, providing a fascinating glimpse into the potential origins of life on Earth."),
                    ContentSection(subTitle: "3. Ocean Trenches", text: "Ocean trenches represent the deepest and most hostile environments on the planet, occurring at convergent plate boundaries where subduction is taking place. In these zones, an oceanic plate is forced downward into the mantle, creating a long, narrow topographic depression. The most famous example, the Mariana Trench in the Western Pacific, reaches the 'Challenger Deep' at approximately 11,000 meters below sea level—a depth greater than the height of Mount Everest. The pressures at these depths are staggering, exceeding 1,000 times the atmospheric pressure at sea level. Trenches are not only geographic extremes but also seismic hotspots; the friction and tension as one massive plate grinds beneath another generate the world's most powerful megathrust earthquakes and drive the volcanic activity of island arcs located parallel to the trench."),
                    ContentSection(subTitle: "4. Marine Sediments", text: "The seafloor serves as a global repository for sediments that provide a high-resolution archive of Earth's paleoclimate and geological history. These sediments are primarily classified into two types: terrigenous and biogenous. Terrigenous (or lithogenous) sediments consist of mineral grains weathered from continental rocks and transported to the ocean by rivers, wind, and glaciers. Biogenous sediments, on the other hand, are formed from the 'hard parts'—the microscopic shells and skeletons—of marine organisms like foraminifera, diatoms, and radiolaria. When these organisms die, their remains sink and accumulate as 'ooze.' By analyzing the oxygen isotopes and chemical composition within these sedimentary layers, paleoceanographers can reconstruct sea-surface temperatures, ice volume, and ocean circulation patterns dating back tens of millions of years."),
                    ContentSection(subTitle: "5. Seamounts and Islands", text: "The deep ocean floor is dotted with thousands of isolated volcanic peaks known as seamounts, which are often formed by mantle plumes or 'hotspots' that remain stationary as tectonic plates move over them. A seamount is technically defined as an underwater mountain rising at least 1,000 meters above the seafloor but not reaching the surface. If a volcano grows large enough to break the ocean's surface, it becomes a volcanic island, such as the Hawaiian Islands or Iceland. Over geologic time, as the plate carries the island away from its volcanic source, the island becomes dormant, begins to erode due to wave action, and eventually sinks back below the surface. If the top is flattened by erosion before it sinks, it is called a guyot. These submerged peaks often serve as 'undersea oases,' attracting a high diversity of marine life due to the upwelling of nutrient-rich currents.")
                ]
            )
            
        case "Metamorphic Rocks":
            return DetailedContent(
                mainTitle: "Metamorphic Processes",
                sections: [
                    ContentSection(subTitle: "1. Heat and Pressure", text: "Metamorphism is the solid-state transformation of a pre-existing rock (the protolith) into a new form due to profound changes in physical and chemical conditions. This process occurs deep within the Earth's crust where temperatures and pressures are high enough to destabilize minerals but not high enough to cause melting. Heat is perhaps the most critical agent, as it provides the energy required to break chemical bonds and drive the recrystallization of minerals into larger or more stable configurations. Pressure comes in two forms: lithostatic (confining) pressure, which results from the weight of overlying rock and decreases the volume of the rock, and directed pressure, which shapes the rock's texture. During these transitions, the chemical composition of the rock usually remains the same, but the mineralogy and texture are completely redefined."),
                    ContentSection(subTitle: "2. Foliation", text: "A primary diagnostic feature of many metamorphic rocks is foliation, a term describing the parallel alignment of platy or elongated minerals, such as mica or hornblende. This texture is a direct result of differential stress—pressure that is stronger in one direction than others—which typically occurs during tectonic collisions. Under this intense squeezing, minerals rotate or grow in a direction perpendicular to the maximum stress, creating a layered or banded appearance. The degree of foliation reflects the metamorphic 'grade'; for example, low-grade metamorphism of shale produces slate (perfect cleavage), medium-grade produces schist (visible mica flakes), and high-grade produces gneiss, which exhibits distinct light and dark mineral banding due to ion migration during the recrystallization process."),
                    ContentSection(subTitle: "3. Contact Metamorphism", text: "Contact metamorphism, also known as thermal metamorphism, occurs when 'cold' country rock is intruded by a mass of hot magma. The high temperature of the magma effectively 'bakes' the surrounding rock, creating a metamorphic zone called an aureole. Because this process is driven primarily by intense heat rather than pressure, the resulting rocks usually lack foliation and instead have a granoblastic (equigranular) texture. Classic examples include the transformation of limestone into marble, where the calcite grains grow larger and interlock, and the conversion of pure quartz sandstone into quartzite, one of the hardest and most durable rocks on the planet. This localized process is essential for understanding the heat flow around igneous intrusions and the formation of certain metallic ore deposits."),
                    ContentSection(subTitle: "4. Regional Metamorphism", text: "Regional metamorphism is a massive-scale process that affects thousands of square kilometers of the Earth's crust, typically during mountain-building events (orogenies) at convergent plate boundaries. As tectonic plates collide, huge volumes of rock are buried to great depths, where they are subjected to both extreme heat and intense directed pressure. This dual force causes widespread recrystallization and the development of complex, large-scale structures like folds and faults. Regional metamorphism creates a broad spectrum of rocks, and by mapping 'index minerals'—such as garnet, staurolite, or kyanite—geologists can determine the peak temperature and pressure conditions the rock experienced. This allows scientists to reconstruct the ancient history of mountain ranges like the Appalachians or the Alps, even long after the peaks themselves have eroded away."),
                    ContentSection(subTitle: "5. The Rock Cycle", text: "Metamorphism represents a critical 'recycling' phase within the grand rock cycle, demonstrating the Earth's ability to repurpose existing materials. Any rock type—be it igneous, sedimentary, or an older metamorphic rock—can serve as a protolith for new metamorphic transformation if the environment changes. For instance, a volcanic basalt can be transformed into a greenstone or an eclogite depending on the depth of subduction. If the metamorphic process continues and the temperature rises above the melting point, the rock will eventually turn into magma, which will then cool to form new igneous rock, effectively restarting the cycle. This continuous transformation ensures that the Earth's crust is never static, constantly responding to the internal heat and external tectonic forces that drive our planet's geological evolution.")
                ]
            )
            
        case "Crystal Systems":
            return DetailedContent(
                mainTitle: "Crystal Crystallography",
                sections: [
                    ContentSection(subTitle: "1. Internal Order", text: "The fundamental essence of a crystal lies in its highly disciplined internal order, a characteristic that separates crystalline solids from amorphous materials like glass. This order is defined by the unit cell, the smallest repeating structural unit that contains the full symmetry of the crystal's atomic arrangement. These unit cells are stacked in three-dimensional space to form a space lattice. The specific coordinates and bonds between atoms—whether ionic, covalent, or metallic—dictate the macroscopic properties of the mineral. For example, the exceptional hardness of a diamond is a direct consequence of its carbon atoms being arranged in a rigid, tetrahedral covalent network, whereas the softness of graphite results from its atoms being arranged in weakly bonded sheets. Thus, the external beauty of a crystal is simply a visible reflection of its invisible, perfectly organized atomic interior."),
                    ContentSection(subTitle: "2. The Seven Systems", text: "In the science of crystallography, every known mineral crystal is classified into one of seven distinct crystal systems, categorized by the geometry of their axes and the angles between them. These systems—Cubic, Tetragonal, Orthorhombic, Hexagonal, Trigonal, Monoclinic, and Triclinic—define the limits of symmetry. The Cubic system (e.g., Pyrite) is the most symmetrical, with three equal axes at right angles, while the Triclinic system (e.g., Albite) is the least symmetrical, with three unequal axes and no right angles. This classification is vital for mineral identification because a crystal's system determines its optical properties, such as how it refracts light or whether it exhibits pleochroism. Understanding these systems allows geologists to predict the cleavage planes and growth habits of a specimen even before detailed laboratory analysis is performed."),
                    ContentSection(subTitle: "3. Growth Conditions", text: "The development of a perfect crystal is a delicate race against time and space. For a crystal to exhibit its ideal, textbook geometric faces (euhedral form), it must grow in an unconfined environment—such as a pocket of gas or a fluid-filled cavity—where it has the freedom to expand outward according to its internal lattice. These ideal conditions are often found in geodes or hydrothermal veins where mineral-rich fluids circulate slowly over thousands of years. Conversely, if a crystal grows in a crowded environment where it competes for space with neighboring minerals, it will develop an irregular, 'anhedral' shape. Factors such as cooling rate, pressure, and the concentration of chemical elements also play a role; slow cooling typically favors the growth of large, well-defined crystals, while rapid cooling results in a fine-grained or even glassy texture."),
                    ContentSection(subTitle: "4. Polymorphism", text: "Polymorphism is a fascinating geological phenomenon where a single chemical substance can exist in two or more different crystal structures depending on the environmental conditions of temperature and pressure. The most famous example is pure carbon: under the extreme pressures of the Earth's mantle, it crystallizes in the Cubic system as Diamond, but at the Earth's surface, it is more stable in the Hexagonal system as Graphite. Another common example is Calcium Carbonate ($CaCO_3$), which forms the mineral Calcite in most environments but crystallizes as Aragonite under different pressure conditions. Polymorphs are of immense value to geologists because they act as 'geobarometers' and 'geothermometers,' indicating the specific depths and temperatures at which a rock was formed or transformed throughout its history."),
                    ContentSection(subTitle: "5. X-Ray Diffraction", text: "Because the distances between atoms in a crystal lattice are on the order of angstroms (0.1 nanometers), they are far too small to be seen with even the most powerful visible-light microscopes. To map this internal world, scientists utilize X-ray diffraction (XRD). When a beam of X-rays is aimed at a crystal, the waves interact with the electron clouds of the atoms and are 'diffracted' or scattered in specific patterns. By measuring the angles and intensities of these scattered rays, researchers can apply Bragg's Law to calculate the precise spacing between atomic planes. This technique, pioneered in the early 20th century, revolutionized mineralogy by allowing for the definitive identification of minerals and the discovery of how atoms are bonded together, providing the foundation for modern solid-state physics and chemistry.")
                ]
            )
            
        case "Erosion Processes":
            return DetailedContent(
                mainTitle: "Erosion & Weathering",
                sections: [
                    ContentSection(subTitle: "1. Mechanical Weathering", text: "Mechanical (or physical) weathering is the process of breaking rock into increasingly smaller fragments through physical force, without altering the rock's chemical identity. One of the most potent forces is frost wedging: as water seeps into cracks and freezes, it expands by approximately 9%, exerting immense outward pressure that eventually shatters the rock. In arid environments, thermal expansion and contraction caused by extreme day-to-night temperature shifts can cause the outer layers of rock to peel away like an onion—a process known as exfoliation. Other mechanisms include 'salt wedging' in coastal areas and 'biological weathering,' where the growing roots of trees act as wedges to pry apart solid stone. By increasing the total surface area of the rock, mechanical weathering effectively 'prepares' the material for more rapid chemical decomposition."),
                    ContentSection(subTitle: "2. Chemical Weathering", text: "Chemical weathering involves the complex decomposition of mineral structures through chemical reactions, essentially turning hard minerals into new, softer substances. The presence of water is almost always required for these reactions. Oxidation occurs when minerals (especially those rich in iron) react with oxygen to form rust-like oxides, weakening the rock. Carbonation is the process where rainwater, which becomes slightly acidic by absorbing atmospheric $CO_2$, dissolves minerals like calcite in limestone, creating vast cave systems and karst landscapes. Hydrolysis is perhaps the most important process in soil formation, as it transforms hard silicate minerals like feldspar into soft clay minerals. These chemical changes are most aggressive in warm, humid tropical climates, where they can turn solid bedrock into thick layers of weathered material called saprolite in a geologically short period."),
                    ContentSection(subTitle: "3. Water Erosion", text: "Running water is arguably the most significant agent of erosion and landscape evolution on Earth. It operates through several mechanisms: hydraulic action (the sheer force of moving water), abrasion (where the water uses sand and stones as tools to grind down rock), and solution (dissolving minerals). On a small scale, water begins as sheet erosion across a field, which then concentrates into rills and gullies. On a massive scale, rivers carve vast canyons—like the Grand Canyon—and create wide floodplains by transporting billions of tons of sediment from the mountains to the sea. The energy of a river is a function of its gradient and volume; even the hardest granite can be smoothed and cut over time by the constant, relentless passage of sediment-laden water, ultimately lowering the entire continent toward sea level."),
                    ContentSection(subTitle: "4. Wind and Ice", text: "In environments where water is scarce or locked away, wind and ice take over as primary erosional forces. In deserts, wind erosion—or eolian process—shapes the land through deflation (lifting loose particles) and abrasion (sandblasting rock surfaces). This creates unique landforms like sand dunes, yardangs, and desert pavement. In high latitudes and altitudes, glacial ice acts as a massive 'geological bulldozer.' As glaciers flow slowly under their own weight, they pluck rocks from the ground and grind them into the bedrock below, a process that creates 'rock flour' and polishes stone surfaces. Glaciers are responsible for carving dramatic U-shaped valleys, sharp mountain peaks (horns), and deep fjords, moving more material in a single season than wind could move in a millennium."),
                    ContentSection(subTitle: "5. Human Impact", text: "While erosion is a natural geological process, human intervention has accelerated its rate by a factor of 10 to 100 in many parts of the world. Activities such as large-scale deforestation for agriculture, open-pit mining, and poorly planned urban development strip the land of its natural protective vegetative cover. Without roots to bind the soil and a canopy to break the impact of rain, nutrient-rich topsoil is rapidly washed into rivers or blown away by the wind. This 'accelerated erosion' leads to the siltation of waterways, which destroys aquatic habitats, and causes land degradation that threatens global food security. Modern soil conservation techniques—such as terracing, windbreaks, and the implementation of cover crops—are essential strategies designed to slow these man-made losses and preserve the thin layer of soil that sustains terrestrial life.")
                ]
            )
            
        default:
            return DetailedContent(
                mainTitle: title,
                sections: [
                    ContentSection(subTitle: "Module Introduction", text: "Welcome to the \(title) scientific module. This section covers the fundamental principles of geological science and Earth's dynamic systems as observed through field research."),
                    ContentSection(subTitle: "Core Principles", text: "The primary focus here is the analysis of physical data collected from various geological sites. We examine the chemical and structural properties that define this specific branch of Earth science."),
                    ContentSection(subTitle: "Field Observations", text: "Scientific data suggests that these processes are ongoing and influenced by a variety of environmental factors. Detailed mapping and sampling are required for a complete understanding of the phenomena."),
                    ContentSection(subTitle: "Case Studies", text: "Recent studies in this field have highlighted the importance of interdisciplinary research. Combining geology with physics and chemistry provides a more holistic view of the subject matter."),
                    ContentSection(subTitle: "Summary", text: "This overview provides the foundation for more advanced study. Students are encouraged to review the terminology and key concepts before proceeding to the practical exams.")
                ]
            )
        }
    }
    
    private func renderContent(_ content: DetailedContent) {
        // Main Title
        let mainLabel = UILabel()
        mainLabel.text = content.mainTitle
        mainLabel.textColor = .systemOrange
        mainLabel.font = .systemFont(ofSize: 36, weight: .black)
        mainLabel.numberOfLines = 0
        mainLabel.textAlignment = .center
        stackView.addArrangedSubview(mainLabel)
        
        // Sections
        for section in content.sections {
            let subLabel = UILabel()
            subLabel.text = section.subTitle
            subLabel.textColor = .white
            subLabel.font = .systemFont(ofSize: 26, weight: .bold)
            
            let textLabel = UILabel()
            textLabel.text = section.text
            textLabel.textColor = .white
            textLabel.font = .systemFont(ofSize: 20, weight: .regular)
            textLabel.numberOfLines = 0
            
            stackView.addArrangedSubview(subLabel)
            stackView.addArrangedSubview(textLabel)
            
            // Маленький отступ между секциями
            stackView.setCustomSpacing(10, after: subLabel)
        }
    }
    
    @objc private func backAction() {
        dismiss(animated: true)
    }
}
