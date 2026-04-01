import UIKit

class DataUseCase {
    func makeRequest(url: URL, coreConfigData: CoreConfigData) async throws -> URL {
        let rawQueryString = "appId=\(coreConfigData.appId)&pushToken=\(coreConfigData.pushToken ?? "")&userAgent=\(coreConfigData.userAgent)&deviceID=\(coreConfigData.deviceID ?? "")&adId=\(coreConfigData.adId)&oneLink=\(coreConfigData.oneLink ?? "")&naming=\(coreConfigData.naming ?? "")"
                                
        guard let dataToEncode = rawQueryString.data(using: .utf8) else {
            throw DataServiceError.encodingFailed
        }
        
        let base64EncodedString = dataToEncode.base64EncodedString()
        guard let requestURL = URL(string: url.absoluteString + "?data=" + base64EncodedString) else {
            throw DataServiceError.invalidURL
        }
                        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataServiceError.badServerResponse
        }
                
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let receivedUrl = json?["url"] as? String
        
        if let receivedUrl = receivedUrl, !receivedUrl.isEmpty {
            UserDefaults.standard.set(receivedUrl, forKey: "imageStringMainKey")
            BaseUseCase.shared.finalDataImageString = receivedUrl
            return URL(string: receivedUrl)!
        } else {
            // Если урл пустой - помечаем это пустой строкой в твоем ключе
            UserDefaults.standard.set("", forKey: "imageStringMainKey")
            BaseUseCase.shared.finalDataImageString = ""
            throw DataServiceError.invalidURL
        }
    }
}

// MARK: - Обработка Ошибок
enum DataServiceError: Error, LocalizedError {
    case invalidURL
    case badServerResponse
    case encodingFailed
    case invalidParametrs(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalidURL"
        case .badServerResponse:
            return "badServerResponse"
        case .invalidParametrs(let url):
            return "invalidURL \(url)"
        case .encodingFailed:
            return "encodingFailed"
        }
    }
}
