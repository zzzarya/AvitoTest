//
//  NetworkMonitor.swift
//  AvitoTest
//
//  Created by Антон Заричный on 10.11.2022.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    var isConnected: Bool = false
    
    private init() {}
// MARK: -  Func startMonitoring
    func startMonitoring(completion: @escaping(Bool) -> Void) {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            completion(self?.isConnected ?? false)
        }
    }
}
