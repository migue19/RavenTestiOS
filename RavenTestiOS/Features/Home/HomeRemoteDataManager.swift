//
//  HomeRemoteDataManager.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//  
//

import Foundation
import ConnectionLayer

class HomeRemoteDataManager: HomeRemoteDataManagerInputProtocol {
    
    var remoteRequestHandler: HomeRemoteDataManagerOutputProtocol?
    private let connectionLayer = ConnectionLayer()
    
    func fetchArticles() {
        connectionLayer.connectionRequest(
            url: NYTimesApi.emailedPath,
            method: .get,
            headers: nil,
            parameters: nil
        ) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.remoteRequestHandler?.onArticlesFetchFailed(error: error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.remoteRequestHandler?.onArticlesFetchFailed(error: "No se recibieron datos")
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(NYTimesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.remoteRequestHandler?.onArticlesFetched(response.results)
                }
            } catch {
                DispatchQueue.main.async {
                    self.remoteRequestHandler?.onArticlesFetchFailed(error: "Error al decodificar: \(error.localizedDescription)")
                }
            }
        }
    }
}
