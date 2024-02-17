//
//  HomeProtocol.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//  
//

/// Protocolo que define los métodos y atributos para el view de Home
/// PRESENTER -> VIEW
protocol HomeViewProtocol: GeneralView {
    func showData(data: [String])
}
/// Protocolo que define los métodos y atributos para el routing de Home
/// PRESENTER -> ROUTING
protocol HomeRouterProtocol {
    func showArticle(data: ResultsModel)
}
/// Protocolo que define los métodos y atributos para el Presenter de Home
/// VIEW -> PRESENTER
protocol HomePresenterProtocol {
    func getData()
    func tapInArticle(index: Int)
}
/// Protocolo que define los métodos y atributos para el Interactor de Home
/// PRESENTER -> INTERACTOR
protocol HomeInteractorInputProtocol {
    func requestData()
}
/// Protocolo que define los métodos y atributos para el Interactor de Home
/// INTERACTOR -> PRESENTER
protocol HomeInteractorOutputProtocol {
    func sendData(data: [ResultsModel])
}
