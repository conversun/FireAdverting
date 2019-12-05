//
//  OguryAdsMoPubEventInterstitial.m
//  MopubCustomEvents
//
//  Copyright © 2019 Ogury Co. All rights reserved.
//

#import "OguryAdsMoPubEventInterstitial.h"
#import <OguryAds/OguryAds.h>

@interface OguryAdsMoPubEventInterstitial()<OguryAdsInterstitialDelegate>
@property (nonatomic,strong) OguryAdsInterstitial * interstitial;
@end

@implementation OguryAdsMoPubEventInterstitial

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSString * adunitId = [info objectForKey:@"ad_unit_id"];
    self.interstitial = [[OguryAdsInterstitial alloc]initWithAdUnitID:adunitId];
    self.interstitial.interstitialDelegate = self;
    [self.interstitial load];
}

-(void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    if (self.interstitial.isLoaded) {
        [self.interstitial showInViewController:rootViewController];
    }
    
}

- (void)oguryAdsInterstitialAdAvailable {

}

- (void)oguryAdsInterstitialAdClosed {
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)oguryAdsInterstitialAdDisplayed {
    [self.delegate interstitialCustomEventDidAppear:self];

}

- (void)oguryAdsInterstitialAdError:(OguryAdsErrorType)errorType {
    NSError * error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsInterstitialAdLoaded {
    [self.delegate interstitialCustomEvent:self didLoadAd:nil];
}

- (void)oguryAdsInterstitialAdNotAvailable {
    NSError * error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsInterstitialAdNotLoaded {
    NSError * error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

@end
