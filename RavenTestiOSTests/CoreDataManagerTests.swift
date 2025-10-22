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
            let container = NSPersistentContainer(name: "RavenTestiOS")
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
    
    // MARK: - Tests
    
    @Test("CoreDataManager saves articles successfully")
    func testSaveArticles() async throws {
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
        let expectation = Confirmation("Save articles", expectedCount: 1)
        CoreDataManager.shared.saveArticles(articles) { success in
            // Then
            #expect(success == true)
            expectation.confirm()
        }
        
        await fulfillment(of: [expectation])
    }
    
    @Test("CoreDataManager fetches saved articles")
    func testFetchArticles() async throws {
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
        
        let saveExpectation = Confirmation("Save before fetch", expectedCount: 1)
        CoreDataManager.shared.saveArticles(articles) { success in
            saveExpectation.confirm()
        }
        await fulfillment(of: [saveExpectation])
        
        // When
        let fetchExpectation = Confirmation("Fetch articles", expectedCount: 1)
        CoreDataManager.shared.fetchArticles { fetchedArticles in
            // Then
            #expect(fetchedArticles.count > 0)
            #expect(fetchedArticles.contains(where: { $0.id == 3 }))
            fetchExpectation.confirm()
        }
        
        await fulfillment(of: [fetchExpectation])
    }
    
    @Test("CoreDataManager checks if cached articles exist")
    func testHasCachedArticles() async throws {
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
        
        let saveExpectation = Confirmation("Save before check", expectedCount: 1)
        CoreDataManager.shared.saveArticles(articles) { success in
            saveExpectation.confirm()
        }
        await fulfillment(of: [saveExpectation])
        
        // When
        let checkExpectation = Confirmation("Check cache", expectedCount: 1)
        CoreDataManager.shared.hasCachedArticles { hasCache in
            // Then
            #expect(hasCache == true)
            checkExpectation.confirm()
        }
        
        await fulfillment(of: [checkExpectation])
    }
    
    @Test("CoreDataManager gets cache date")
    func testGetCacheDate() async throws {
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
        
        let saveExpectation = Confirmation("Save before date check", expectedCount: 1)
        CoreDataManager.shared.saveArticles(articles) { success in
            saveExpectation.confirm()
        }
        await fulfillment(of: [saveExpectation])
        
        // When
        let dateExpectation = Confirmation("Get cache date", expectedCount: 1)
        CoreDataManager.shared.getCacheDate { date in
            // Then
            #expect(date != nil)
            dateExpectation.confirm()
        }
        
        await fulfillment(of: [dateExpectation])
    }
}
