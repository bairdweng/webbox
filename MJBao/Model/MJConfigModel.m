//
//  MJConfigModel.m
//  MJBao
//
//  Created by Baird-weng on 2018/1/26.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "MJConfigModel.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import "CSReachability.h"
#import "CSGSKeyschains.h"
#import "Header.h"
#import <Security/Security.h>
@implementation MJConfigModel
+ (MJConfigModel *) shared {
    static MJConfigModel * _sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[MJConfigModel alloc] init];
        _sharedHelper.iap = nil;
    });
    return _sharedHelper;
}
-(NSString*)idfa{
    NSString* idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if ([idfa isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
        idfa = [CSGSKeyschains passwordForService:CSGSKEYCHAINKEY account:CSGSKEYCHAINKEY];
        if(!idfa){
            idfa = [self getUUID];
            [CSGSKeyschains setPassword:idfa forService:CSGSKEYCHAINKEY labl:CSGSKEYCHAINKEY account:CSGSKEYCHAINKEY];
        }
    }
    return idfa;
}
-(NSString *)getUUID{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString* result = (NSString*)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
-(NSString*)launchImageName{
    CGSize viewSize = mainSize;
    NSString *viewOrientation = @"Portrait";
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return launchImage;
}
-(NSString *)disPlayName{
    NSDictionary*infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName = [infoDic objectForKey:@"CFBundleDisplayName"];
    if(!displayName){
        displayName = NSLocalizedString(@"CFBundleDisplayName",@"总是中文");
    }
    if (!displayName) {
        displayName = @"母包";
    }
    return displayName;
}
-(NSString *)appBuild{
    NSDictionary*infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *CFBundleVersion = [infoDic objectForKey:@"CFBundleVersion"];
    if(!CFBundleVersion){
        return @"1.0.0";
    } else {
        return CFBundleVersion;
    }
}
- (NSString*)appVersion
{
    NSDictionary*infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleShortVersionString = [infoDic objectForKey:@"CFBundleShortVersionString"];
    if(!bundleShortVersionString){
        return @"1.0.0";
    } else {
        return bundleShortVersionString;
    }
}
-(NSString *)bundleName{
    NSDictionary*infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName = [infoDic objectForKey:@"CFBundleName"];
    if(!displayName){
        displayName = @"MJBao";
    }
    return displayName;
}
@end
