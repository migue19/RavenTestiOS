//
//  ResultsModel.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//
import Foundation
struct ResultsModel: Codable, Equatable {
	let uri : String?
	let url : String?
	let id : Int?
	let asset_id : Int?
	let source : String?
	let published_date : String?
	let updated : String?
	let section : String?
	let subsection : String?
	let nytdsection : String?
	let adxKeywords : String?
	let column : String?
	let byline : String?
	let type : String?
	let title : String?
	let abstract : String?
	let des_facet : [String]?
	let org_facet : [String]?
	let per_facet : [String]?
	let geo_facet : [String]?
	let media : [Media]?
	let eta_id : Int?

	enum CodingKeys: String, CodingKey {
		case uri = "uri"
		case url = "url"
		case id = "id"
		case asset_id = "asset_id"
		case source = "source"
		case published_date = "published_date"
		case updated = "updated"
		case section = "section"
		case subsection = "subsection"
		case nytdsection = "nytdsection"
		case adx_keywords = "adx_keywords"
		case column = "column"
		case byline = "byline"
		case type = "type"
		case title = "title"
		case abstract = "abstract"
		case des_facet = "des_facet"
		case org_facet = "org_facet"
		case per_facet = "per_facet"
		case geo_facet = "geo_facet"
		case media = "media"
		case eta_id = "eta_id"
	}
    init(uri: String? = nil, url: String? = nil, id: Int? = nil, asset_id: Int? = nil, source: String? = nil, published_date: String? = nil, updated: String? = nil, section: String? = nil, subsection: String? = nil, nytdsection: String? = nil, adxKeywords: String? = nil, column: String? = nil, byline: String? = nil, type: String? = nil, title: String? = nil, abstract: String? = nil, des_facet: [String]? = nil, org_facet: [String]? = nil, per_facet: [String]? = nil, geo_facet: [String]? = nil, media: [Media]? = nil, eta_id: Int? = nil) {
        self.uri = uri
        self.url = url
        self.id = id
        self.asset_id = asset_id
        self.source = source
        self.published_date = published_date
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
        self.des_facet = des_facet
        self.org_facet = org_facet
        self.per_facet = per_facet
        self.geo_facet = geo_facet
        self.media = media
        self.eta_id = eta_id
    }
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		uri = try values.decodeIfPresent(String.self, forKey: .uri)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		asset_id = try values.decodeIfPresent(Int.self, forKey: .asset_id)
		source = try values.decodeIfPresent(String.self, forKey: .source)
		published_date = try values.decodeIfPresent(String.self, forKey: .published_date)
		updated = try values.decodeIfPresent(String.self, forKey: .updated)
		section = try values.decodeIfPresent(String.self, forKey: .section)
		subsection = try values.decodeIfPresent(String.self, forKey: .subsection)
		nytdsection = try values.decodeIfPresent(String.self, forKey: .nytdsection)
        adxKeywords = try values.decodeIfPresent(String.self, forKey: .adx_keywords)
		column = try values.decodeIfPresent(String.self, forKey: .column)
		byline = try values.decodeIfPresent(String.self, forKey: .byline)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		abstract = try values.decodeIfPresent(String.self, forKey: .abstract)
		des_facet = try values.decodeIfPresent([String].self, forKey: .des_facet)
		org_facet = try values.decodeIfPresent([String].self, forKey: .org_facet)
		per_facet = try values.decodeIfPresent([String].self, forKey: .per_facet)
		geo_facet = try values.decodeIfPresent([String].self, forKey: .geo_facet)
		media = try values.decodeIfPresent([Media].self, forKey: .media)
		eta_id = try values.decodeIfPresent(Int.self, forKey: .eta_id)
	}
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uri, forKey: .uri)
        try container.encode(title, forKey: .title)
        try container.encode(byline, forKey: .byline)
        try container.encode(published_date, forKey: .published_date)
        try container.encode(abstract, forKey: .abstract)
    }
    static func == (lhs: ResultsModel, rhs: ResultsModel) -> Bool {
        lhs.title == rhs.title
    }
}
