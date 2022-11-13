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
    
    private init() {}
// MARK: -  Func startMonitoring
    func startMonitoring(completion: @escaping(Bool) -> Void) {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            completion(path.status == .satisfied)
        }
    }
}
