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
        let connectionLayer = ConnectionLayer()
        let url = NYTimesApi.base
        connectionLayer.connectionRequest(url: url, method: .get, data: nil) { data, error in
            print(data ?? "")
        }
    }
}
