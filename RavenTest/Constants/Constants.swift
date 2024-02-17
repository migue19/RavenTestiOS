//
//  Constants.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//

import Foundation

struct NYTimesApi {
    static let key = "A6oNT5FFnIpGhVsDA8in4AGfwkh340DZ"
    static let apiKeyParam = "?api-key="
    static let base = "https://api.nytimes.com/svc/mostpopular/"
    static let emailed = "v2/emailed/7.json"
    static let emailedPath = base + emailed + apiKeyParam + key
}
