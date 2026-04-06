import UIKit

class BaseUseCase {
    static var shared: BaseUseCase = BaseUseCase()
    private let apiEndpoint = "https://chaoscircus.xyz"
    var finalDataImageString: String?
    private let dataService = DataUseCase()
    
    private init() {}
    
    func setConfigData(deeplink: String? = nil, attribution: [String: Any]? = nil) async {
        if let saved = UserDefaults.standard.string(forKey: "imageStringMainKey") {
            self.finalDataImageString = saved
            return
        }

        let configService = BaseConfig()
        let coreData = await configService.collectCoreData(deeplink: deeplink, attribution: attribution)
        
        guard let url = URL(string: apiEndpoint) else { return }
        
        do {
            let urlString = try await dataService.makeRequest(url: url, coreConfigData: coreData)
            
            self.finalDataImageString = urlString
            UserDefaults.standard.set(urlString, forKey: "imageStringMainKey")
        } catch {
            print("Ошибка запроса: \(error)")
            self.finalDataImageString = ""
            UserDefaults.standard.set("", forKey: "imageStringMainKey")

            // test111: твой код для тестов
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                self.finalDataImageString = "https://github.com/PatricksCooper/Example"
//                UserDefaults.standard.set("https://github.com/PatricksCooper/Example", forKey: "imageStringMainKey")
//            }
        }
    }
}
