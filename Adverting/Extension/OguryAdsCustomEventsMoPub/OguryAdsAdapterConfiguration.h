//
//  OguryAdsAdapterConfiguration.h
//  MopubCustomEvents
//
//  Copyright © 2019 Ogury Co. All rights reserved.
//

#import <MoPub/MoPub.h>

NS_ASSUME_NONNULL_BEGIN

@interface OguryAdsAdapterConfiguration : MPBaseAdapterConfiguration

@property (nonatomic, copy, readonly) NSString * adapterVersion;
@property (nonatomic, copy, readonly) NSString * biddingToken;
@property (nonatomic, copy, readonly) NSString * moPubNetworkName;
@property (nonatomic, copy, readonly) NSString * networkSdkVersion;

@end

NS_ASSUME_NONNULL_END
