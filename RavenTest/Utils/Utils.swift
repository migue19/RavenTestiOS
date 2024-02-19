//
//  Utils.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//
import Foundation
struct Utils {
    static func decode<T: Codable>(_ type: T.Type, from data: Data, serviceName: String) -> T? {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print("DecodingError in \(serviceName) - Context:", context.codingPath)
        } catch let DecodingError.keyNotFound(key, context) {
            print("DecodingError in \(serviceName) - Key '\(key)' not found:", context.debugDescription)
            print("DecodingError in \(serviceName) - CodingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("DecodingError in \(serviceName) - Value '\(value)' not found:", context.debugDescription)
            print("DecodingError in \(serviceName) - CodingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context) {
            print("DecodingError in \(serviceName) - Type '\(type)' mismatch:", context.debugDescription)
            print("DecodingError in \(serviceName) - CodingPath:", context.codingPath)
        } catch {
            print("DecodingError in \(serviceName) - Error: ", error)
        }
        return nil
    }
}
enum PersistenceKey: String {
    case articles = "Articles"
}
struct Persistence {
    static func saveArticles(data: [ResultsModel]) {
        let encoder = JSONEncoder()
        let userDefault = UserDefaults.standard
        do {
            let data = try encoder.encode(data)
            userDefault.set(data, forKey: PersistenceKey.articles.rawValue)
        } catch {
            print("error \(error)")
        }
    }
    static func getArticles() -> [ResultsModel]? {
        let userDefault = UserDefaults.standard
        if let data = userDefault.data(forKey: PersistenceKey.articles.rawValue) {
            let decoder = JSONDecoder()
            let user = try? decoder.decode([ResultsModel].self, from: data)
            return user
        }
        return nil
    }
}
