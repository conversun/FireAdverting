//
//  AdvertingSource+Native.swift
//  Adjust
//
//  Created by Conver on 8/11/2019.
//

import MoPub

public class RewardedADSource: NSObject, ADSource {
    public var adActions: [(type: ADEvent, event: () -> Void)] = []

    public var adPresentationViewController: UIViewController?
    public var adCustomID: String?

    private var selectedReward: MPRewardedVideoReward?

    private let adID: String

    public init(_ adID: String) {
        self.adID = adID
        super.init()
        MPRewardedVideo.setDelegate(self, forAdUnitId: adID)
    }

    deinit {
        MPRewardedVideo.removeDelegate(forAdUnitId: adID)
    }

    public var isAdLoaded: Bool {
        return MPRewardedVideo.hasAdAvailable(forAdUnitID: adID)
    }

    public var isAdLoading: Bool = false

    @discardableResult
    public func adLoad() -> Self {
        guard !isAdLoading, !isAdLoaded else { return self }
        isAdLoading = true
        selectedReward = nil
        debugPrint("adCustomID", adCustomID ?? "")
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            MPRewardedVideo.loadAd(withAdUnitID: self.adID, keywords: nil, userDataKeywords: nil, location: nil, customerId: self.adCustomID ?? "", mediationSettings: [])
        }
        return self
    }

    @discardableResult
    public func adShow() -> Self {
        guard isAdLoaded else { return self }
        guard MPRewardedVideo.hasAdAvailable(forAdUnitID: adID) else {
            debugPrint("Attempted to show a rewarded ad when it is not ready")
            return self
        }

        if let selectedReward = MPRewardedVideo.availableRewards(forAdUnitID: adID)?.first as? MPRewardedVideoReward {
            self.selectedReward = selectedReward
            MPRewardedVideo.presentAd(forAdUnitID: adID, from: adPresentationViewController, with: selectedReward, customData: "")
        }

        return self
    }
}

extension RewardedADSource: MPRewardedVideoDelegate {
    public func rewardedVideoAdDidLoad(forAdUnitID _: String!) {
        isAdLoading = false
        adEvent(.didLoad)?.event()
    }

    public func rewardedVideoAdDidFailToLoad(forAdUnitID _: String!, error _: Error!) {
        isAdLoading = false
        adEvent(.didFailToLoad)?.event()
    }

    public func rewardedVideoAdDidFailToPlay(forAdUnitID _: String!, error _: Error!) {
        adEvent(.didFailToPlay)?.event()
    }

    public func rewardedVideoAdWillAppear(forAdUnitID _: String!) {
        adEvent(.willAppear)?.event()
    }

    public func rewardedVideoAdDidAppear(forAdUnitID _: String!) {
        adEvent(.didAppear)?.event()
    }

    public func rewardedVideoAdWillDisappear(forAdUnitID _: String!) {
        adEvent(.willDisappear)?.event()
    }

    public func rewardedVideoAdDidDisappear(forAdUnitID _: String!) {
        adEvent(.didDisappear)?.event()
    }

    public func rewardedVideoAdDidExpire(forAdUnitID _: String!) {
        adEvent(.didExpire)?.event()
    }

    public func rewardedVideoAdDidReceiveTapEvent(forAdUnitID _: String!) {
        adEvent(.clicked)?.event()
    }

    public func rewardedVideoAdWillLeaveApplication(forAdUnitID _: String!) {
        adEvent(.willLeaveApp)?.event()
    }

    public func rewardedVideoAdShouldReward(forAdUnitID _: String!, reward _: MPRewardedVideoReward!) {
        adEvent(.shouldRewardUser)?.event()
    }

    public func didTrackImpression(withAdUnitID _: String!, impressionData _: MPImpressionData!) {
        adEvent(.didTrackImpression)?.event()
    }
}
