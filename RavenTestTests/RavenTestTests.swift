//
//  RavenTestTests.swift
//  RavenTestTests
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//

import XCTest
@testable import RavenTest

final class RavenTestTests: XCTestCase {
    private var data: [ResultsModel] = []
    override func setUp() {
        data = [
            ResultsModel(published_date: "24-03-1992", title: "Title1"),
            ResultsModel(title: "Title2" , abstract: "un pedazo de articulo"),
            ResultsModel(byline: "by Juan", title: "Title3"),
        ]
    }
    override func tearDown() {
        self.data = []
    }
    func testGetTitleArticles() {
        let expected = ["Title1", "Title2", "Title3"]
        let presenter = HomePresenter()
        let result = presenter.getTitles(data: data)
        XCTAssertEqual(result, expected)
    }
    func testPersistence() {
        let expected = data
        Persistence.saveArticles(data: expected)
        let result = Persistence.getArticles()
        XCTAssertEqual(result, expected)
    }
    func testInternetON() {
        let result = Reachability.isConnectedToNetwork()
        XCTAssertTrue(result)
    }
    func testInternetOFF() {
        let result = Reachability.isConnectedToNetwork()
        XCTAssertFalse(result)
    }
    func testDetailEntity() {
        let expected = DetailEntity(title: "Title1", author: "", date: "24-03-1992", abstract: "")
        let presenter = DetailPresenter()
        let result = presenter.detailEntity(data: data[0])
        XCTAssertEqual(result, expected)
    }
}
