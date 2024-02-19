//
//  HomeInteractor.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//  
//
import ConnectionLayer
class HomeInteractor {
    var presenter: HomeInteractorOutputProtocol?
}
extension HomeInteractor: HomeInteractorInputProtocol {
    func requestData() {
        if Reachability.isConnectedToNetwork() {
            getEmailedNews()
        } else {
            self.presenter?.sendErrorMessage(message: "No Hay Internet")
        }
    }
    func getEmailedNews() {
        let connectionLayer = ConnectionLayer(isDebug: false)
        let url = NYTimesApi.emailedPath
        connectionLayer.connectionRequest(url: url, method: .get, data: nil) { [weak self] (data, error) in
            guard let self = self else {
                debugPrint("No existe la referencia self")
                return
            }
            if let error = error {
                self.presenter?.sendErrorMessage(message: error)
                return
            }
            guard let data = data else {
                self.presenter?.sendErrorMessage(message: "No hay Datos")
                return
            }
            guard let entity = Utils.decode(Articles.self, from: data, serviceName: "EmailedNews"), let results = entity.results else {
                return
            }
            self.presenter?.sendData(data: results)
        }
    }
}
