import UIKit

class BaseUseCase {
    static var shared: BaseUseCase = BaseUseCase()
    private let apiEndpoint = "https://chaoscircus.xyz/api/click"
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
        }
    }
}
