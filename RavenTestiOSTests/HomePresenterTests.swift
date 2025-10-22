//
//  HomePresenterTests.swift
//  RavenTestiOSTests
//
//  Created by Miguel Mexicano Herrera on 22/10/25.
//

import XCTest
import SwiftMessages
@testable import RavenTestiOS

class HomePresenterTests: XCTestCase {
    
    var sut: HomePresenter!
    var mockView: MockHomeView!
    var mockInteractor: MockHomeInteractor!
    var mockRouter: MockHomeRouter!
    
    override func setUp() {
        super.setUp()
        sut = HomePresenter()
        mockView = MockHomeView()
        mockInteractor = MockHomeInteractor()
        mockRouter = MockHomeRouter()
        
        sut.view = mockView
        sut.interactor = mockInteractor
        sut.router = mockRouter
    }
    
    override func tearDown() {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    // MARK: - Tests for viewDidLoad
    
    func testViewDidLoad_ShouldCallFetchArticles() {
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.showHUDCalled, "showHUD should be called")
        XCTAssertTrue(mockInteractor.getArticlesCalled, "getArticles should be called")
    }
    
    // MARK: - Tests for fetchArticles
    
    func testFetchArticles_ShouldShowHUDAndCallInteractor() {
        // When
        sut.fetchArticles()
        
        // Then
        XCTAssertTrue(mockView.showHUDCalled, "showHUD should be called")
        XCTAssertTrue(mockInteractor.getArticlesCalled, "getArticles should be called on interactor")
    }
    
    // MARK: - Tests for didSelectArticle
    
    func testDidSelectArticle_ShouldNavigateToDetail() {
        // Given
        let article = createMockArticle()
        
        // When
        sut.didSelectArticle(article)
        
        // Then
        XCTAssertTrue(mockRouter.navigateToDetailCalled, "navigateToDetail should be called")
        XCTAssertEqual(mockRouter.articlePassed?.title, article.title, "The correct article should be passed")
    }
    
    // MARK: - Tests for didFetchArticles (HomeInteractorOutputProtocol)
    
    func testDidFetchArticles_ShouldHideHUDAndShowArticles() {
        // Given
        let articles = [createMockArticle(), createMockArticle(title: "Article 2")]
        
        // When
        sut.didFetchArticles(articles)
        
        // Then
        XCTAssertTrue(mockView.hideHUDCalled, "hideHUD should be called")
        XCTAssertTrue(mockView.showArticlesCalled, "showArticles should be called")
        XCTAssertEqual(mockView.articlesShown?.count, 2, "Should show 2 articles")
    }
    
    func testDidFetchArticles_WithEmptyArray_ShouldStillShowArticles() {
        // Given
        let articles: [Article] = []
        
        // When
        sut.didFetchArticles(articles)
        
        // Then
        XCTAssertTrue(mockView.hideHUDCalled, "hideHUD should be called")
        XCTAssertTrue(mockView.showArticlesCalled, "showArticles should be called")
        XCTAssertEqual(mockView.articlesShown?.count, 0, "Should show empty array")
    }
    
    // MARK: - Tests for didFailFetchingArticles (HomeInteractorOutputProtocol)
    
    func testDidFailFetchingArticles_ShouldHideHUDAndShowError() {
        // Given
        let errorMessage = "Network error occurred"
        
        // When
        sut.didFailFetchingArticles(error: errorMessage)
        
        // Then
        XCTAssertTrue(mockView.hideHUDCalled, "hideHUD should be called")
        XCTAssertTrue(mockView.showErrorCalled, "showError should be called")
        XCTAssertEqual(mockView.errorShown, errorMessage, "The correct error message should be shown")
    }
    
    // MARK: - Helper Methods
    
    private func createMockArticle(title: String = "Test Article") -> Article {
        return Article(
            uri: "test-uri",
            url: "https://test.com",
            id: 123,
            assetId: 456,
            source: "Test Source",
            publishedDate: "2025-10-22",
            updated: "2025-10-22",
            section: "Technology",
            subsection: "Mobile",
            nytdsection: "tech",
            adxKeywords: "test",
            column: nil,
            byline: "Test Author",
            type: "Article",
            title: title,
            abstract: "Test abstract",
            desFacet: [],
            orgFacet: [],
            perFacet: [],
            geoFacet: [],
            media: [],
            etaId: 1
        )
    }
}

// MARK: - Mock Classes

class MockHomeView: HomeViewProtocol {
    var presenter: HomePresenterProtocol?
    
    var showHUDCalled = false
    var hideHUDCalled = false
    var showArticlesCalled = false
    var showErrorCalled = false
    var showMessageCalled = false
    var articlesShown: [Article]?
    var errorShown: String?
    var messageShown: String?
    
    func showHUD() {
        showHUDCalled = true
    }
    
    func hideHUD() {
        hideHUDCalled = true
    }
    
    func showArticles(_ articles: [Article]) {
        showArticlesCalled = true
        articlesShown = articles
    }
    
    func showError(_ error: String) {
        showErrorCalled = true
        errorShown = error
    }
    
    func showMessage(message: String, type: Theme) {
        showMessageCalled = true
        messageShown = message
    }
}

class MockHomeInteractor: HomeInteractorInputProtocol {
    var presenter: HomeInteractorOutputProtocol?
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol?
    var localDataManager: HomeLocalDataManagerInputProtocol?
    
    var getArticlesCalled = false
    
    func getArticles() {
        getArticlesCalled = true
    }
}

class MockHomeRouter: HomeRouterProtocol {
    var view: HomeView?
    
    var navigateToDetailCalled = false
    var articlePassed: Article?
    
    static func createHomeModule() -> UIViewController {
        return UIViewController()
    }
    
    func navigateToDetail(with article: Article) {
        navigateToDetailCalled = true
        articlePassed = article
    }
}
