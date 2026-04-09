import UIKit

class DataUseCase {
    func makeRequest(url: URL, coreConfigData: CoreConfigData) async throws -> String {
        let payload: [String: Any] = [
            "appId": coreConfigData.appId,
            "pushToken": coreConfigData.pushToken ?? "",
            "userAgent": coreConfigData.userAgent,
            "deviceID": coreConfigData.deviceID ?? "",
            "adId": coreConfigData.adId,
            "oneLink": coreConfigData.oneLink ?? "",
            "naming": coreConfigData.naming ?? [:]
        ]
        
        // 2. Кодируем в JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            throw DataServiceError.encodingFailed
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw DataServiceError.badServerResponse
        }
        
        print("Статус код: \(httpResponse.statusCode)")
        
        if httpResponse.statusCode == 200 {
            guard let receivedUrl = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !receivedUrl.isEmpty else {
                throw DataServiceError.encodingFailed
            }
            
            return receivedUrl
        }
        
        throw DataServiceError.invalidURL
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
