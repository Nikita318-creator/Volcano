import UIKit

class BaseUseCase {
    static var shared: BaseUseCase = BaseUseCase()
    private let apiEndpoint = "https://chaoscircus.xyz"
    var finalDataImageString: String?
    private let dataService = DataUseCase()
    
    private init() {}
    
    func setConfigData(deeplink: String? = nil, attribution: [String: Any]? = nil) async {
        if UserDefaults.standard.string(forKey: "imageStringMainKey") != nil {
            self.finalDataImageString = UserDefaults.standard.string(forKey: "imageStringMainKey")
            return
        }

        let configService = BaseConfig()
        let coreData = await configService.collectCoreData(deeplink: deeplink, attribution: attribution)
        
        guard let url = URL(string: apiEndpoint) else { return }
        
        do {
            let url1 = try await dataService.makeRequest(url: url, coreConfigData: coreData)
            self.finalDataImageString = url1
            UserDefaults.standard.set(finalDataImageString, forKey: "imageStringMainKey")
            print(url1)
        } catch {
//            BaseUseCase.shared.finalDataImageString = ""
//            UserDefaults.standard.set("", forKey: "imageStringMainKey")

            // test111: не удаляй я пока тесчу
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.finalDataImageString = "https://github.com/PatricksCooper/Example"
                UserDefaults.standard.set("https://github.com/PatricksCooper/Example", forKey: "imageStringMainKey")
            }
        }
    }
}
