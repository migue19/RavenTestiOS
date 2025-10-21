//
//  Constants.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//
struct NYTimesApi {
    static let key = "qTl6HA9lEk9bHwEMNSrdjRAceMnSqQEZ"
    static let apiKeyParam = "?api-key="
    static let base = "https://api.nytimes.com/svc/mostpopular/"
    static let emailed = "v2/emailed/7.json"
    static let emailedPath = base + emailed + apiKeyParam + key
}
