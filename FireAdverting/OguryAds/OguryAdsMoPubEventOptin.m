//
//  OguryAdsMoPubEventOptin.m
//  MopubCustomEvents
//
//  Copyright © 2019 Ogury Co. All rights reserved.
//

#import "OguryAdsMoPubEventOptin.h"
#import <OguryAds/OguryAds.h>

@interface OguryAdsMoPubEventOptin()<OguryAdsOptinVideoDelegate>
@property (nonatomic,strong) OguryAdsOptinVideo * optinVideo;
@end
@implementation OguryAdsMoPubEventOptin

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSString * adunitId = [info objectForKey:@"ad_unit_id"];
    self.optinVideo = [[OguryAdsOptinVideo alloc]initWithAdUnitID:adunitId];
    self.optinVideo.optInVideoDelegate = self;
    [self.optinVideo load];
}

-(BOOL)hasAdAvailable {
    return self.optinVideo.isLoaded;
}

-(void)presentRewardedVideoFromViewController:(UIViewController *)viewController {
    [self.optinVideo showInViewController:viewController];
}

- (void)oguryAdsOptinVideoAdAvailable {
    
}

- (void)oguryAdsOptinVideoAdClosed {
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}

- (void)oguryAdsOptinVideoAdDisplayed {
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

- (void)oguryAdsOptinVideoAdError:(OguryAdsErrorType)errorType {
    NSError * error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
}

- (void)oguryAdsOptinVideoAdLoaded {
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

- (void)oguryAdsOptinVideoAdNotAvailable {
    NSError * error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
}

- (void)oguryAdsOptinVideoAdNotLoaded {
    NSError * error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
}

- (void)oguryAdsOptinVideoAdRewarded:(OGARewardItem *)item {
    MPRewardedVideoReward * reward = [[MPRewardedVideoReward alloc]initWithCurrencyType:item.rewardName amount:@([item.rewardValue floatValue])];
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:reward];
}

@end
