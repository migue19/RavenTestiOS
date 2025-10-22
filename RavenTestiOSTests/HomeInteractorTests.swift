//
//  HomeInteractorTests.swift
//  RavenTestiOSTests
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Testing
@testable import RavenTestiOS

@Suite("Home Interactor Tests")
struct HomeInteractorTests {
    
    // MARK: - Mock Objects
    
    class MockHomePresenter: HomeInteractorOutputProtocol {
        var articlesFetchedCalled = false
        var articlesFetchFailedCalled = false
        var articlesReceived: [Article] = []
        var errorReceived: String?
        
        func articlesFetched(_ articles: [Article]) {
            articlesFetchedCalled = true
            articlesReceived = articles
        }
        
        func articlesFetchFailed(_ error: String) {
            articlesFetchFailedCalled = true
            errorReceived = error
        }
    }
    
    class MockHomeRemoteDataManager: HomeRemoteDataManagerInputProtocol {
        var fetchArticlesCalled = false
        var shouldSucceed = true
        var mockArticles: [Article] = []
        
        weak var remoteRequestHandler: HomeRemoteDataManagerOutputProtocol?
        
        func fetchArticles() {
            fetchArticlesCalled = true
            
            if shouldSucceed {
                remoteRequestHandler?.articlesRetrieved(mockArticles)
            } else {
                remoteRequestHandler?.articlesFetchFailed("Network error")
            }
        }
    }
    
    class MockHomeLocalDataManager: HomeLocalDataManagerInputProtocol {
        var saveArticlesCalled = false
        var fetchArticlesCalled = false
        var hasCachedArticlesCalled = false
        var mockCachedArticles: [Article] = []
        var hasCache = false
        
        func saveArticles(_ articles: [Article], completion: @escaping (Bool) -> Void) {
            saveArticlesCalled = true
            completion(true)
        }
        
        func fetchArticles(completion: @escaping ([Article]) -> Void) {
            fetchArticlesCalled = true
            completion(mockCachedArticles)
        }
        
        func hasCachedArticles(completion: @escaping (Bool) -> Void) {
            hasCachedArticlesCalled = true
            completion(hasCache)
        }
    }
    
    // MARK: - Tests
    
    @Test("Interactor fetches articles from remote data manager")
    func testGetArticlesCallsRemoteDataManager() async throws {
        // Given
        let mockPresenter = MockHomePresenter()
        let mockRemoteDataManager = MockHomeRemoteDataManager()
        let mockLocalDataManager = MockHomeLocalDataManager()
        
        let interactor = HomeInteractor()
        interactor.presenter = mockPresenter
        interactor.remoteDatamanager = mockRemoteDataManager
        interactor.localDatamanager = mockLocalDataManager
        mockRemoteDataManager.remoteRequestHandler = interactor
        
        // When
        interactor.getArticles()
        
        // Then
        #expect(mockRemoteDataManager.fetchArticlesCalled == true)
    }
    
    @Test("Interactor notifies presenter when articles are retrieved successfully")
    func testArticlesRetrievedNotifiesPresenter() async throws {
        // Given
        let mockPresenter = MockHomePresenter()
        let mockRemoteDataManager = MockHomeRemoteDataManager()
        let mockLocalDataManager = MockHomeLocalDataManager()
        
        let articles = [
            Article(uri: "test", url: "http://test.com", id: 1, assetId: 1, source: "NYT",
                   publishedDate: "2025-10-21", updated: "2025-10-21", section: "Tech",
                   subsection: "", nytdsection: "", adxKeywords: "", column: nil,
                   byline: "Test Author", type: "Article", title: "Test Article",
                   abstract: "Test abstract", desFacet: [], orgFacet: [], perFacet: [],
                   geoFacet: [], media: [], etaId: 1)
        ]
        
        mockRemoteDataManager.mockArticles = articles
        mockRemoteDataManager.shouldSucceed = true
        
        let interactor = HomeInteractor()
        interactor.presenter = mockPresenter
        interactor.remoteDatamanager = mockRemoteDataManager
        interactor.localDatamanager = mockLocalDataManager
        mockRemoteDataManager.remoteRequestHandler = interactor
        
        // When
        interactor.getArticles()
        
        // Then
        #expect(mockPresenter.articlesFetchedCalled == true)
        #expect(mockPresenter.articlesReceived.count == 1)
        #expect(mockLocalDataManager.saveArticlesCalled == true)
    }
    
    @Test("Interactor notifies presenter when articles fetch fails")
    func testArticlesFetchFailedNotifiesPresenter() async throws {
        // Given
        let mockPresenter = MockHomePresenter()
        let mockRemoteDataManager = MockHomeRemoteDataManager()
        let mockLocalDataManager = MockHomeLocalDataManager()
        
        mockRemoteDataManager.shouldSucceed = false
        mockLocalDataManager.hasCache = false
        
        let interactor = HomeInteractor()
        interactor.presenter = mockPresenter
        interactor.remoteDatamanager = mockRemoteDataManager
        interactor.localDatamanager = mockLocalDataManager
        mockRemoteDataManager.remoteRequestHandler = interactor
        
        // When
        interactor.getArticles()
        
        // Then
        #expect(mockPresenter.articlesFetchFailedCalled == true)
        #expect(mockPresenter.errorReceived == "Network error")
    }
    
    @Test("Interactor loads cached articles when available")
    func testLoadCachedArticles() async throws {
        // Given
        let mockPresenter = MockHomePresenter()
        let mockLocalDataManager = MockHomeLocalDataManager()
        
        let cachedArticles = [
            Article(uri: "cached", url: "http://cached.com", id: 2, assetId: 2, source: "NYT",
                   publishedDate: "2025-10-20", updated: "2025-10-20", section: "Business",
                   subsection: "", nytdsection: "", adxKeywords: "", column: nil,
                   byline: "Cached Author", type: "Article", title: "Cached Article",
                   abstract: "Cached abstract", desFacet: [], orgFacet: [], perFacet: [],
                   geoFacet: [], media: [], etaId: 2)
        ]
        
        mockLocalDataManager.mockCachedArticles = cachedArticles
        mockLocalDataManager.hasCache = true
        
        let interactor = HomeInteractor()
        interactor.presenter = mockPresenter
        interactor.localDatamanager = mockLocalDataManager
        
        // When
        interactor.loadCachedArticles()
        
        // Then
        #expect(mockLocalDataManager.fetchArticlesCalled == true)
    }
}
