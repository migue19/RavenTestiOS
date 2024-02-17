//
//  DetailProtocol.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 17/02/24.
//  
//

/// Protocolo que define los métodos y atributos para el view de Detail
/// PRESENTER -> VIEW
protocol DetailViewProtocol {
    func showData(data: DetailEntity)
}
/// Protocolo que define los métodos y atributos para el routing de Detail
/// PRESENTER -> ROUTING
protocol DetailRouterProtocol {
}
/// Protocolo que define los métodos y atributos para el Presenter de Detail
/// VIEW -> PRESENTER
protocol DetailPresenterProtocol {
    func getData()
}
/// Protocolo que define los métodos y atributos para el Interactor de Detail
/// PRESENTER -> INTERACTOR
protocol DetailInteractorInputProtocol {
    func requestData()
}
/// Protocolo que define los métodos y atributos para el Interactor de Detail
/// INTERACTOR -> PRESENTER
protocol DetailInteractorOutputProtocol {
    func sendData(data: ResultsModel)
}
