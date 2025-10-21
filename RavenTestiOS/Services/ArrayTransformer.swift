//
//  ArrayTransformer.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation

@objc(ArrayTransformer)
final class ArrayTransformer: ValueTransformer {
    
    static let name = NSValueTransformerName(rawValue: "ArrayTransformer")
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [String] else { return nil }
        return try? JSONEncoder().encode(array)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? JSONDecoder().decode([String].self, from: data)
    }
    
    public static func register() {
        let transformer = ArrayTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
