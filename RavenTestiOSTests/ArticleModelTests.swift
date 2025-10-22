//
//  ArticleModelTests.swift
//  RavenTestiOSTests
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Testing
@testable import RavenTestiOS

@Suite("Article Model Tests")
struct ArticleModelTests {
    
    @Test("Article model decodes from JSON correctly")
    func testArticleDecoding() async throws {
        // Given
        let json = """
        {
            "uri": "nyt://article/test",
            "url": "https://nytimes.com/test",
            "id": 123,
            "asset_id": 456,
            "source": "New York Times",
            "published_date": "2025-10-21",
            "updated": "2025-10-21",
            "section": "Technology",
            "subsection": "AI",
            "nytdsection": "technology",
            "adx_keywords": "AI, Tech",
            "byline": "By Test Author",
            "type": "Article",
            "title": "Test Article Title",
            "abstract": "This is a test abstract",
            "des_facet": ["Technology", "AI"],
            "org_facet": ["Google"],
            "per_facet": ["Sundar Pichai"],
            "geo_facet": ["California"],
            "media": [],
            "eta_id": 789
        }
        """.data(using: .utf8)!
        
        // When
        let article = try JSONDecoder().decode(Article.self, from: json)
        
        // Then
        #expect(article.id == 123)
        #expect(article.uri == "nyt://article/test")
        #expect(article.url == "https://nytimes.com/test")
        #expect(article.title == "Test Article Title")
        #expect(article.abstract == "This is a test abstract")
        #expect(article.section == "Technology")
        #expect(article.byline == "By Test Author")
        #expect(article.desFacet.count == 2)
        #expect(article.orgFacet.count == 1)
    }
    
    @Test("Article model handles optional fields")
    func testArticleOptionalFields() async throws {
        // Given
        let json = """
        {
            "uri": "nyt://article/minimal",
            "url": "https://nytimes.com/minimal",
            "id": 999,
            "asset_id": 111,
            "source": "New York Times",
            "published_date": "2025-10-21",
            "updated": "2025-10-21",
            "section": "World",
            "subsection": "",
            "nytdsection": "world",
            "adx_keywords": "",
            "byline": "By World Desk",
            "type": "Article",
            "title": "Minimal Article",
            "abstract": "Minimal abstract",
            "des_facet": [],
            "org_facet": [],
            "per_facet": [],
            "geo_facet": [],
            "media": [],
            "eta_id": 0
        }
        """.data(using: .utf8)!
        
        // When
        let article = try JSONDecoder().decode(Article.self, from: json)
        
        // Then
        #expect(article.id == 999)
        #expect(article.column == nil)
        #expect(article.desFacet.isEmpty)
        #expect(article.orgFacet.isEmpty)
        #expect(article.perFacet.isEmpty)
        #expect(article.geoFacet.isEmpty)
    }
    
    @Test("NYTimesResponse decodes correctly")
    func testNYTimesResponseDecoding() async throws {
        // Given
        let json = """
        {
            "status": "OK",
            "copyright": "Copyright (c) 2025 The New York Times Company.",
            "num_results": 1,
            "results": [
                {
                    "uri": "nyt://article/test",
                    "url": "https://nytimes.com/test",
                    "id": 100,
                    "asset_id": 200,
                    "source": "New York Times",
                    "published_date": "2025-10-21",
                    "updated": "2025-10-21",
                    "section": "U.S.",
                    "subsection": "",
                    "nytdsection": "u.s.",
                    "adx_keywords": "News",
                    "byline": "By Reporter",
                    "type": "Article",
                    "title": "Breaking News",
                    "abstract": "Important news",
                    "des_facet": [],
                    "org_facet": [],
                    "per_facet": [],
                    "geo_facet": [],
                    "media": [],
                    "eta_id": 0
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When
        let response = try JSONDecoder().decode(NYTimesResponse.self, from: json)
        
        // Then
        #expect(response.status == "OK")
        #expect(response.numResults == 1)
        #expect(response.results.count == 1)
        #expect(response.results.first?.title == "Breaking News")
    }
}
