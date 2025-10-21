//
//  NetworkMonitor.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnected: Bool = true
    var connectionType: NWInterface.InterfaceType?
    
    // Notification name para observar cambios
    static let connectivityChanged = Notification.Name("NetworkConnectivityChanged")
    
    private init() {}
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            self.isConnected = path.status == .satisfied
            
            // Determinar tipo de conexión
            if path.usesInterfaceType(.wifi) {
                self.connectionType = .wifi
            } else if path.usesInterfaceType(.cellular) {
                self.connectionType = .cellular
            } else if path.usesInterfaceType(.wiredEthernet) {
                self.connectionType = .wiredEthernet
            } else {
                self.connectionType = nil
            }
            
            // Notificar cambios
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NetworkMonitor.connectivityChanged, object: nil)
                
                if self.isConnected {
                    print("🌐 Conectado a internet - Tipo: \(self.connectionType?.debugDescription ?? "Desconocido")")
                } else {
                    print("📵 Sin conexión a internet")
                }
            }
        }
        
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

extension NWInterface.InterfaceType {
    var debugDescription: String {
        switch self {
        case .wifi:
            return "WiFi"
        case .cellular:
            return "Celular"
        case .wiredEthernet:
            return "Ethernet"
        case .loopback:
            return "Loopback"
        case .other:
            return "Otro"
        @unknown default:
            return "Desconocido"
        }
    }
}
