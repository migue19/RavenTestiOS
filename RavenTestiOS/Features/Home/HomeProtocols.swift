//
//  HomeProtocols.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//
//

import Foundation
import UIKit
// PRESENTER -> VIEW
protocol HomeViewProtocol: AnyObject, GeneralView {
    var presenter: HomePresenterProtocol? { get set }
    func showArticles(_ articles: [Article])
}
// PRESENTER -> ROUTER
protocol HomeRouterProtocol: AnyObject {
    var view: HomeView? { get set }
    static func createHomeModule() -> UIViewController
    func navigateToDetail(with article: Article)
}
// VIEW -> PRESENTER
protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    
    func viewDidLoad()
    func fetchArticles()
    func didSelectArticle(_ article: Article)
}
// INTERACTOR -> PRESENTER
protocol HomeInteractorOutputProtocol: AnyObject {
    func didFetchArticles(_ articles: [Article])
    func didFailFetchingArticles(error: String)
}
// PRESENTER -> INTERACTOR
protocol HomeInteractorInputProtocol: AnyObject {
    var presenter: HomeInteractorOutputProtocol? { get set }
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol? { get set }
    
    func getArticles()
}
// INTERACTOR -> DATAMANAGER
protocol HomeDataManagerInputProtocol: AnyObject {
}
// INTERACTOR -> REMOTEDATAMANAGER
protocol HomeRemoteDataManagerInputProtocol: AnyObject {
    var remoteRequestHandler: HomeRemoteDataManagerOutputProtocol? { get set }
    func fetchArticles()
}
// REMOTEDATAMANAGER -> INTERACTOR
protocol HomeRemoteDataManagerOutputProtocol: AnyObject {
    func onArticlesFetched(_ articles: [Article])
    func onArticlesFetchFailed(error: String)
}
