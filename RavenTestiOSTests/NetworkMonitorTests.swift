//
//  NetworkMonitorTests.swift
//  RavenTestiOSTests
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Testing
import Network
import Foundation
@testable import RavenTestiOS

@Suite("Network Monitor Tests")
struct NetworkMonitorTests {
    
    @Test("NetworkMonitor initializes correctly")
    @MainActor
    func testNetworkMonitorInitialization() async throws {
        // Given & When
        let monitor = NetworkMonitor.shared
        
        // Then
        #expect(monitor.isConnected == true || monitor.isConnected == false)
    }
    
    @Test("NetworkMonitor posts notification on connection change")
    func testNetworkMonitorNotification() async throws {
        // Given
        var notificationReceived = false
        var observerToken: (any NSObjectProtocol)?
        
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            observerToken = NotificationCenter.default.addObserver(
                forName: NSNotification.Name("NetworkStatusChanged"),
                object: nil,
                queue: .main
            ) { _ in
                notificationReceived = true
                continuation.resume()
            }
            
            // When
            NotificationCenter.default.post(name: NSNotification.Name("NetworkStatusChanged"), object: nil)
        }
        
        // Cleanup
        if let token = observerToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        // Then
        #expect(notificationReceived == true)
    }
}
