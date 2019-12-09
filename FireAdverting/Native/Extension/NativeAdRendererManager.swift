//
//  NativeAdRendererManager.swift
//
//  Copyright 2018-2019 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

import Foundation
import MoPub

#if canImport(MoPub_AdMob_Adapters)
    import MoPub_AdMob_Adapters
#endif
#if canImport(MoPub_FacebookAudienceNetwork_Adapters)
    import MoPub_FacebookAudienceNetwork_Adapters
#endif
#if canImport(MoPub_Flurry_Adapters)
    import MoPub_Flurry_Adapters
#endif
#if canImport(MoPub_Verizon_Adapters)
    import MoPub_Verizon_Adapters
#endif

final class NativeAdRendererManager {
    static let shared = NativeAdRendererManager()
    private let userDefaults: UserDefaults

    /**
     Class name of enabled renderers.
     */
    var enabledRendererClassNames: [String] {
        get {
            return userDefaults.enabledAdRenderers
        }
        set {
            userDefaults.enabledAdRenderers = newValue
        }
    }

    /**
     Class name of disabled renderers.
     */
    var disabledRendererClassNames: [String] {
        get {
            return userDefaults.disabledAdRenderers
        }
        set {
            userDefaults.disabledAdRenderers = newValue
        }
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        let existedRendererClassNames = Set(enabledRendererClassNames + disabledRendererClassNames)
        let newRendererClassNames = rendererConfigurations.compactMap {
            existedRendererClassNames.contains($0.rendererClassName) ? nil : $0.rendererClassName
        }
        if !newRendererClassNames.isEmpty {
            // enable all new renderers by default
            enabledRendererClassNames += newRendererClassNames
        }
    }

    /**
     Enabled ad renderer configurations.
     */
    var enabledRendererConfigurations: [MPNativeAdRendererConfiguration] {
        let disabledAdRenderers = Set(disabledRendererClassNames)
        let configs = rendererConfigurations.filter {
            !disabledAdRenderers.contains($0.rendererClassName)
        }
        return (configs as [StringKeyable]).sorted(inTheSameOrderAs: enabledRendererClassNames)
    }

    /**
     Renderers for mediated networks
     */
    var networkRendererConfigurations: [MPNativeAdRendererConfiguration] = []
}

// MARK: - Private

extension NativeAdRendererManager {
    /**
     Ad renderer configurations.
     */
    var rendererConfigurations: [MPNativeAdRendererConfiguration] {
        let networkRendererConfigurations = self.networkRendererConfigurations // cache computed var result
        var configs = [MPNativeAdRendererConfiguration]()
        configs.append(MOPUBNativeVideoAdRenderer.rendererConfiguration(with: mopubVideoRendererSettings))
        configs.append(contentsOf: networkRendererConfigurations)
        configs.append({ // add `MPStaticNativeAdRenderer`
            var networkSupportedCustomEvents = Set<String>() // add the custom event names to `MPStaticNativeAdRenderer`
            networkRendererConfigurations.forEach {
                networkSupportedCustomEvents.formUnion($0.supportedCustomEvents as? [String] ?? [])
            }
            return MPStaticNativeAdRenderer.rendererConfiguration(with: mopubRendererSettings,
                                                                  additionalSupportedCustomEvents: Array(networkSupportedCustomEvents))
        }())

        return configs
    }

    /**
     MoPub static ad renderer settings
     */
    var mopubRendererSettings: MPStaticNativeAdRendererSettings {
        // MoPub static renderer
        let mopubSettings: MPStaticNativeAdRendererSettings = MPStaticNativeAdRendererSettings()
        mopubSettings.renderingViewClass = NativeAdView.self
        mopubSettings.viewSizeHandler = { (width) -> CGSize in
            CGSize(width: width, height: NativeAdView.estimatedViewHeightForWidth(width))
        }

        return mopubSettings
    }

    /**
     MoPub video ad renderer settings
     */
    var mopubVideoRendererSettings: MOPUBNativeVideoAdRendererSettings {
        // MoPub video renderer
        let mopubVideoSettings: MOPUBNativeVideoAdRendererSettings = MOPUBNativeVideoAdRendererSettings()
        mopubVideoSettings.renderingViewClass = NativeAdView.self
        mopubVideoSettings.viewSizeHandler = { (width) -> CGSize in
            CGSize(width: width, height: NativeAdView.estimatedViewHeightForWidth(width))
        }

        return mopubVideoSettings
    }

    /**
     Renderers for mediated networks
     */
//    var networkRendererConfigurations: [MPNativeAdRendererConfiguration] {
//        var renderers: [MPNativeAdRendererConfiguration] = []
//
//        // OPTIONAL: AdMob native renderer
//        #if canImport(MoPub_AdMob_Adapters)
//            if let admobConfig = MPGoogleAdMobNativeRenderer.rendererConfiguration(with: mopubRendererSettings) {
//                renderers.append(admobConfig)
//            }
//        #endif
//
//        #if canImport(MoPub_FacebookAudienceNetwork_Adapters)
//            renderers.append(FacebookNativeAdRenderer.rendererConfiguration(with: mopubRendererSettings))
//        #endif
//
//        // OPTIONAL: Flurry native video renderer
//        #if canImport(MoPub_Flurry_Adapters)
//            if let flurryConfig = FlurryNativeVideoAdRenderer.rendererConfiguration(with: mopubVideoRendererSettings) {
//                renderers.append(flurryConfig)
//            }
//        #endif
//
//        // OPTIONAL: Verizon native video renderer
//        #if canImport(MoPub_Verizon_Adapters)
//            if let verizonConfig = MPVerizonNativeAdRenderer.rendererConfiguration(with: mopubVideoRendererSettings) {
//                renderers.append(verizonConfig)
//            }
//        #endif
//        return renderers
//    }
}

// MARK: - Private UserDefaults Storage

private extension UserDefaults {
    /**
     The private `UserDefaults.Key` for accessing `enabledAdRenderers`.
     */
    private var enabledAdRenderersKey: Key<[String]> {
        return Key<[String]>("enabledAdRenderers", defaultValue: [])
    }

    /**
     A list class names of enabled native ad renderer. When picking a renderer for native ads, the
     first match in this list should be picked.
     */
    var enabledAdRenderers: [String] {
        get {
            return self[enabledAdRenderersKey]
        }
        set {
            self[enabledAdRenderersKey] = newValue
        }
    }
}

private extension UserDefaults {
    /**
     The private `UserDefaults.Key` for accessing `disabledAdRenderers`.
     */
    private var disabledAdRenderersKey: Key<[String]> {
        return Key<[String]>("disabledAdRenderers", defaultValue: [])
    }

    /**
     A list of class names of disabled native ad renderer.
     */
    var disabledAdRenderers: [String] {
        get {
            return self[disabledAdRenderersKey]
        }
        set {
            self[disabledAdRenderersKey] = newValue
        }
    }
}
