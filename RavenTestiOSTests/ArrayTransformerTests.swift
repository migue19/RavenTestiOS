//
//  ArrayTransformerTests.swift
//  RavenTestiOSTests
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Testing
@testable import RavenTestiOS
import Foundation

@Suite("Array Transformer Tests")
struct ArrayTransformerTests {
    
    @Test("ArrayTransformer transforms array to data")
    func testTransformArrayToData() async throws {
        // Given
        let transformer = ArrayTransformer()
        let inputArray = ["Technology", "AI", "Machine Learning"]
        
        // When
        let transformedData = transformer.transformedValue(inputArray) as? Data
        
        // Then
        #expect(transformedData != nil)
        #expect(transformedData!.count > 0)
    }
    
    @Test("ArrayTransformer reverses data to array")
    func testReverseTransformDataToArray() async throws {
        // Given
        let transformer = ArrayTransformer()
        let inputArray = ["Business", "Markets", "Stocks"]
        let data = transformer.transformedValue(inputArray) as? Data
        
        // When
        let reversedArray = transformer.reverseTransformedValue(data) as? [String]
        
        // Then
        #expect(reversedArray != nil)
        #expect(reversedArray?.count == 3)
        #expect(reversedArray?[0] == "Business")
        #expect(reversedArray?[1] == "Markets")
        #expect(reversedArray?[2] == "Stocks")
    }
    
    @Test("ArrayTransformer handles empty array")
    func testTransformEmptyArray() async throws {
        // Given
        let transformer = ArrayTransformer()
        let emptyArray: [String] = []
        
        // When
        let transformedData = transformer.transformedValue(emptyArray) as? Data
        let reversedArray = transformer.reverseTransformedValue(transformedData) as? [String]
        
        // Then
        #expect(transformedData != nil)
        #expect(reversedArray != nil)
        #expect(reversedArray?.isEmpty == true)
    }
    
    @Test("ArrayTransformer handles nil input")
    func testTransformNilInput() async throws {
        // Given
        let transformer = ArrayTransformer()
        
        // When
        let transformedData = transformer.transformedValue(nil)
        
        // Then
        #expect(transformedData == nil)
    }
    
    @Test("ArrayTransformer registration")
    func testTransformerRegistration() async throws {
        // Given & When
        ArrayTransformer.register()
        let registeredTransformer = ValueTransformer(forName: ArrayTransformer.name)
        
        // Then
        #expect(registeredTransformer != nil)
        #expect(registeredTransformer is ArrayTransformer)
    }
}
