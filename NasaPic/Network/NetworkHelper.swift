//
//  NetworkHelper.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import Foundation

enum HttpMethod: String {
    case GET = "get"
    case POST = "post"
}

class NetworkHelper {
    static let sharedInstance = NetworkHelper()
    private init() {}
    
    /// Handles API request
    /// - Parameters:
    ///   - type: Codable Model
    ///   - url: URL
    ///   - method: API method name
    ///   - parameters: Input Parameters if any
    ///   - completion: Completion Handler
    func request<T: Codable>(of type: T.Type,
                             url: URL,
                             method: HttpMethod,
                             parameters: [String: Any]?,
                             completion: @escaping (T?, CustomError?) -> Void)
    {
        guard NetworkMonitor.isNetworkReachable() else {
            completion(nil ,CustomError.noInternet)
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }

        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil || data == nil {
                debugPrint("Client error!")
                return
            }
            let response = response as? HTTPURLResponse
            guard let response = response, (200...299).contains(response.statusCode) else {
                debugPrint("Server error!")
                if response?.statusCode == 400 {
                    completion(nil, CustomError.invalidRequest)
                    return
                }
                completion(nil ,CustomError.serverError)
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                debugPrint("Wrong MIME type!")
                completion(nil ,CustomError.serverError)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data!)
                completion(response, nil)
            } catch {
                debugPrint("JSON error: \(error.localizedDescription)")
                completion(nil , CustomError.invalidResponse)
            }
        }
        task.resume()
    }
}
