//
//  DetailRouter.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation
import UIKit
import SafariServices

class DetailRouter: DetailRouterProtocol {
    weak var view: DetailView?
    
    static func createDetailModule(with article: Article) -> UIViewController {
        let view = DetailView()
        let presenter: DetailPresenterProtocol & DetailInteractorOutputProtocol = DetailPresenter()
        let interactor: DetailInteractorInputProtocol = DetailInteractor()
        let router: DetailRouterProtocol = DetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.article = article
        router.view = view
        
        return view
    }
}
