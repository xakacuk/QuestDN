//
//  NewsModel.swift
//  QuestDN
//
//  Created by Евгений Бейнар on 11/07/2019.
//

import Foundation

final class NewsModel {
    
    private let httpManager = HTTPManager.shared
    private var news = [News]()
    
    func getNews(page: Int, completion: @escaping (Swift.Result<[News], Error>) -> Void) {
        self.news.removeAll()
        httpManager.getNews(page: page) { (result) in
            switch result {
            case .success(let response):
                self.news = response!.articles
                completion(.success(self.news))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
}
