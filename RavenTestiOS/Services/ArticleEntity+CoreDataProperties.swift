//
//  ArticleEntity+CoreDataProperties.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation
import CoreData

extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var uri: String?
    @NSManaged public var url: String?
    @NSManaged public var assetId: Int64
    @NSManaged public var source: String?
    @NSManaged public var publishedDate: String?
    @NSManaged public var updatedDate: String?
    @NSManaged public var section: String?
    @NSManaged public var subsection: String?
    @NSManaged public var nytdsection: String?
    @NSManaged public var adxKeywords: String?
    @NSManaged public var column: String?
    @NSManaged public var byline: String?
    @NSManaged public var type: String?
    @NSManaged public var title: String?
    @NSManaged public var abstract: String?
    @NSManaged public var desFacet: NSArray?
    @NSManaged public var orgFacet: NSArray?
    @NSManaged public var perFacet: NSArray?
    @NSManaged public var geoFacet: NSArray?
    @NSManaged public var mediaData: Data?
    @NSManaged public var etaId: Int64
    @NSManaged public var lastUpdated: Date?

}

extension ArticleEntity : Identifiable {

}
