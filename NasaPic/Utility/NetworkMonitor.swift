//
//  NetworkMonitor.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import Network
import UIKit

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    enum NetworkStatus {
        case connected, notConnected

        static func availableStatus(status: NWPath.Status) -> Self {
            switch status {
            case .satisfied:
                return .connected
            default:
                return .notConnected
            }
        }
    }

    enum Constants {
        static let kNetworkReachabilityChange = "networkReachabilityChanged"
        static let networkMonitorLabel = "NetworkStatus_Monitor"
        static let networkMonitorStatus = "Status"
    }

    private var monitor: NWPathMonitor?
    var currentStatus: NWPath.Status?

    func monitorNetworkChange() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: Constants.networkMonitorLabel)

        monitor?.start(queue: queue)
        monitor?.pathUpdateHandler = { [weak self] _ in
            guard let currentStatus = self?.monitor?.currentPath.status else { return }

            self?.currentStatus = currentStatus
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(Constants.kNetworkReachabilityChange),
                                                object: self,
                                                userInfo: [Constants.networkMonitorStatus: NetworkStatus.availableStatus(status: currentStatus)])
            }
        }
    }

    func stopMonitoring() {
        monitor = nil
        monitor?.cancel()
    }

    class func isNetworkReachable() -> Bool {
        shared.currentStatus == .satisfied
    }
}
