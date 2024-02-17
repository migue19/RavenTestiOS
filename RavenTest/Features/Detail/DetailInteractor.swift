//
//  DetailInteractor.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 17/02/24.
//  
//

class DetailInteractor {
    var presenter: DetailInteractorOutputProtocol?
    var data: ResultsModel?
}
extension DetailInteractor: DetailInteractorInputProtocol {
    func requestData() {
        guard let data = data else {
            return
        }
        presenter?.sendData(data: data)
    }
}
