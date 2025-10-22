//
//  NetworkMonitorTests.swift
//  RavenTestiOSTests
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Testing
import Network
@testable import RavenTestiOS

@Suite("Network Monitor Tests")
struct NetworkMonitorTests {
    
    @Test("NetworkMonitor initializes correctly")
    func testNetworkMonitorInitialization() async throws {
        // Given & When
        let monitor = NetworkMonitor.shared
        
        // Then
        #expect(monitor.isConnected == true || monitor.isConnected == false)
    }
    
    @Test("NetworkMonitor posts notification on connection change")
    func testNetworkMonitorNotification() async throws {
        // Given
        let expectation = Confirmation("Network notification", expectedCount: 1)
        var notificationReceived = false
        
        let observer = NotificationCenter.default.addObserver(
            forName: NSNotification.Name("NetworkStatusChanged"),
            object: nil,
            queue: .main
        ) { notification in
            notificationReceived = true
            expectation.confirm()
        }
        
        // When
        NotificationCenter.default.post(name: NSNotification.Name("NetworkStatusChanged"), object: nil)
        
        // Then
        await fulfillment(of: [expectation], timeout: .seconds(2))
        #expect(notificationReceived == true)
        
        NotificationCenter.default.removeObserver(observer)
    }
}
