//
//  CoreDataManager.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation
import CoreData
import UIKit

public class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    private init() {}
    
    // Added: allow tests to inject an in-memory context
    public var overrideContext: NSManagedObjectContext?
    
    // Added: flag to use synchronous operations in tests
    public var isTestMode: Bool = false

    // Added: internal persistent container used as a safe fallback when AppDelegate isn't available
    private lazy var internalContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RavenTestiOS")
        let description = NSPersistentStoreDescription()
        // default store type (SQLite) — only used as a fallback
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("⚠️ CoreDataManager: failed to load internal container: \(error)")
            }
        }
        return container
    }()
    
    // MARK: - Core Data Context
    private var context: NSManagedObjectContext {
        // 1) tests can inject an in-memory context
        if let override = overrideContext {
            return override
        }
        // 2) prefer AppDelegate's container if available
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        // 3) fallback to internal container (prevents crashes during early launch/tests)
        return internalContainer.viewContext
    }
    
    // MARK: - Save Articles
    public func saveArticles(_ articles: [Article], completion: @escaping (Bool) -> Void) {
        let performBlock = {
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
                completion(true)
            } catch {
                print("❌ CoreDataManager Error al guardar: \(error.localizedDescription)")
                completion(false)
            }
        }
        
        if isTestMode {
            // In test mode, execute directly on the current thread
            performBlock()
        } else {
            // In production, execute on context's queue and dispatch completion to main
            context.perform {
                performBlock()
                // Note: performBlock already calls completion in test mode
                // In production mode, we don't call it again since performBlock does it
            }
        }
    }
    
    // MARK: - Fetch Articles
    public func fetchArticles(completion: @escaping ([Article]) -> Void) {
        let performBlock = {
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
                completion(articles)
            } catch {
                print("❌ CoreDataManager Error al recuperar: \(error.localizedDescription)")
                completion([])
            }
        }
        
        if isTestMode {
            performBlock()
        } else {
            context.perform {
                performBlock()
            }
        }
    }
    
    // MARK: - Check if has cached articles
    public func hasCachedArticles(completion: @escaping (Bool) -> Void) {
        let performBlock = {
            let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
            fetchRequest.fetchLimit = 1
            
            do {
                let count = try self.context.count(for: fetchRequest)
                completion(count > 0)
            } catch {
                print("❌ CoreDataManager Error al verificar cache: \(error.localizedDescription)")
                completion(false)
            }
        }
        
        if isTestMode {
            performBlock()
        } else {
            context.perform {
                performBlock()
            }
        }
    }
    
    // MARK: - Get cache date
    public func getCacheDate(completion: @escaping (Date?) -> Void) {
        let performBlock = {
            let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: false)]
            fetchRequest.fetchLimit = 1
            
            do {
                let entities = try self.context.fetch(fetchRequest)
                completion(entities.first?.lastUpdated)
            } catch {
                print("❌ CoreDataManager Error al obtener fecha de cache: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        if isTestMode {
            performBlock()
        } else {
            context.perform {
                performBlock()
            }
        }
    }
    
    // MARK: - Delete all articles
    private func deleteAllArticles() {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            for entity in entities {
                context.delete(entity)
            }
            if context.hasChanges {
                try context.save()
            }
            print("🗑️ CoreDataManager: Artículos antiguos eliminados")
        } catch {
            print("❌ CoreDataManager Error al eliminar: \(error.localizedDescription)")
        }
    }

}
