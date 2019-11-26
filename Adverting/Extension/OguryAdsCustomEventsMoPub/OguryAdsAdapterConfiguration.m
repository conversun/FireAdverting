//
//  OguryAdsAdapterConfiguration.m
//  MopubCustomEvents
//
//  Copyright © 2019 Ogury Co. All rights reserved.
//

#import "OguryAdsAdapterConfiguration.h"
#import <OguryAds/OguryAds.h>
@implementation OguryAdsAdapterConfiguration
+ (void)updateInitializationParameters:(NSDictionary *)parameters {
    
}
- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> * _Nullable)configuration complete:(void(^ _Nullable)(NSError * _Nullable))complete {
    complete(nil);
}

-(NSString *)adapterVersion {
    return @"1.0";
}

-(NSString *)biddingToken {
    return nil;
}

-(NSString *)moPubNetworkName {
    return @"ogury";
}
-(NSString *)networkSdkVersion {
    return [[OguryAds shared]sdkVersion];
}
@end
