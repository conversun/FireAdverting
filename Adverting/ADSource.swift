//
//  AdvertingSource.swift
//  Pods
//
//  Created by Conver on 8/11/2019.
//

import Foundation
import MoPub

public struct ADUnit: Codable {
    public let id: String
    public let testID: String

    public func productionID() -> String {
        if UIApplication.shared.inferredEnvironment == .debug {
            return testID
        } else {
            return id
        }
    }
}

public enum ADEvent: Hashable {
    case didLoad
    case didFailToLoad
    case didFailToPlay
    case willAppear
    case didAppear
    case willDisappear
    case didDisappear
    case willPresentModal
    case didDismissModal
    case didExpire
    case clicked
    case willLeaveApp
    case shouldRewardUser
    case didTrackImpression
}

public protocol ADSource {
    var isAdLoaded: Bool { get }
    var isAdLoading: Bool { get }
    var adActions: [(type: ADEvent, event: () -> Void)] { get set }

    func adLoad() -> Self
    func adShow() -> Self
    mutating func setStatus(_ type: ADEvent, event: @escaping (() -> Void)) -> Self
}

public extension ADSource {
    func adEvent(_ type: ADEvent) -> (type: ADEvent, event: () -> Void)? {
        return adActions.filter { $0.type == type }.first
    }

    @discardableResult
    mutating func setStatus(_ type: ADEvent, event: @escaping (() -> Void)) -> Self {
        adActions.removeAll { $0.type == type }
        adActions.append((type, event))
        return self
    }
}
