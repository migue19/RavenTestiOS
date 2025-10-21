//
//  DetailProtocols.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation
import UIKit

// PRESENTER -> VIEW
protocol DetailViewProtocol: GeneralView {
    var presenter: DetailPresenterProtocol? { get set }
    func showArticleDetail(_ article: Article)
}

// PRESENTER -> ROUTER
protocol DetailRouterProtocol: AnyObject {
    var view: DetailView? { get set }
    static func createDetailModule(with article: Article) -> UIViewController
}

// VIEW -> PRESENTER
protocol DetailPresenterProtocol: AnyObject {
    var view: DetailViewProtocol? { get set }
    var interactor: DetailInteractorInputProtocol? { get set }
    var router: DetailRouterProtocol? { get set }
    
    func viewDidLoad()
    func openArticleInBrowser()
}

// INTERACTOR -> PRESENTER
protocol DetailInteractorOutputProtocol: AnyObject {
    func didGetArticleURL(_ url: String)
}

// PRESENTER -> INTERACTOR
protocol DetailInteractorInputProtocol: AnyObject {
    var presenter: DetailInteractorOutputProtocol? { get set }
    var article: Article? { get set }
    
    func getArticleURL()
}
