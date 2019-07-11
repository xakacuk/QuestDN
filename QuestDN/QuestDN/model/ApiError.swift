//
//  ApiError.swift
//  QuestDN
//
//  Created by Евгений Бейнар on 11/07/2019.
//

import Foundation

struct ApiStructError: Decodable {
    let code: ApiError
}

enum ApiError: String, LocalizedError, Decodable {
    case apiKeyMissing = "apiKeyMissing"
    case pageError = "pageCannotBeLessThanOne"
    
    var errorDescription: String? {
        switch self {
        case .apiKeyMissing: return "Your API key is missing. Append this to the URL with the apiKey param, or use the x-api-key HTTP header"
        case .pageError: return "The page parameter cannot be less than 1. You have requested 20"
        }
    }
}
