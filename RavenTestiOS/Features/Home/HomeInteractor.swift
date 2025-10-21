//
//  HomeInteractor.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//  
//

import Foundation

class HomeInteractor: HomeInteractorInputProtocol {

    // MARK: Properties
    weak var presenter: HomeInteractorOutputProtocol?
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol?
    
    func getArticles() {
        remoteDatamanager?.fetchArticles()
    }
}

extension HomeInteractor: HomeRemoteDataManagerOutputProtocol {
    func onArticlesFetched(_ articles: [Article]) {
        presenter?.didFetchArticles(articles)
    }
    
    func onArticlesFetchFailed(error: String) {
        presenter?.didFailFetchingArticles(error: error)
    }
}
