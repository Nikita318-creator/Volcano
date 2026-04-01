
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
    
    // Прогресс сюжета
    var storyStep: Int {
        get { defaults.integer(forKey: "storyStep") }
        set { defaults.set(newValue, forKey: "storyStep") }
    }
    
    var points: Int {
        get { defaults.integer(forKey: "expeditionPoints") }
        set { defaults.set(newValue, forKey: "expeditionPoints") }
    }
    
    var currentLevel: Int {
        get { defaults.integer(forKey: "currentLevel") == 0 ? 1 : defaults.integer(forKey: "currentLevel") }
        set { defaults.set(newValue, forKey: "currentLevel") }
    }

    func levelUp() {
        currentLevel += 1
        storyStep += 1 // Увеличиваем шаг сюжета после каждой победы
    }

    // Проверка на трофеи (на 1, 3, 5, 10 уровне)
    func checkTrophy() -> FishModel? {
        let milestoneLevels = [0, 2, 5, 10]
        if milestoneLevels.contains(currentLevel) {
            return FishManager.shared.catchRandomFish()
        }
        return nil
    }
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
import Foundation

enum GameType {
    case drill
    case cards
}

struct StoryEngine {
    static func getStory(for level: Int) -> [String] {
        switch level {
        case 1:
            return ["Looks like a perfect spot for ice fishing.", "The fish are active today!", "Get your gear ready."]
        case 2:
            return ["Moving to the deeper sector.", "The water is crystal clear here.", "Let's see what's biting."]
        case 3:
            return ["A rare shadow appeared on the sonar!", "Could be a record breaker.", "Don't let it slip away!"]
        case 4:
            return ["The wind is picking up.", "Keep your hands warm.", "The ice feels different here."]
        case 5:
            return ["We've reached the frozen bay.", "Locals say giant pike live here.", "Time to prove them right."]
        case 6:
            return ["Night is falling over the lake.", "The stars are bright.", "Night fishing requires focus."]
        case 7:
            return ["Heavy snow is starting.", "Visibility is low.", "Trust your equipment."]
        case 8:
            return ["The sonar is going crazy!", "Something huge is moving below.", "Stay alert."]
        case 9:
            return ["Found an old thermal spring.", "The water is warmer here.", "Expect unusual species."]
        case 10:
            return ["Halfway through the expedition.", "You've gained some serious skill.", "The real challenge starts now."]
        case 11:
            return ["The ice is getting much thicker.", "This will require a heavy-duty drill.", "Dig deep."]
        case 12:
            return ["Entering the 'Dead Zone'.", "Silence all around.", "Only the bravest fish here."]
        case 13:
            return ["An aurora borealis is glowing above.", "A magical night for a big catch.", "The atmosphere is electric."]
        case 14:
            return ["Ice pressure is building up.", "The ground is shaking slightly.", "Work fast!"]
        case 15:
            return ["Ancient glacier territory.", "This ice hasn't melted for centuries.", "What's hidden inside?"]
        case 16:
            return ["The air is freezing your breath.", "Extreme conditions reached.", "Focus on the target."]
        case 17:
            return ["Sonar detected a metallic echo.", "Could be an old wreck?", "Fish love to hide there."]
        case 18:
            return ["The final stretch is ahead.", "The biggest shadows are seen here.", "Prepare yourself."]
        case 19:
            return ["Total whiteout outside.", "You are the only one on the ice.", "One last push."]
        case 20:
            return ["The Ultimate Spot.", "The legendary King Fish is nearby.", "Time to make history!"]
        default:
            return ["The expedition continues.", "The cold won't stop us.", "Time to cast the line!"]
        }
    }
    
    // Чередование: Нечетные (1,3,5...) - Бурение, Четные (2,4,6...) - Карточки
    static func gameType(for level: Int) -> GameType {
        return level % 2 != 0 ? .cards : .drill
    }
}
