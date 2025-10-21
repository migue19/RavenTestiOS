//
//  CoreDataManager.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Context
    private var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Save Articles
    func saveArticles(_ articles: [Article], completion: @escaping (Bool) -> Void) {
        context.perform {
            // Primero eliminar todos los artículos existentes
            self.deleteAllArticles()
            
            // Guardar los nuevos artículos
            for article in articles {
                let entity = ArticleEntity(context: self.context)
                entity.id = Int64(article.id)
                entity.uri = article.uri
                entity.url = article.url
                entity.assetId = Int64(article.assetId ?? 0)
                entity.source = article.source
                entity.publishedDate = article.publishedDate
                entity.updatedDate = article.updated
                entity.section = article.section
                entity.subsection = article.subsection
                entity.nytdsection = article.nytdsection
                entity.adxKeywords = article.adxKeywords
                entity.column = article.column
                entity.byline = article.byline
                entity.type = article.type
                entity.title = article.title
                entity.abstract = article.abstract
                entity.desFacet = article.desFacet as NSArray?
                entity.orgFacet = article.orgFacet as NSArray?
                entity.perFacet = article.perFacet as NSArray?
                entity.geoFacet = article.geoFacet as NSArray?
                entity.etaId = Int64(article.etaId ?? 0)
                
                // Serializar mediaData como JSON
                if let mediaData = try? JSONEncoder().encode(article.media) {
                    entity.mediaData = mediaData
                }
                
                entity.lastUpdated = Date()
            }
            
            // Guardar el contexto
            do {
                try self.context.save()
                print("✅ CoreDataManager: \(articles.count) artículos guardados exitosamente")
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("❌ CoreDataManager Error al guardar: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Fetch Articles
    func fetchArticles(completion: @escaping ([Article]) -> Void) {
        context.perform {
            let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: false)]
            
            do {
                let entities = try self.context.fetch(fetchRequest)
                let articles = entities.compactMap { entity -> Article? in
                    // Deserializar mediaData
                    var media: [Media] = []
                    if let mediaData = entity.mediaData,
                       let decodedMedia = try? JSONDecoder().decode([Media].self, from: mediaData) {
                        media = decodedMedia
                    }
                    
                    return Article(
                        uri: entity.uri ?? "",
                        url: entity.url ?? "",
                        id: Int(entity.id),
                        assetId: entity.assetId != 0 ? Int(entity.assetId) : nil,
                        source: entity.source ?? "",
                        publishedDate: entity.publishedDate ?? "",
                        updated: entity.updatedDate ?? "",
                        section: entity.section ?? "",
                        subsection: entity.subsection ?? "",
                        nytdsection: entity.nytdsection ?? "",
                        adxKeywords: entity.adxKeywords ?? "",
                        column: entity.column,
                        byline: entity.byline ?? "",
                        type: entity.type ?? "",
                        title: entity.title ?? "",
                        abstract: entity.abstract ?? "",
                        desFacet: entity.desFacet as? [String] ?? [],
                        orgFacet: entity.orgFacet as? [String] ?? [],
                        perFacet: entity.perFacet as? [String] ?? [],
                        geoFacet: entity.geoFacet as? [String] ?? [],
                        media: media,
                        etaId: entity.etaId != 0 ? Int(entity.etaId) : nil
                    )
                }
                
                print("✅ CoreDataManager: \(articles.count) artículos recuperados")
                DispatchQueue.main.async {
                    completion(articles)
                }
            } catch {
                print("❌ CoreDataManager Error al recuperar: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    // MARK: - Check if has cached articles
    func hasCachedArticles(completion: @escaping (Bool) -> Void) {
        context.perform {
            let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
            fetchRequest.fetchLimit = 1
            
            do {
                let count = try self.context.count(for: fetchRequest)
                DispatchQueue.main.async {
                    completion(count > 0)
                }
            } catch {
                print("❌ CoreDataManager Error al verificar cache: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Get cache date
    func getCacheDate(completion: @escaping (Date?) -> Void) {
        context.perform {
            let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: false)]
            fetchRequest.fetchLimit = 1
            
            do {
                let entities = try self.context.fetch(fetchRequest)
                DispatchQueue.main.async {
                    completion(entities.first?.lastUpdated)
                }
            } catch {
                print("❌ CoreDataManager Error al obtener fecha de cache: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - Delete all articles
    private func deleteAllArticles() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ArticleEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("🗑️ CoreDataManager: Artículos antiguos eliminados")
        } catch {
            print("❌ CoreDataManager Error al eliminar: \(error.localizedDescription)")
        }
    }
}
