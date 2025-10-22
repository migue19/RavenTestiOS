//
//  DetailPresenterTests.swift
//  RavenTestiOSTests
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Testing
@testable import RavenTestiOS

@Suite("Detail Presenter Tests")
struct DetailPresenterTests {
    
    // MARK: - Mock Objects
    
    @MainActor
    class MockDetailView: DetailViewProtocol {
        var showArticleDetailCalled = false
        var articleReceived: Article?
        
        func showArticleDetail(_ article: Article) {
            showArticleDetailCalled = true
            articleReceived = article
        }
    }
    
    class MockDetailInteractor: DetailInteractorInputProtocol {
        var getArticleURLCalled = false
        var articlePassed: Article?
        
        func getArticleURL(for article: Article) -> String? {
            getArticleURLCalled = true
            articlePassed = article
            return article.url
        }
    }
    
    // MARK: - Tests
    
    @Test("Presenter configures view with article data")
    @MainActor
    func testViewDidLoadShowsArticleDetail() async throws {
        // Given
        let mockView = MockDetailView()
        let mockInteractor = MockDetailInteractor()
        
        let article = Article(uri: "test", url: "http://test.com", id: 1, assetId: 1, 
                             source: "NYT", publishedDate: "2025-10-21", updated: "2025-10-21", 
                             section: "Tech", subsection: "", nytdsection: "", adxKeywords: "", 
                             column: nil, byline: "Test Author", type: "Article", 
                             title: "Test Article", abstract: "Test abstract", 
                             desFacet: [], orgFacet: [], perFacet: [], geoFacet: [], 
                             media: [], etaId: 1)
        
        let presenter = DetailPresenter()
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.article = article
        
        // When
        presenter.viewDidLoad()
        
        // Then
        #expect(mockView.showArticleDetailCalled == true)
        #expect(mockView.articleReceived?.id == article.id)
    }
    
    @Test("Presenter opens article URL correctly")
    @MainActor
    func testOpenFullArticle() async throws {
        // Given
        let mockInteractor = MockDetailInteractor()
        
        let article = Article(uri: "test", url: "http://nytimes.com/article", id: 2, 
                             assetId: 2, source: "NYT", publishedDate: "2025-10-21", 
                             updated: "2025-10-21", section: "Business", subsection: "", 
                             nytdsection: "", adxKeywords: "", column: nil, 
                             byline: "Business Desk", type: "Article", 
                             title: "Business News", abstract: "Business abstract", 
                             desFacet: [], orgFacet: [], perFacet: [], geoFacet: [], 
                             media: [], etaId: 2)
        
        let presenter = DetailPresenter()
        presenter.interactor = mockInteractor
        presenter.article = article
        
        // When
        presenter.openFullArticle()
        
        // Then
        #expect(mockInteractor.getArticleURLCalled == true)
        #expect(mockInteractor.articlePassed?.id == article.id)
    }
}
