//
//  RavenTestiOSTests.swift
//  RavenTestiOSTests
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//
import UIKit
import Testing
@testable import RavenTestiOS

@Suite("RavenTestiOS - Main Test Suite")
struct RavenTestiOSTests {

    @Test("App launches successfully")
    func testAppLaunch() async throws {
        // Given
        let appDelegate = AppDelegate()
        
        // When
        let didFinishLaunching = appDelegate.application(
            UIApplication.shared,
            didFinishLaunchingWithOptions: nil
        )
        
        // Then
        #expect(didFinishLaunching == true)
    }
    
    @Test("ArrayTransformer is registered on app launch")
    func testArrayTransformerRegistration() async throws {
        // Given
        ArrayTransformer.register()
        
        // When
        let transformer = ValueTransformer(forName: ArrayTransformer.name)
        
        // Then
        #expect(transformer != nil)
    }

}
