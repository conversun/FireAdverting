//
//  AdvertingSource+.swift
//  Pods
//
//  Created by Conver on 8/11/2019.
//

import MoPub

public class InterstitialADSource: NSObject, ADSource {
    public var adActions: [(type: ADEvent, event: () -> Void)] = []

    private var interstitialAd: MPInterstitialAdController

    public init(_ adID: String) {
        interstitialAd = MPInterstitialAdController(forAdUnitId: adID)
        super.init()
        interstitialAd.delegate = self
    }

    public var isAdLoaded: Bool {
        return interstitialAd.ready
    }

    public var isAdLoading: Bool = false

    @discardableResult
    public func adLoad() -> Self {
        guard !isAdLoading, !isAdLoaded else { return self }
        isAdLoading = true
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.interstitialAd.loadAd()
        }
        return self
    }

    @discardableResult
    public func adShow() -> Self {
        guard isAdLoaded else { return self }
        interstitialAd.show(from: UIApplication.rootController?.visibleVC)
        return self
    }
}

extension InterstitialADSource: MPInterstitialAdControllerDelegate {
    public func interstitialDidLoadAd(_: MPInterstitialAdController!) {
        isAdLoading = false
        adEvent(.didLoad)?.event()
    }

    public func interstitialDidFail(toLoadAd _: MPInterstitialAdController!) {
        isAdLoading = false
        adEvent(.didFailToLoad)?.event()
    }

    public func interstitialWillAppear(_: MPInterstitialAdController!) {
        adEvent(.willAppear)?.event()
    }

    public func interstitialDidAppear(_: MPInterstitialAdController!) {
        adEvent(.didAppear)?.event()
    }

    public func interstitialWillDisappear(_: MPInterstitialAdController!) {
        adEvent(.willDisappear)?.event()
    }

    public func interstitialDidDisappear(_: MPInterstitialAdController!) {
        adEvent(.didDisappear)?.event()
    }

    public func interstitialDidExpire(_: MPInterstitialAdController!) {
        adEvent(.didExpire)?.event()
    }

    public func interstitialDidReceiveTapEvent(_: MPInterstitialAdController!) {
        adEvent(.clicked)?.event()
    }

    public func mopubAd(_: MPMoPubAd, didTrackImpressionWith _: MPImpressionData?) {
        adEvent(.didTrackImpression)?.event()
    }
}
