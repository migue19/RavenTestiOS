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
        let connectionLayer = ConnectionLayer(isDebug: false)
        let url = NYTimesApi.base
        connectionLayer.connectionRequest(url: url, method: .get, data: nil) { data, error in
            guard let data = data else {
                return
            }
            guard let entity = Utils.decode(Articles.self, from: data, serviceName: "Articles"), let results = entity.results else {
                return
            }
            self.presenter?.sendData(data: results)
        }
    }
}
