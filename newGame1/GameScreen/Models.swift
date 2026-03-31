
import Foundation
import UIKit

// MARK: - Models
struct FishModel: Codable, Equatable {
    let id: Int
    let name: String
    let rarity: String
    let imageName: String
    var isCaught: Bool
}

// MARK: - Game Manager (State)
class GameManager {
    static let shared = GameManager()
    private let defaults = UserDefaults.standard
    
    var currentLevel: Int {
        get { defaults.integer(forKey: "currentLevel") == 0 ? 1 : defaults.integer(forKey: "currentLevel") }
        set { defaults.set(newValue, forKey: "currentLevel") }
    }
    
    var points: Int {
        get { defaults.integer(forKey: "expeditionPoints") }
        set { defaults.set(newValue, forKey: "expeditionPoints") }
    }
    
    func levelUp() { currentLevel += 1 }
    func addPoints(_ amount: Int) { points += amount }
}

// MARK: - Fish Manager (Collection)
class FishManager {
    static let shared = FishManager()
    private let defaults = UserDefaults.standard
    private let collectionKey = "fishCollection"
    
    var allFish: [FishModel] = []
    
    init() {
        loadCollection()
    }
    
    private func loadCollection() {
        if let data = defaults.data(forKey: collectionKey),
           let savedFish = try? JSONDecoder().decode([FishModel].self, from: data) {
            allFish = savedFish
        } else {
            // Initial Seed
            allFish = [
                FishModel(id: 1, name: "Ice Perch", rarity: "Common", imageName: "fish_1", isCaught: false),
                FishModel(id: 2, name: "Frost Pike", rarity: "Rare", imageName: "fish_2", isCaught: false),
                FishModel(id: 3, name: "Deep Walleye", rarity: "Epic", imageName: "fish_3", isCaught: false),
                FishModel(id: 4, name: "Golden Sturgeon", rarity: "Legendary", imageName: "fish_4", isCaught: false)
            ]
            saveCollection()
        }
    }
    
    func saveCollection() {
        if let data = try? JSONEncoder().encode(allFish) {
            defaults.set(data, forKey: collectionKey)
        }
    }
    
    func catchRandomFish() -> FishModel {
        // Упрощенный дроп: чем выше редкость, тем меньше шанс, но для тестов берем рандом
        let index = Int.random(in: 0..<allFish.count)
        allFish[index].isCaught = true
        saveCollection()
        return allFish[index]
    }
}

// MARK: - Story Engine
struct StoryEngine {
    static func getStory(for level: Int) -> [String] {
        switch level {
        case 1: return ["The sonar shows a massive cluster of fish under the ice.", "We need to drill a hole...", "Prepare the equipment!"]
        case 2: return ["Sector 2 is colder.", "Ice density is higher here.", "Let's crack it!"]
        case 3: return ["Anomalous signal detected.", "Could it be the Epic Deep Walleye?", "Focus on the drill!"]
        case 4: return ["Storm is coming.", "We have a short window.", "Hurry up!"]
        case 5: return ["Halfway through the expedition.", "The gear is holding up.", "Let's see what's beneath."]
        case 6...10: return ["Deep waters...", "High pressure...", "Keep drilling!"]
        default: return ["A quiet spot.", "Let's cast the line."] // Заглушка для уровней 10+
        }
    }
}
