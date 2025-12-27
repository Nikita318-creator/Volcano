import Foundation

class QuizProcessViewModel {
    
    func getQuestions(for title: String) -> [QuizQuestion] {
        switch title {
        case "Plate Tectonics":
            return [
                QuizQuestion(questionText: "Who first proposed the theory of Continental Drift?", options: ["Charles Darwin", "Alfred Wegener", "Isaac Newton", "Albert Einstein"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What was the name of the supercontinent that existed 200 million years ago?", options: ["Laurasia", "Gondwana", "Pangea", "Tethys"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which layer of the Earth is broken into tectonic plates?", options: ["Asthenosphere", "Lithosphere", "Outer Core", "Mesosphere"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What type of boundary occurs where plates slide past each other?", options: ["Divergent", "Convergent", "Transform", "Subduction"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "The San Andreas Fault is an example of which boundary type?", options: ["Transform", "Divergent", "Convergent", "Reactive"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "What process occurs at mid-ocean ridges?", options: ["Subduction", "Seafloor spreading", "Mountain building", "Continental collision"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which plate is the largest of all tectonic plates?", options: ["African Plate", "Eurasian Plate", "Pacific Plate", "Antarctic Plate"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the driving force behind plate movement?", options: ["Lunar gravity", "Mantle convection", "Earth's rotation", "Ocean currents"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Where is new crust primarily created?", options: ["Deep-sea trenches", "Mid-ocean ridges", "Mountain ranges", "Transform faults"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What happens when an oceanic plate collides with a continental plate?", options: ["It floats higher", "It subducts", "It forms a rift valley", "Nothing happens"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The Himalayas were formed by which type of collision?", options: ["Oceanic-Oceanic", "Oceanic-Continental", "Continental-Continental", "Transform"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What are the deepest parts of the ocean floor called?", options: ["Abyssal plains", "Ridges", "Trenches", "Shelves"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which instrument is used to measure precise plate movement today?", options: ["Seismograph", "GPS", "Barometer", "Anemometer"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the plastic-like layer below the lithosphere?", options: ["Inner Core", "Crust", "Asthenosphere", "Exosphere"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which ocean is currently expanding due to seafloor spreading?", options: ["Pacific Ocean", "Atlantic Ocean", "Indian Ocean", "Arctic Ocean"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What do we call a chain of volcanic islands formed by subduction?", options: ["Island arc", "Hotspot", "Rift zone", "Atoll"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "What is the 'Ring of Fire'?", options: ["A desert in Africa", "A belt of volcanoes around the Pacific", "A forest fire zone", "The Earth's core"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which type of crust is typically denser?", options: ["Continental crust", "Oceanic crust", "Both are equal", "Mantle crust"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What evidence did Wegener use to support his theory?", options: ["Satellite photos", "Fossil matching across oceans", "GPS data", "Sonar mapping"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What forms when two continental plates pull apart?", options: ["Mid-ocean ridge", "Rift valley", "Deep trench", "Fold mountain"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "At what rate do tectonic plates typically move per year?", options: ["1-10 meters", "2-10 centimeters", "50-100 centimeters", "1 kilometer"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The Mariana Trench is a result of which process?", options: ["Divergence", "Subduction", "Transformation", "Erosion"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which of these is NOT a major tectonic plate?", options: ["Nazca Plate", "Cocos Plate", "London Plate", "Juan de Fuca Plate"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the name of the process where one plate sinks beneath another?", options: ["Convection", "Subduction", "Induction", "Conduction"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Magnetic 'striping' on the seafloor provided evidence for what?", options: ["Continental Drift", "Seafloor Spreading", "Earthquakes", "Tsunamis"], correctAnswerIndex: 1)
            ]
            
        case "Mineralogy":
            return [
                QuizQuestion(questionText: "What is the primary defining characteristic of a mineral?", options: ["Organic origin", "Ordered internal atomic structure", "Liquid state at room temperature", "Random chemical composition"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which mineral is the hardest known natural substance on the Mohs scale?", options: ["Quartz", "Topaz", "Corundum", "Diamond"], correctAnswerIndex: 3),
                QuizQuestion(questionText: "What is the softest mineral on the Mohs scale (Rank 1)?", options: ["Talc", "Gypsum", "Calcite", "Fluorite"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "The color of a mineral's powder when rubbed against a porcelain plate is called:", options: ["Luster", "Cleavage", "Streak", "Fracture"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the most abundant group of minerals in the Earth's crust?", options: ["Carbonates", "Oxides", "Sulfides", "Silicates"], correctAnswerIndex: 3),
                QuizQuestion(questionText: "The way a mineral reflects light from its surface is known as:", options: ["Luster", "Transparency", "Refraction", "Birefringence"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Which mineral reacts with hydrochloric acid by fizzing (releasing CO2)?", options: ["Quartz", "Calcite", "Halite", "Galena"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The tendency of a mineral to break along flat, parallel planes is called:", options: ["Fracture", "Hardness", "Cleavage", "Density"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the basic building block of all silicate minerals?", options: ["Carbon-Oxygen ring", "Silicon-Oxygen tetrahedron", "Iron-Magnesium chain", "Aluminum-Oxygen sheet"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Common table salt is the mineral known as:", options: ["Fluorite", "Halite", "Sylvite", "Gypsum"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which mineral is often called 'fool's gold' due to its metallic yellow appearance?", options: ["Chalcopyrite", "Hematite", "Pyrite", "Magnetite"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the chemical formula for Quartz?", options: ["CaCO3", "NaCl", "Fe2O3", "SiO2"], correctAnswerIndex: 3),
                QuizQuestion(questionText: "A mineral that can be attracted by a magnet is:", options: ["Magnetite", "Bauxite", "Sphalerite", "Cinnabar"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Which mineral property is described as 'conchoidal' if it breaks like glass?", options: ["Cleavage", "Luster", "Fracture", "Streak"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the hardness of Quartz on the Mohs scale?", options: ["5", "6", "7", "8"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which of these is a native element mineral?", options: ["Gold", "Feldspar", "Mica", "Olivine"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Minerals that have the same chemical composition but different crystal structures are:", options: ["Isotopes", "Polymorphs", "Isomorphs", "Silicates"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Ruby and Sapphire are gem-quality varieties of which mineral?", options: ["Beryl", "Quartz", "Corundum", "Topaz"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which mineral group contains the salt used to make drywall and plaster?", options: ["Sulfates (Gypsum)", "Halides", "Oxides", "Carbonates"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "The 'double refraction' effect is most famous in which mineral variety?", options: ["Iceland Spar (Calcite)", "Amethyst", "Emerald", "Rose Quartz"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Which mineral is the main ore of lead?", options: ["Galena", "Hematite", "Cassiterite", "Pyrolusite"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "What determines the physical properties of a mineral (like hardness and cleavage)?", options: ["External color", "Age of the rock", "Internal arrangement of atoms", "Size of the specimen"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Feldspar is classified as which type of silicate?", options: ["Sheet silicate", "Framework silicate", "Chain silicate", "Isolated silicate"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What color is the streak of the iron ore Hematite (even if the specimen is black)?", options: ["White", "Yellow", "Red-brown", "Blue"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which mineral is commonly used as an abrasive due to its hardness of 9?", options: ["Apatite", "Corundum", "Orthoclase", "Topaz"], correctAnswerIndex: 1)
            ]
            
        case "Sedimentary Rocks":
            return [
                QuizQuestion(questionText: "Which process involves the physical or chemical breakdown of rocks at Earth's surface?", options: ["Metamorphism", "Weathering", "Intrusion", "Solidification"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the process of turning loose sediments into solid rock called?", options: ["Lithification", "Erosion", "Crystallization", "Oxidation"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Which sedimentary rock is composed of rounded gravel-sized fragments?", options: ["Breccia", "Sandstone", "Conglomerate", "Shale"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What are the two main steps of lithification?", options: ["Melting and cooling", "Compaction and cementation", "Folding and faulting", "Heating and pressure"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which rock is formed from the remains of ancient microscopic sea organisms (calcium carbonate)?", options: ["Coal", "Limestone", "Chert", "Gypsum"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the primary characteristic of clastic sedimentary rocks?", options: ["Formed from minerals in solution", "Formed from fragments of pre-existing rocks", "Formed from volcanic ash only", "Formed from cooling magma"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Rock salt and rock gypsum are examples of which type of sedimentary rock?", options: ["Clastic", "Organic", "Evaporites (Chemical)", "Bioclastic"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which sedimentary rock is the finest-grained and can be split into thin layers?", options: ["Sandstone", "Siltstone", "Shale", "Conglomerate"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "The process by which dissolved minerals crystallize and glue sediment grains together is:", options: ["Deposition", "Cementation", "Compaction", "Erosion"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "In which environment would you most likely find coal forming?", options: ["Deep ocean", "Desert dunes", "Swamps", "High mountain peaks"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which of these is a common chemical sedimentary rock formed from silica?", options: ["Limestone", "Chert", "Rock salt", "Dolomite"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the horizontal layering in sedimentary rocks called?", options: ["Foliation", "Strata (Bedding)", "Cleavage", "Lineation"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which sedimentary rock is made almost entirely of carbon from ancient plant matter?", options: ["Limestone", "Coal", "Sandstone", "Shale"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Small, wave-like structures on a rock surface that indicate ancient water or wind flow are:", options: ["Mud cracks", "Ripple marks", "Fossils", "Striations"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which rock would be formed by the accumulation of shells and shell fragments?", options: ["Coquina", "Basalt", "Slate", "Quartzite"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "What does the presence of mud cracks in a rock layer suggest about the ancient environment?", options: ["Deep ocean", "Glacial movement", "A periodically drying lake or flood plain", "High-pressure metamorphism"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which clastic rock has sharp, angular fragments indicating it didn't travel far from its source?", options: ["Conglomerate", "Breccia", "Sandstone", "Shale"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the most common mineral found in sandstone?", options: ["Calcite", "Feldspar", "Quartz", "Olivine"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "The settling of sediments out of water or wind is called:", options: ["Erosion", "Deposition", "Weathering", "Transportation"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which sedimentary rock is often used to make glass?", options: ["Limestone", "Quartz Sandstone", "Shale", "Gypsum"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Fossils are almost exclusively found in which type of rock?", options: ["Igneous", "Sedimentary", "Metamorphic", "Volcanic"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which process moves sediment from one location to another?", options: ["Weathering", "Erosion", "Lithification", "Crystallization"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is 'graded bedding'?", options: ["Layers with different colors", "Layers that change grain size from bottom to top", "Layers that are tilted", "Layers with many fossils"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which sedimentary rock is the parent rock of marble?", options: ["Sandstone", "Shale", "Limestone", "Conglomerate"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Sorting of sediments (by size) usually occurs during which stage?", options: ["Weathering", "Transportation", "Lithification", "Burial"], correctAnswerIndex: 1)
            ]
            
        case "Volcanic Activity":
            return [
                QuizQuestion(questionText: "What is molten rock called before it reaches the Earth's surface?", options: ["Lava", "Magma", "Tephra", "Basalt"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which type of volcano is broad and has gentle slopes, like those in Hawaii?", options: ["Stratovolcano", "Cinder Cone", "Shield Volcano", "Composite Volcano"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the most deadly volcanic hazard, consisting of hot gas and rock fragments?", options: ["Lava flow", "Pyroclastic flow", "Lahar", "Ash fall"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "A large, bowl-shaped depression formed after a major eruption and collapse of a volcano is a:", options: ["Crater", "Vent", "Caldera", "Fissure"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which type of magma has the highest silica content and viscosity?", options: ["Basaltic", "Andesitic", "Rhyolitic", "Ultramafic"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is a volcanic mudflow caused by rapidly melting snow or heavy rain called?", options: ["Pumice", "Lahar", "Tsunami", "Geyser"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which volcano type is known for its tall, conical shape and explosive eruptions?", options: ["Shield Volcano", "Stratovolcano", "Dormant Volcano", "Monogenetic field"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The 'Ring of Fire' is a major belt of volcanoes located around which ocean?", options: ["Atlantic Ocean", "Indian Ocean", "Arctic Ocean", "Pacific Ocean"], correctAnswerIndex: 3),
                QuizQuestion(questionText: "What gas is most commonly released during a volcanic eruption?", options: ["Oxygen", "Carbon Dioxide", "Water Vapor", "Sulfur Dioxide"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the term for fragments of volcanic rock and lava blasted into the air?", options: ["Silt", "Tephra", "Magma", "Talus"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which index is used to measure the explosiveness of volcanic eruptions?", options: ["Richter Scale", "VEI (Volcanic Explosivity Index)", "Mohs Scale", "Mercalli Scale"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "A volcano that has not erupted for a long time but could erupt again is called:", options: ["Extinct", "Active", "Dormant", "Ancient"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What forms when lava cools so rapidly that crystals do not have time to grow?", options: ["Pumice", "Obsidian", "Granite", "Scoria"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Mount St. Helens is a famous example of which type of volcano?", options: ["Shield", "Cinder Cone", "Stratovolcano", "Lava Dome"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is a volcanic 'hotspot'?", options: ["A boundary between two plates", "An area of volcanic activity in the middle of a tectonic plate", "The center of a crater", "A very hot desert"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which volcanic rock is so light and porous that it can float on water?", options: ["Basalt", "Obsidian", "Pumice", "Rhyolite"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What do we call lava that has a smooth, billowy, or ropy surface?", options: ["Aa", "Pahoehoe", "Pillow lava", "Blocky lava"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Where does most volcanic activity on Earth occur?", options: ["In the middle of continents", "Along plate boundaries", "In the desert", "Near the North Pole"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the underground pool of liquid rock beneath a volcano called?", options: ["Magma chamber", "Lava tube", "Central vent", "Conduit"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Which of these is a non-explosive volcanic eruption feature?", options: ["Ash cloud", "Pyroclastic surge", "Lava fountain", "Fissure flow"], correctAnswerIndex: 3),
                QuizQuestion(questionText: "What is a major climate effect of a massive volcanic eruption?", options: ["Global warming", "Global cooling (due to ash/aerosols)", "Increased oxygen levels", "No effect on climate"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Small, steep-sided volcanoes built from piles of ejected lava fragments are:", options: ["Calderas", "Shield volcanoes", "Cinder cones", "Geysers"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the main factor that determines whether an eruption is quiet or explosive?", options: ["Age of the volcano", "Magma composition and gas content", "Distance from the ocean", "Air temperature"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Lava that cools underwater forms characteristic structures called:", options: ["Pahoehoe", "Pillow lavas", "Columnar joints", "Vents"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which gas released by volcanoes can cause acid rain?", options: ["Nitrogen", "Argon", "Sulfur Dioxide", "Helium"], correctAnswerIndex: 2)
            ]
            
        case "Paleontology":
            return [
                QuizQuestion(questionText: "What is the scientific study of fossils called?", options: ["Archaeology", "Paleontology", "Biology", "Anthropology"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which of these is most likely to become a fossil?", options: ["Jellyfish", "Muscle tissue", "A tooth", "A leaf"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the process called where minerals replace organic matter in a fossil?", options: ["Carbonization", "Permineralization", "Molding", "Crystallization"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "In which type of rock are fossils almost exclusively found?", options: ["Igneous", "Metamorphic", "Sedimentary", "Volcanic"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What are 'trace fossils'?", options: ["Small fossilized plants", "Fossilized footprints or burrows", "Fragments of bones", "DNA extracted from fossils"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which era is often called the 'Age of Reptiles'?", options: ["Paleozoic", "Mesozoic", "Cenozoic", "Precambrian"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the name of the ancient supercontinent that Alfred Wegener proposed?", options: ["Laurasia", "Pangea", "Gondwana", "Atlantis"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which fossilized substance is actually ancient tree resin?", options: ["Coal", "Amber", "Coprolite", "Chert"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "How old is the Earth estimated to be?", options: ["4.6 million years", "460,000 years", "4.6 billion years", "10 billion years"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is an 'index fossil'?", options: ["A very large fossil", "A fossil used to date rock layers", "A fossil found only in water", "The first fossil ever found"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What event marked the beginning of the Paleozoic era with a sudden diversity of life?", options: ["The Big Bang", "The Cambrian Explosion", "The Great Oxidation Event", "The Jurassic Period"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What are fossilized animal droppings called?", options: ["Gastroliths", "Amber", "Coprolites", "Concretions"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which method is used to determine the absolute age of a fossil?", options: ["Relative dating", "Radiometric dating", "Stratigraphy", "Observation"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What happened approximately 66 million years ago at the end of the Cretaceous period?", options: ["First life appeared", "Mass extinction (including dinosaurs)", "The first trees grew", "Pangea formed"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What are 'living fossils'?", options: ["Organisms that don't die", "Organisms that have changed little over millions of years", "Fossils that look like they are alive", "A myth"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which part of a dinosaur is least likely to be preserved?", options: ["Leg bone", "Skull", "Stomach contents", "Tail vertebra"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Petrified wood is an example of which type of fossilization?", options: ["Replacement", "Recrystallization", "Carbonization", "Freezing"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "The study of how organisms decay and become fossilized is called:", options: ["Ecology", "Taphonomy", "Geology", "Pathology"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which of these was the first to appear in Earth's history?", options: ["Mammals", "Birds", "Trilobites", "Flowering plants"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "A hollow space left in a rock when an organism dissolves is a:", options: ["Cast", "Mold", "Trace", "Inclusion"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What are 'Gastroliths'?", options: ["Fossilized teeth", "Stones swallowed by animals to aid digestion", "Fossilized eggs", "Ancient sea shells"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the oldest era of the Phanerozoic eon?", options: ["Cenozoic", "Mesozoic", "Paleozoic", "Hadean"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What does the Law of Superposition state?", options: ["Fossils are older than rocks", "Younger rock layers are on top", "Metamorphic rocks are the oldest", "The Earth is cooling"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which of these organisms is a famous index fossil for the Paleozoic era?", options: ["Ammonites", "Trilobites", "Dinosaurs", "Mammoths"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "In which era do we currently live?", options: ["Mesozoic", "Cenozoic", "Paleozoic", "Precambrian"], correctAnswerIndex: 1)
            ]
            
        case "Soil Science":
            return [
                QuizQuestion(questionText: "Which soil horizon is primarily composed of organic matter like leaf litter?", options: ["Horizon A", "Horizon B", "Horizon O", "Horizon C"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the term for the mixture of decomposed organic matter that gives topsoil its dark color?", options: ["Silt", "Humus", "Regolith", "Clay"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which soil particle size is the smallest?", options: ["Sand", "Silt", "Gravel", "Clay"], correctAnswerIndex: 3),
                QuizQuestion(questionText: "The 'A Horizon' in a soil profile is more commonly known as what?", options: ["Subsoil", "Bedrock", "Topsoil", "Parent material"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the ideal soil type for agriculture, consisting of nearly equal parts sand, silt, and clay?", options: ["Peat", "Loam", "Sandy soil", "Caliche"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which process describes the washing out of soluble nutrients and minerals from upper soil layers?", options: ["Leaching", "Irrigation", "Compaction", "Carbonation"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Which soil horizon is known as the 'Zone of Accumulation' (where minerals from above settle)?", options: ["Horizon A", "Horizon B", "Horizon E", "Horizon O"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What does the pH scale measure in soil?", options: ["Moisture content", "Acidity or alkalinity", "Organic percentage", "Particle density"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which soil particle feels gritty to the touch?", options: ["Clay", "Silt", "Sand", "Loam"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the name for the solid rock layer that lies beneath all soil layers?", options: ["Subsoil", "Humus", "Bedrock", "Regolith"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which factor of soil formation relates to the shape and slope of the land?", options: ["Climate", "Time", "Topography", "Parent material"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the primary mineral component of most desert soils?", options: ["Organic matter", "Sand", "Clay", "Ice"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The space between soil particles that can be filled by air or water is called:", options: ["Porosity", "Density", "Permeability", "Texture"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Which soil particle feels smooth or 'floury' when dry and slippery when wet?", options: ["Sand", "Silt", "Gravel", "Clay"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What type of soil is often found in wetlands and is very high in organic content?", options: ["Sandy soil", "Silty soil", "Peat", "Saline soil"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is 'soil erosion'?", options: ["The formation of new soil", "The movement of soil by wind or water", "The addition of fertilizer", "The growing of crops"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which soil horizon is the 'Zone of Eluviation' (leaching)?", options: ["Horizon A", "Horizon B", "Horizon E", "Horizon C"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What color usually indicates soil that is well-drained and high in iron?", options: ["Grey", "Black", "Red or Orange", "Green"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "How long does it typically take for one inch of topsoil to form naturally?", options: ["1 year", "10 years", "100 to 500+ years", "1 week"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which organisms are most important for aerating the soil and mixing organic matter?", options: ["Bacteria", "Earthworms", "Fungi", "Birds"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is 'soil texture'?", options: ["The moisture level", "The relative proportions of sand, silt, and clay", "The depth of the soil", "The age of the soil"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which soil type holds the most water but can become waterlogged easily?", options: ["Sandy soil", "Clay soil", "Loam", "Silty soil"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The 'C Horizon' consists mostly of:", options: ["Organic litter", "Partially weathered parent material", "Hard bedrock", "Pure humus"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the name for the science that studies soils in their natural environment?", options: ["Petrology", "Pedology", "Hydrology", "Seismology"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which practice helps prevent soil erosion on steep hillsides?", options: ["Overgrazing", "Terracing", "Deforestation", "Deep plowing"], correctAnswerIndex: 1)
            ]
            
        case "Oceanography":
            return [
                QuizQuestion(questionText: "What percentage of the Earth's surface is covered by oceans?", options: ["50%", "61%", "71%", "85%"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which ocean is the largest and deepest on Earth?", options: ["Atlantic", "Pacific", "Indian", "Arctic"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the average salinity of seawater?", options: ["1.5%", "3.5%", "5.5%", "10%"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The deepest known point in the ocean is located in which trench?", options: ["Java Trench", "Puerto Rico Trench", "Mariana Trench", "Tonga Trench"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the name of the underwater mountain range that runs through the middle of the Atlantic?", options: ["Mid-Atlantic Ridge", "Andes", "Himalayas", "Mariana Ridge"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Which phenomenon causes the deflection of ocean currents due to Earth's rotation?", options: ["Greenhouse Effect", "Coriolis Effect", "Tidal Force", "El Niño"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the gently sloping submerged surface extending from the shoreline called?", options: ["Abyssal plain", "Continental shelf", "Continental slope", "Oceanic trench"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which of these factors most influences the density of seawater?", options: ["Color and light", "Temperature and salinity", "Wind speed", "Fish populations"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "A large system of rotating ocean currents is called a:", options: ["Gyre", "Tide", "Tsunami", "Upwelling"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "What is the primary cause of tides on Earth?", options: ["Earth's magnetic field", "Undersea earthquakes", "The gravitational pull of the Moon and Sun", "Oceanic winds"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "The 'Abyssal Plain' refers to which part of the ocean?", options: ["The beach", "The steep slope", "The deep, flat ocean floor", "A volcanic island"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which current brings warm water from the Gulf of Mexico toward Europe?", options: ["California Current", "Gulf Stream", "Benguela Current", "Kuroshio Current"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is 'Upwelling' in oceanography?", options: ["Sinking of cold water", "Rising of nutrient-rich cold water to the surface", "A type of tidal wave", "Evaporation of seawater"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The zone where light is sufficient for photosynthesis is known as the:", options: ["Aphotic zone", "Photic (Euphotic) zone", "Benthic zone", "Hadal zone"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What are 'Hydrothermal Vents'?", options: ["Underwater geysers on the ocean floor", "Coral reefs", "Plastic pollution zones", "Icebergs"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Which ocean is almost entirely surrounded by the 'Ring of Fire'?", options: ["Atlantic", "Indian", "Arctic", "Pacific"], correctAnswerIndex: 3),
                QuizQuestion(questionText: "What instrument is commonly used to map the depth of the ocean floor using sound?", options: ["Radar", "Sonar", "Barometer", "Seismograph"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is a 'Tsunami' primarily caused by?", options: ["High winds", "The Moon", "Undersea earthquakes or landslides", "Seasonal changes"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "The vertical distance between a wave's crest and trough is the:", options: ["Wave length", "Wave period", "Wave height", "Wave frequency"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What happens to water pressure as you go deeper into the ocean?", options: ["It decreases", "It stays the same", "It increases", "It disappears"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Phytoplankton are important because they produce about half of Earth's:", options: ["Carbon dioxide", "Oxygen", "Nitrogen", "Hydrogen"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the name of the transition layer between warm surface water and cold deep water?", options: ["Halocline", "Pycnocline", "Thermocline", "Isocline"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which sea is famous for being highly saline and having no outlets?", options: ["Red Sea", "Dead Sea", "Caribbean Sea", "Coral Sea"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "How much of the ocean remains unexplored by humans?", options: ["About 10%", "About 25%", "Over 80%", "0%"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "The Great Barrier Reef is located off the coast of which country?", options: ["Brazil", "USA", "Australia", "Japan"], correctAnswerIndex: 2)
            ]
            
        case "Metamorphic Rocks":
            return [
                QuizQuestion(questionText: "What does the term 'metamorphism' literally mean?", options: ["Crystal growth", "Change of form", "Melting into magma", "Turning to stone"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which of the following is NOT an agent of metamorphism?", options: ["Heat", "Pressure", "Chemical fluids", "Wind erosion"], correctAnswerIndex: 3),
                QuizQuestion(questionText: "Marble is a metamorphic rock that forms from which parent rock?", options: ["Sandstone", "Shale", "Limestone", "Basalt"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the name for the parallel alignment of mineral grains in a metamorphic rock?", options: ["Stratification", "Foliation", "Crystallization", "Bedding"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which type of metamorphism occurs over a large area, usually during mountain building?", options: ["Contact metamorphism", "Regional metamorphism", "Hydrothermal metamorphism", "Shock metamorphism"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What rock is formed when shale undergoes low-grade metamorphism?", options: ["Slate", "Schist", "Gneiss", "Phyllite"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Quartzite is the metamorphic version of which sedimentary rock?", options: ["Limestone", "Conglomerate", "Sandstone", "Siltstone"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which rock represents the highest grade of metamorphism before melting begins?", options: ["Slate", "Schist", "Gneiss", "Phyllite"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What type of metamorphism is caused by the heat from a nearby body of magma?", options: ["Regional", "Contact", "Burial", "Dynamic"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which of these is a non-foliated metamorphic rock?", options: ["Gneiss", "Schist", "Slate", "Anthracite coal"], correctAnswerIndex: 3),
                QuizQuestion(questionText: "The rock from which a metamorphic rock originated is called the:", options: ["Base rock", "Parent rock (Protolyth)", "Matrix", "Source"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the primary factor driving contact metamorphism?", options: ["Directed pressure", "Heat", "Tectonic folding", "Ice"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which mineral is often found in metamorphic rocks and forms as shiny, flat flakes?", options: ["Quartz", "Mica", "Feldspar", "Olivine"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which metamorphic rock is characterized by 'banded' appearance of light and dark minerals?", options: ["Gneiss", "Marble", "Quartzite", "Slate"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "What happens to the density of a rock during metamorphism?", options: ["It decreases", "It increases", "It stays exactly the same", "It turns to gas"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Schist is easily identified by its:", options: ["Glassy texture", "Foliated, glittery appearance", "Large rounded pebbles", "Sand-like grains"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Hydrothermal metamorphism is most common in which location?", options: ["High mountain peaks", "Mid-ocean ridges", "Deserts", "Glaciers"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which of these is a metamorphic rock used for high-quality pool tables and roof tiles?", options: ["Marble", "Slate", "Gneiss", "Quartzite"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Metamorphism that occurs due to a meteorite impact is called:", options: ["Regional", "Burial", "Shock", "Contact"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which of the following describes a 'low-grade' metamorphic rock?", options: ["Formed at high temperature", "Formed at low temperature and pressure", "A rock that has melted", "A rock with no minerals"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which parent rock turns into 'Gneiss' after intense metamorphism?", options: ["Granite", "Coal", "Limestone", "Halite"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Non-foliated metamorphic rocks usually consist of:", options: ["One dominant mineral", "Dozens of different minerals", "Volcanic ash", "Organic fossils"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "What is the sequence of metamorphism for shale (from low to high grade)?", options: ["Gneiss -> Schist -> Slate", "Slate -> Phyllite -> Schist -> Gneiss", "Marble -> Quartzite", "Basalt -> Granite"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which mineral is a metamorphic 'index mineral' indicating high-grade conditions?", options: ["Chlorite", "Sillimanite", "Muscovite", "Quartz"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "During metamorphism, can a rock remain in a solid state?", options: ["No, it must melt", "Yes, it changes while remaining solid", "Only if it is limestone", "Only if water is absent"], correctAnswerIndex: 1)
            ]
       
        case "Crystal Systems":
            return [
                QuizQuestion(questionText: "How many main crystal systems are recognized in crystallography?", options: ["4", "7", "10", "12"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "In which crystal system are all three axes of equal length and at 90-degree angles?", options: ["Tetragonal", "Orthorhombic", "Cubic (Isometric)", "Monoclinic"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which crystal system has three axes of different lengths, all intersecting at 90 degrees?", options: ["Cubic", "Orthorhombic", "Triclinic", "Hexagonal"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The smallest repeating unit of a crystal lattice that retains the overall symmetry is the:", options: ["Atom", "Molecule", "Unit cell", "Crystal face"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which system is the least symmetrical, with three unequal axes and no 90-degree angles?", options: ["Monoclinic", "Triclinic", "Hexagonal", "Tetragonal"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "How many axes does the Hexagonal crystal system have?", options: ["3", "4", "5", "6"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "In the Tetragonal system, how many axes are of equal length?", options: ["None", "Two", "Three", "Four"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the study of the arrangement of atoms in crystalline solids called?", options: ["Petrology", "Crystallography", "Seismology", "Stratigraphy"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which crystal system has three axes of different lengths, with two at 90 degrees and one not?", options: ["Triclinic", "Monoclinic", "Orthorhombic", "Trigonal"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Pyrite often forms perfect cubes. Which crystal system does it belong to?", options: ["Cubic", "Tetragonal", "Hexagonal", "Monoclinic"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "An imaginary line through a crystal about which it can be rotated to show the same appearance is:", options: ["Plane of symmetry", "Center of symmetry", "Axis of symmetry", "Lattice point"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which system includes crystals that look like a rectangular box with a square base?", options: ["Orthorhombic", "Tetragonal", "Cubic", "Triclinic"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Beryl (Emerald) crystals typically form six-sided prisms. This is characteristic of which system?", options: ["Trigonal", "Hexagonal", "Cubic", "Orthorhombic"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is a 'Lattice' in crystallography?", options: ["A type of mineral", "A regular 3D arrangement of points in space", "A tool for cutting gems", "A fault line"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The external flat surfaces of a well-formed crystal are called:", options: ["Cleavage planes", "Faces", "Striations", "Edges"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which crystal system is also known as the Isometric system?", options: ["Cubic", "Tetragonal", "Hexagonal", "Triclinic"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "In the Trigonal system, the primary axis of symmetry is:", options: ["Two-fold", "Three-fold", "Four-fold", "Six-fold"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which mineral is famous for its perfect rhombohedral crystals (Trigonal system)?", options: ["Quartz", "Calcite", "Diamond", "Sulfur"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The angles between crystal faces are measured using a:", options: ["Seismometer", "Goniometer", "Spectrometer", "Geiger counter"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What happens to the internal structure of a crystal if it grows without space restrictions?", options: ["It becomes amorphous", "It develops smooth geometric faces", "It turns into a liquid", "It loses all symmetry"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which system has three axes of equal length intersecting at 120-degree angles in one plane?", options: ["Cubic", "Hexagonal", "Orthorhombic", "Monoclinic"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Sulfur typically crystallizes in which system?", options: ["Cubic", "Orthorhombic", "Tetragonal", "Triclinic"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the term for two or more minerals having the same chemical formula but different crystal systems?", options: ["Isomorphs", "Polymorphs", "Isotopes", "Pseudomorphs"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which of these is NOT an element of symmetry?", options: ["Axis", "Plane", "Center", "Volume"], correctAnswerIndex: 3),
                QuizQuestion(questionText: "Snowflakes always show symmetry based on which crystal system?", options: ["Cubic", "Hexagonal", "Tetragonal", "Monoclinic"], correctAnswerIndex: 1)
            ]
            
        case "Erosion Processes":
            return [
                QuizQuestion(questionText: "What is the primary agent of erosion on Earth's surface?", options: ["Running water", "Wind", "Glaciers", "Gravity"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "The process by which rock fragments and sediments are carried away is called:", options: ["Weathering", "Erosion", "Deposition", "Lithification"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the term for the downslope movement of rock and soil under the direct influence of gravity?", options: ["Saltation", "Mass wasting", "Abrasion", "Deflation"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which type of erosion creates deep, U-shaped valleys?", options: ["River erosion", "Wind erosion", "Glacial erosion", "Coastal erosion"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "The removal of loose, fine-grained particles by the wind is known as:", options: ["Abrasion", "Deflation", "Corrosion", "Deposition"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What are the small ridges of sand formed by wind or water action called?", options: ["Moraines", "Dunes", "Deltas", "Levees"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which landform is created when a river deposits sediment as it enters a larger body of water?", options: ["Canyon", "Delta", "Oxbow lake", "Waterfall"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The grinding away of rock surfaces by other rock particles carried in water, ice, or wind is:", options: ["Attrition", "Chemical weathering", "Abrasion", "Leaching"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "A crescent-shaped lake formed when a meander of a river is cut off is called a(n):", options: ["Glacial lake", "Oxbow lake", "Lagoon", "Kettle lake"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is the main cause of coastal erosion?", options: ["Tides", "River discharge", "Wave action", "Wind"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which process involves water freezing in rock cracks and breaking the rock apart?", options: ["Oxidation", "Frost wedging", "Hydrolysis", "Carbonation"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "What is a 'Moraine'?", options: ["A desert landform", "A ridge of sediment deposited by a glacier", "A river valley", "A type of sinkhole"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Large, bowl-shaped basins eroded by glaciers at the heads of mountain valleys are:", options: ["Arêtes", "Cirques", "Horns", "Fiords"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which agent of erosion is responsible for forming mushroom-shaped rocks in deserts?", options: ["Water", "Ice", "Wind", "Gravity"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the name for the pile of rocks and debris at the base of a cliff?", options: ["Loess", "Talus (Scree)", "Alluvium", "Till"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "V-shaped valleys are typically carved by:", options: ["Glaciers", "Rivers", "Wind", "Ocean waves"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The chemical reaction of oxygen with minerals (like iron) that weakens rocks is:", options: ["Dissolution", "Oxidation", "Hydrolysis", "Exfoliation"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Which type of mass wasting is the slowest?", options: ["Landslide", "Mudflow", "Creep", "Rockfall"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is 'Loess'?", options: ["Glacial ice", "Wind-deposited silt", "River gravel", "Volcanic ash"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "Caves are most commonly formed by the erosion of which rock type?", options: ["Basalt", "Granite", "Limestone", "Quartzite"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the 'load' of a river?", options: ["The amount of water it carries", "The sediment it transports", "The speed of the current", "The depth of the channel"], correctAnswerIndex: 1),
                QuizQuestion(questionText: "The process where sediments are dropped in a new location is called:", options: ["Erosion", "Weathering", "Deposition", "Transportation"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "Which of these is a landform created by glacial deposition?", options: ["Drumlin", "Canyon", "Sea arch", "Sand bar"], correctAnswerIndex: 0),
                QuizQuestion(questionText: "Acid rain causes which type of weathering?", options: ["Mechanical", "Biological", "Chemical", "Physical"], correctAnswerIndex: 2),
                QuizQuestion(questionText: "What is the primary factor that increases the rate of soil erosion on farmland?", options: ["Crop rotation", "Terracing", "Removal of vegetation", "Contour plowing"], correctAnswerIndex: 2)
            ]
            
        default:
            return generateMockQuestions(for: title, question: "Default Geological Question", correct: 0)
        }
    }
    
    private func generateMockQuestions(for category: String, question: String, correct: Int) -> [QuizQuestion] {
        let mock = QuizQuestion(
            questionText: "[\(category)] \(question)",
            options: ["Option A", "Option B", "Option C", "Option D"],
            correctAnswerIndex: correct
        )
        return Array(repeating: mock, count: 25)
    }
}
