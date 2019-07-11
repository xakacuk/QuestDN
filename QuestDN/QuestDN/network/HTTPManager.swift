//
//  HTTPManager.swift
//  QuestDN
//
//  Created by Евгений Бейнар on 11/07/2019.
//

import Foundation
import Alamofire

final class HTTPManager {
    
    static let shared = HTTPManager()
    
    public typealias Parameters = [String: Any]
    
    struct Const {
        static let url = "https://newsapi.org/v2/everything?q=ios&from=2019-04-00&sortBy=publi%20shedAt&apiKey=26eddb253e7840f988aec61f2ece2907&page="
    }
    
    struct Config {
        static let timeout = 15.0
    }
    
    lazy var networkSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        //        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForResource = Config.timeout
        configuration.timeoutIntervalForRequest = Config.timeout
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    }()
    
    func getNews(page: Int, completionHandler: @escaping (Swift.Result<Articles?, Error>) -> Void) {
        
        networkSessionManager.request("\(Const.url)\(page)", method: .get, parameters: nil).response { response in
            
            if let error = response.error {
                //timeout, 400
                completionHandler(.failure(error))
                return
            }
            
            guard let data = response.data else {
                assertionFailure()
                return
            }
            
            if let rawString = String(bytes: data, encoding: .utf8) {
                print(rawString)
            }
            
            let decoder = JSONDecoder()
            
            do {
                let news = try decoder.decode(Articles.self, from: data)
                completionHandler(.success(news))
            } catch {
                if let apiError = try? decoder.decode(ApiStructError.self, from: data) {
                    completionHandler(.failure(apiError.code))
                } else {
                    completionHandler(.failure(error))
                }
            }
            
        }
    }
    
}
