//
//  AdvertingSource+ad.swift
//  Pods
//
//  Created by Conver on 8/11/2019.
//

import MoPub

public class NativeADSource: NSObject, ADSource {
    public var adActions: [(type: ADEvent, event: () -> Void)] = []

    public var nativeAd: MPNativeAd?

    private let adID: String

    public init(_ adID: String) {
        self.adID = adID
        super.init()
    }

    public var isAdLoaded: Bool = false

    public var isAdLoading: Bool = false
    
    public var adViewTappedGesture: [UIGestureRecognizer]?

    public weak var adPresentationViewController: UIViewController?
    public weak var adPresentationContainerView: UIView?
    public var networkRendererConfigurations: [MPNativeAdRendererConfiguration] = [] {
        didSet {
            NativeAdRendererManager.shared
                .networkRendererConfigurations = networkRendererConfigurations
        }
    }

    public var mopubRendererSettings: MPStaticNativeAdRendererSettings {
        return NativeAdRendererManager.shared.mopubRendererSettings
    }

    public var mopubVideoRendererSettings: MOPUBNativeVideoAdRendererSettings {
        return NativeAdRendererManager.shared.mopubVideoRendererSettings
    }

    var rendererConfigurations: [MPNativeAdRendererConfiguration] {
        return NativeAdRendererManager.shared.enabledRendererConfigurations
    }

    var targetting: MPNativeAdRequestTargeting {
        let target: MPNativeAdRequestTargeting = MPNativeAdRequestTargeting()
        target.desiredAssets = Set(arrayLiteral: kAdTitleKey, kAdTextKey, kAdCTATextKey, kAdIconImageKey, kAdMainImageKey, kAdStarRatingKey, kAdIconImageViewKey, kAdMainMediaViewKey)
//        target.keywords = adUnit.keywords
//        target.userDataKeywords = adUnit.userDataKeywords

        return target
    }

    @discardableResult
    public func adLoad() -> Self {
        guard !isAdLoading else { return self }
        isAdLoading = true

        let adRequest: MPNativeAdRequest = MPNativeAdRequest(adUnitIdentifier: adID, rendererConfigurations: rendererConfigurations)
        adRequest.targeting = targetting
        DispatchQueue.main.async {
            adRequest.start { [weak self] _, nativeAd, error in
                guard let `self` = self else { return }
                self.isAdLoading = false

                guard error == nil else {
                    self.isAdLoaded = false
                    self.adEvent(.didFailToLoad)?.event()
                    return
                }

                self.nativeAd = nativeAd
                self.nativeAd?.delegate = self
                self.isAdLoaded = true
                self.adEvent(.didLoad)?.event()
            }
        }
        return self
    }

    @discardableResult
    public func adShow() -> Self {
        guard isAdLoaded, adPresentationViewController != nil else { return self }
        if let nativeAd = nativeAd, let nativeAdView = try? nativeAd.retrieveAdView() {
//            nativeAdView.gestureRecognizers?.forEach {
//                if let tapGesture = $0 as? UITapGestureRecognizer {
//                    adViewTappedGesture = [tapGesture]
//                }
//            }
//
//            if adViewTappedGesture == nil {
//                nativeAdView.subviews.forEach {
//                    if let gestures = $0.gestureRecognizers {
//                        adViewTappedGesture = gestures
//                    }
//                }
//            }
            
            addToAdContainer(view: nativeAdView)
        }
        return self
    }
}

extension NativeADSource {
    private func addToAdContainer(view: UIView) {
        guard let containerView = adPresentationContainerView else { return }

        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }
        containerView.addSubview(view)

        view.frame = containerView.bounds
    }
}

extension NativeADSource: MPNativeAdDelegate {
    public func willPresentModal(for _: MPNativeAd!) {
        adEvent(.willPresentModal)?.event()
    }

    public func didDismissModal(for _: MPNativeAd!) {
        adEvent(.didDismissModal)?.event()
    }

    public func willLeaveApplication(from _: MPNativeAd!) {
        adEvent(.willLeaveApp)?.event()
    }

    public func viewControllerForPresentingModalView() -> UIViewController! {
        return adPresentationViewController ??
            UIApplication.rootController?.rootVC?.visibleVC
    }

    public func mopubAd(_: MPMoPubAd, didTrackImpressionWith _: MPImpressionData?) {
        adEvent(.didTrackImpression)?.event()
    }
}
