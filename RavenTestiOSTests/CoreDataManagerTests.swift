//
//  CoreDataManagerTests.swift
//  RavenTestiOSTests
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Testing
import CoreData
@testable import RavenTestiOS

@Suite("Core Data Manager Tests")
struct CoreDataManagerTests {
    
    // MARK: - In-Memory Core Data Stack for Testing
    
    class TestCoreDataStack {
        static let shared = TestCoreDataStack()
        
        lazy var persistentContainer: NSPersistentContainer = {
            // Load the managed object model that contains ArticleEntity.
            // Use mergedModel(from: nil) to include model from app and test bundles.
            let model = NSManagedObjectModel.mergedModel(from: nil) ?? NSManagedObjectModel()
            let container = NSPersistentContainer(name: "RavenTestiOS", managedObjectModel: model)
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            
            container.loadPersistentStores { (description, error) in
                if let error = error {
                    fatalError("Failed to load in-memory store: \(error)")
                }
            }
            return container
        }()
        
        var context: NSManagedObjectContext {
            return persistentContainer.viewContext
        }
    }
    
    // Helper to ensure CoreDataManager uses the in-memory context
    private func useInMemoryContext() async {
        await MainActor.run {
            CoreDataManager.shared.overrideContext = TestCoreDataStack.shared.context
            // Ensure merge policy to avoid conflicts in tests
            CoreDataManager.shared.overrideContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
    
    // MARK: - Tests
    
    @Test("CoreDataManager saves articles successfully")
    func testSaveArticles() async throws {
        await useInMemoryContext()
        // Given
        let articles = [
            Article(uri: "nyt://article/1", url: "https://nytimes.com/article1", id: 1,
                   assetId: 1001, source: "New York Times", publishedDate: "2025-10-21",
                   updated: "2025-10-21", section: "Technology", subsection: "AI",
                   nytdsection: "technology", adxKeywords: "AI, Tech", column: nil,
                   byline: "By John Doe", type: "Article", title: "AI Revolution",
                   abstract: "How AI is changing the world", desFacet: ["Technology", "AI"],
                   orgFacet: ["Google", "OpenAI"], perFacet: ["Sam Altman"],
                   geoFacet: ["United States"], media: [], etaId: 1),
            Article(uri: "nyt://article/2", url: "https://nytimes.com/article2", id: 2,
                   assetId: 1002, source: "New York Times", publishedDate: "2025-10-21",
                   updated: "2025-10-21", section: "Business", subsection: "Markets",
                   nytdsection: "business", adxKeywords: "Stocks, Markets", column: nil,
                   byline: "By Jane Smith", type: "Article", title: "Market Analysis",
                   abstract: "Stock market trends today", desFacet: ["Business", "Markets"],
                   orgFacet: ["NYSE"], perFacet: [], geoFacet: ["New York"],
                   media: [], etaId: 2)
        ]
        
        // When
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                CoreDataManager.shared.saveArticles(articles) { success in
                    // Then
                    #expect(success == true)
                    continuation.resume()
                }
            }
        }
    }
    
    @Test("CoreDataManager fetches saved articles")
    func testFetchArticles() async throws {
        await useInMemoryContext()
        // Given - First save some articles
        let articles = [
            Article(uri: "nyt://article/3", url: "https://nytimes.com/article3", id: 3,
                   assetId: 1003, source: "New York Times", publishedDate: "2025-10-21",
                   updated: "2025-10-21", section: "Sports", subsection: "Soccer",
                   nytdsection: "sports", adxKeywords: "Soccer, World Cup", column: nil,
                   byline: "By Sports Desk", type: "Article", title: "World Cup Preview",
                   abstract: "Teams prepare for World Cup", desFacet: ["Sports", "Soccer"],
                   orgFacet: ["FIFA"], perFacet: [], geoFacet: ["Qatar"],
                   media: [], etaId: 3)
        ]
        
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                CoreDataManager.shared.saveArticles(articles) { success in
                    continuation.resume()
                }
            }
        }
        
        // When
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                CoreDataManager.shared.fetchArticles { fetchedArticles in
                    // Then
                    #expect(fetchedArticles.count > 0)
                    #expect(fetchedArticles.contains(where: { $0.id == 3 }))
                    continuation.resume()
                }
            }
        }
    }
    
    @Test("CoreDataManager checks if cached articles exist")
    func testHasCachedArticles() async throws {
        await useInMemoryContext()
        // Given - Save articles first
        let articles = [
            Article(uri: "nyt://article/4", url: "https://nytimes.com/article4", id: 4,
                   assetId: 1004, source: "New York Times", publishedDate: "2025-10-21",
                   updated: "2025-10-21", section: "Health", subsection: "",
                   nytdsection: "health", adxKeywords: "Health, Wellness", column: nil,
                   byline: "By Health Editor", type: "Article", title: "Health Tips",
                   abstract: "Stay healthy this winter", desFacet: ["Health"],
                   orgFacet: [], perFacet: [], geoFacet: [], media: [], etaId: 4)
        ]
        
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                CoreDataManager.shared.saveArticles(articles) { success in
                    continuation.resume()
                }
            }
        }
        
        // When
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                CoreDataManager.shared.hasCachedArticles { hasCache in
                    // Then
                    #expect(hasCache == true)
                    continuation.resume()
                }
            }
        }
    }
    
    @Test("CoreDataManager gets cache date")
    func testGetCacheDate() async throws {
        await useInMemoryContext()
        // Given - Save articles first
        let articles = [
            Article(uri: "nyt://article/5", url: "https://nytimes.com/article5", id: 5,
                   assetId: 1005, source: "New York Times", publishedDate: "2025-10-21",
                   updated: "2025-10-21", section: "Opinion", subsection: "",
                   nytdsection: "opinion", adxKeywords: "Politics, Opinion", column: "Op-Ed",
                   byline: "By Opinion Writer", type: "Article", title: "Political Analysis",
                   abstract: "Current political landscape", desFacet: ["Politics"],
                   orgFacet: [], perFacet: [], geoFacet: [], media: [], etaId: 5)
        ]
        
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                CoreDataManager.shared.saveArticles(articles) { success in
                    continuation.resume()
                }
            }
        }
        
        // When
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                CoreDataManager.shared.getCacheDate { date in
                    // Then
                    #expect(date != nil)
                    continuation.resume()
                }
            }
        }
    }
}
