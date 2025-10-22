//
//  HomePresenterTests.swift
//  RavenTestiOSTests
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Testing
@testable import RavenTestiOS

@Suite("Home Presenter Tests")
struct HomePresenterTests {
    
    // MARK: - Mock Objects
    
    @MainActor
    class MockHomeView: HomeViewProtocol {
        var showHUDCalled = false
        var hideHUDCalled = false
        var showArticlesCalled = false
        var showMessageCalled = false
        var articlesReceived: [Article] = []
        var messageReceived: String?
        var messageTypeReceived: TypeMessage?
        
        func showHUD() {
            showHUDCalled = true
        }
        
        func hideHUD() {
            hideHUDCalled = true
        }
        
        func showArticles(_ articles: [Article]) {
            showArticlesCalled = true
            articlesReceived = articles
        }
        
        func showMessage(_ message: String, type: TypeMessage) {
            showMessageCalled = true
            messageReceived = message
            messageTypeReceived = type
        }
    }
    
    class MockHomeInteractor: HomeInteractorInputProtocol {
        var getArticlesCalled = false
        
        func getArticles() {
            getArticlesCalled = true
        }
    }
    
    class MockHomeRouter: HomeRouterProtocol {
        var navigateToDetailCalled = false
        var articlePassed: Article?
        
        static func createHomeModule() -> HomeView {
            return HomeView()
        }
        
        func navigateToDetail(with article: Article) {
            navigateToDetailCalled = true
            articlePassed = article
        }
    }
    
    // MARK: - Tests
    
    @Test("Presenter calls interactor to fetch articles on viewDidLoad")
    @MainActor
    func testViewDidLoadFetchesArticles() async throws {
        // Given
        let mockView = MockHomeView()
        let mockInteractor = MockHomeInteractor()
        let mockRouter = MockHomeRouter()
        
        let presenter = HomePresenter()
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
        
        // When
        presenter.viewDidLoad()
        
        // Then
        #expect(mockInteractor.getArticlesCalled == true)
    }
    
    @Test("Presenter shows HUD when articles request starts")
    @MainActor
    func testArticlesFetchedShowsHUD() async throws {
        // Given
        let mockView = MockHomeView()
        let presenter = HomePresenter()
        presenter.view = mockView
        
        let articles = [
            Article(uri: "test", url: "http://test.com", id: 1, assetId: 1, source: "NYT",
                   publishedDate: "2025-10-21", updated: "2025-10-21", section: "Tech",
                   subsection: "", nytdsection: "", adxKeywords: "", column: nil,
                   byline: "Test Author", type: "Article", title: "Test Article",
                   abstract: "Test abstract", desFacet: [], orgFacet: [], perFacet: [],
                   geoFacet: [], media: [], etaId: 1)
        ]
        
        // When
        presenter.articlesFetched(articles)
        
        // Then
        #expect(mockView.hideHUDCalled == true)
        #expect(mockView.showArticlesCalled == true)
        #expect(mockView.articlesReceived.count == 1)
    }
    
    @Test("Presenter shows error message when fetch fails")
    @MainActor
    func testArticlesFetchFailureShowsError() async throws {
        // Given
        let mockView = MockHomeView()
        let presenter = HomePresenter()
        presenter.view = mockView
        
        let errorMessage = "Network error"
        
        // When
        presenter.articlesFetchFailed(errorMessage)
        
        // Then
        #expect(mockView.hideHUDCalled == true)
        #expect(mockView.showMessageCalled == true)
        #expect(mockView.messageReceived == errorMessage)
        #expect(mockView.messageTypeReceived == .error)
    }
    
    @Test("Presenter navigates to detail when article is selected")
    @MainActor
    func testDidSelectArticleNavigatesToDetail() async throws {
        // Given
        let mockRouter = MockHomeRouter()
        let presenter = HomePresenter()
        presenter.router = mockRouter
        
        let article = Article(uri: "test", url: "http://test.com", id: 1, assetId: 1, source: "NYT",
                             publishedDate: "2025-10-21", updated: "2025-10-21", section: "Tech",
                             subsection: "", nytdsection: "", adxKeywords: "", column: nil,
                             byline: "Test Author", type: "Article", title: "Test Article",
                             abstract: "Test abstract", desFacet: [], orgFacet: [], perFacet: [],
                             geoFacet: [], media: [], etaId: 1)
        
        // When
        presenter.didSelectArticle(article)
        
        // Then
        #expect(mockRouter.navigateToDetailCalled == true)
        #expect(mockRouter.articlePassed?.id == article.id)
    }
}
