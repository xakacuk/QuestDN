//
//  News.swift
//  QuestDN
//
//  Created by Евгений Бейнар on 11/07/2019.
//

import Foundation

struct News: Codable {
    var title: String
    var description: String
    var urlToImage: String
    var publishedAt: String
    var url: String
}

struct Articles: Codable {
    var articles: [News]
}
