//
//  HomeInteractor.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//  
//

import Foundation

class HomeInteractor: HomeInteractorInputProtocol {

    // MARK: Properties
    weak var presenter: HomeInteractorOutputProtocol?
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol?
    var localDataManager: HomeLocalDataManagerInputProtocol?
    
    func getArticles() {
        // Primero intentar cargar desde cache (experiencia instantánea)
        loadCachedArticles()
        
        // Luego intentar obtener datos frescos del servidor
        remoteDatamanager?.fetchArticles()
    }
    
    // MARK: - Private Methods
    private func loadCachedArticles() {
        localDataManager?.fetchArticles { [weak self] cachedArticles in
            if !cachedArticles.isEmpty {
                print("📦 Mostrando \(cachedArticles.count) artículos desde cache")
                self?.presenter?.didFetchArticles(cachedArticles)
            }
        }
    }
}

extension HomeInteractor: HomeRemoteDataManagerOutputProtocol {
    func onArticlesFetched(_ articles: [Article]) {
        // Guardar artículos en cache
        localDataManager?.saveArticles(articles) { success in
            if success {
                print("💾 Artículos guardados en cache exitosamente")
            } else {
                print("⚠️ Error al guardar artículos en cache")
            }
        }
        
        // Notificar al presenter con los datos frescos
        presenter?.didFetchArticles(articles)
    }
    
    func onArticlesFetchFailed(error: String) {
        print("❌ onArticlesFetchFailed: \(error)")
        // Si falla la petición remota, verificar si hay datos en cache
        localDataManager?.hasCachedArticles { [weak self] hasCache in
            if hasCache {
                // Hay datos en cache, mostrarlos con un mensaje informativo
                print("📡 Sin conexión - Usando datos guardados")
                self?.localDataManager?.fetchArticles { cachedArticles in
                    if !cachedArticles.isEmpty {
                        self?.presenter?.didFetchArticles(cachedArticles)
                    } else {
                        // Cache vacío, mostrar error
                        self?.presenter?.didFailFetchingArticles(error: error)
                    }
                }
            } else {
                // No hay datos en cache, mostrar error
                print("⚠️ No cache available - showing error")
                self?.presenter?.didFailFetchingArticles(error: error)
            }
        }
    }
}
