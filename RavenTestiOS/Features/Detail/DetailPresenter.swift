//
//  DetailPresenter.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation
import UIKit
import SafariServices

class DetailPresenter {
    
    // MARK: Properties
    var view: DetailViewProtocol?
    var interactor: DetailInteractorInputProtocol?
    var router: DetailRouterProtocol?
    private var articleURL: String?
}

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        guard let article = interactor?.article else { return }
        view?.showArticleDetail(article)
    }
    
    func openArticleInBrowser() {
        interactor?.getArticleURL()
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func didGetArticleURL(_ url: String) {
        guard let url = URL(string: url),
              let viewController = view as? UIViewController else { return }
        
        let safariVC = SFSafariViewController(url: url)
        viewController.present(safariVC, animated: true)
    }
}
