//
//  HomeLocalDataManager.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation

class HomeLocalDataManager: HomeLocalDataManagerInputProtocol {
    
    // MARK: - Save Articles
    func saveArticles(_ articles: [Article], completion: @escaping (Bool) -> Void) {
        CoreDataManager.shared.saveArticles(articles, completion: completion)
    }
    
    // MARK: - Fetch Articles
    func fetchArticles(completion: @escaping ([Article]) -> Void) {
        CoreDataManager.shared.fetchArticles(completion: completion)
    }
    
    // MARK: - Check Cache
    func hasCachedArticles(completion: @escaping (Bool) -> Void) {
        CoreDataManager.shared.hasCachedArticles(completion: completion)
    }
}
