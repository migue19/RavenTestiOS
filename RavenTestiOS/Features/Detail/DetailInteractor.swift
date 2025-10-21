//
//  DetailInteractor.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation

class DetailInteractor: DetailInteractorInputProtocol {
    
    // MARK: Properties
    weak var presenter: DetailInteractorOutputProtocol?
    var article: Article?
    
    func getArticleURL() {
        guard let article = article else { return }
        presenter?.didGetArticleURL(article.url)
    }
}
