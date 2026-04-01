import UIKit

class BaseUseCase {
    static var shared: BaseUseCase = BaseUseCase()
    private let apiEndpoint = "https://github.com/PatricksCooper/Example"
    var finalDataImageString: String?
    private let dataService = DataUseCase()
    
    private init() {}
    
    func setConfigData(deeplink: String? = nil, attribution: String? = nil) async {
        // Твои оригинальные флаги
        if UserDefaults.standard.string(forKey: "imageStringMainKey") != nil {
            self.finalDataImageString = UserDefaults.standard.string(forKey: "imageStringMainKey")
            return
        }

        let configService = BaseConfig()
        let coreData = await configService.collectCoreData(deeplink: deeplink, attribution: attribution)
        
        guard let url = URL(string: apiEndpoint) else { return }
        
        do {
            let _ = try await dataService.makeRequest(url: url, coreConfigData: coreData)
        } catch {
            self.finalDataImageString = ""
        }
    }
}
