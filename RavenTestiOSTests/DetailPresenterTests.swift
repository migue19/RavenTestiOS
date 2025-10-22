//
//  DetailPresenterTests.swift
//  RavenTestiOSTests
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Testing
import SwiftMessages
@testable import RavenTestiOS

@Suite("Detail Presenter Tests")
struct DetailPresenterTests {
    
    // MARK: - Mock Objects
    
    @MainActor
    class MockDetailView: DetailViewProtocol {
        var presenter: DetailPresenterProtocol?
        var showArticleDetailCalled = false
        var articleReceived: Article?
        var showMessageCalled = false
        var showHUDCalled = false
        var hideHUDCalled = false
        
        nonisolated func showArticleDetail(_ article: Article) {
            MainActor.assumeIsolated {
                showArticleDetailCalled = true
                articleReceived = article
            }
        }
        
        nonisolated func showMessage(message: String, type: Theme) {
            MainActor.assumeIsolated {
                showMessageCalled = true
            }
        }
        
        nonisolated func showHUD() {
            MainActor.assumeIsolated {
                showHUDCalled = true
            }
        }
        
        nonisolated func hideHUD() {
            MainActor.assumeIsolated {
                hideHUDCalled = true
            }
        }
    }
    
    class MockDetailInteractor: DetailInteractorInputProtocol {
        var presenter: DetailInteractorOutputProtocol?
        var article: Article?
        var getArticleURLCalled = false
        
        func getArticleURL() {
            getArticleURLCalled = true
            if let url = article?.url {
                presenter?.didGetArticleURL(url)
            }
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
        mockInteractor.article = article
        
        // When
        presenter.viewDidLoad()
        
        // Then
        #expect(mockView.showArticleDetailCalled == true)
        #expect(mockView.articleReceived?.id == article.id)
    }
    
    @Test("Presenter opens article URL correctly")
    @MainActor
    func testOpenArticleInBrowser() async throws {
        // Given
        let mockView = MockDetailView()
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
        presenter.view = mockView
        presenter.interactor = mockInteractor
        mockInteractor.article = article
        
        // When
        presenter.openArticleInBrowser()
        
        // Then
        #expect(mockInteractor.getArticleURLCalled == true)
    }
}
