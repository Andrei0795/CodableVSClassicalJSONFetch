//
//  NetworkMonitor.swift
//  CodableVSClassicalJSONFetch
//
//  Created by Andrei Ionescu on 28.05.2024.
//

import Network
import Combine
class NetworkMonitor {
    var hasInternetConnection = PassthroughSubject<Bool, Never>()
    
    func checkInternetConnection() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("We're connected!")
                self?.hasInternetConnection.send(true)
                monitor.cancel()
            } else {
                self?.hasInternetConnection.send(true)
                print("No connection.")
                monitor.cancel()
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
