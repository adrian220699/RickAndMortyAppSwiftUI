//
//  NetworkMonitor.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/7/26.
//

import Network

final class NetworkMonitor {

    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()

    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var isConnected = true

    func startMonitoring() {

        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }

        monitor.start(queue: queue)
    }
}
