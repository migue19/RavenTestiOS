//
//  HomeModels.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation

// MARK: - NY Times Response Models
public struct NYTimesResponse: Codable {
    public let status: String
    public let copyright: String
    public let numResults: Int
    public let results: [Article]
    
    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case numResults = "num_results"
        case results
    }
}

public struct Article: Codable {
    public let uri: String
    public let url: String
    public let id: Int
    public let assetId: Int?
    public let source: String
    public let publishedDate: String
    public let updated: String
    public let section: String
    public let subsection: String
    public let nytdsection: String
    public let adxKeywords: String?
    public let column: String?
    public let byline: String
    public let type: String
    public let title: String
    public let abstract: String
    public let desFacet: [String]
    public let orgFacet: [String]
    public let perFacet: [String]
    public let geoFacet: [String]
    public let media: [Media]
    public let etaId: Int?
    
    public init(uri: String, url: String, id: Int, assetId: Int?, source: String, publishedDate: String, updated: String, section: String, subsection: String, nytdsection: String, adxKeywords: String?, column: String?, byline: String, type: String, title: String, abstract: String, desFacet: [String], orgFacet: [String], perFacet: [String], geoFacet: [String], media: [Media], etaId: Int?) {
        self.uri = uri
        self.url = url
        self.id = id
        self.assetId = assetId
        self.source = source
        self.publishedDate = publishedDate
        self.updated = updated
        self.section = section
        self.subsection = subsection
        self.nytdsection = nytdsection
        self.adxKeywords = adxKeywords
        self.column = column
        self.byline = byline
        self.type = type
        self.title = title
        self.abstract = abstract
        self.desFacet = desFacet
        self.orgFacet = orgFacet
        self.perFacet = perFacet
        self.geoFacet = geoFacet
        self.media = media
        self.etaId = etaId
    }
    
    enum CodingKeys: String, CodingKey {
        case uri, url, id
        case assetId = "asset_id"
        case source
        case publishedDate = "published_date"
        case updated, section, subsection, nytdsection
        case adxKeywords = "adx_keywords"
        case column, byline, type, title, abstract
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case media
        case etaId = "eta_id"
    }
}

public struct Media: Codable {
    public let type: String
    public let subtype: String
    public let caption: String
    public let copyright: String
    public let approvedForSyndication: Int
    public let mediaMetadata: [MediaMetadata]
    
    public init(type: String, subtype: String, caption: String, copyright: String, approvedForSyndication: Int, mediaMetadata: [MediaMetadata]) {
        self.type = type
        self.subtype = subtype
        self.caption = caption
        self.copyright = copyright
        self.approvedForSyndication = approvedForSyndication
        self.mediaMetadata = mediaMetadata
    }
    
    enum CodingKeys: String, CodingKey {
        case type, subtype, caption, copyright
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetadata = "media-metadata"
    }
}

public struct MediaMetadata: Codable {
    public let url: String
    public let format: String
    public let height: Int
    public let width: Int
    
    public init(url: String, format: String, height: Int, width: Int) {
        self.url = url
        self.format = format
        self.height = height
        self.width = width
    }
}
