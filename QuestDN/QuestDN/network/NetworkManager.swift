//
//  NetworkManager.swift
//  QuestDN
//
//  Created by Евгений Бейнар on 11/07/2019.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    func startNetworkReachabilityObserver(completion: ((Bool) -> Void)?) {
        
        reachabilityManager?.listener = { status in
            switch status {
                case .notReachable:
                    completion?(true)
                case .unknown, .reachable:
                    completion?(false)
            }
        }
    }
}
