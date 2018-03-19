//
//  MJConfigModel.m
//  MJBao
//
//  Created by Baird-weng on 2018/1/26.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "MJConfigModel.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "CSReachability.h"
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>
#import "CSSBsJson4.h"
#import "CSGTMBase64.h"
#import <sys/utsname.h>
#import "CSGSKeyschains.h"
#import "Header.h"
#import <Security/Security.h>
#import "AppDelegate.h"

NSString *const KEY = @"whatthefuckakey1931csez";
NSString *const KEY_TJ = @"whatthefuckakeytj9377jkl";
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
-(NSString *)Model
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    return platform;
}
-(NSString *)ScreenReslution
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    return [NSString stringWithFormat:@"%0.0f*%0.0f", screenRect.size.width, screenRect.size.height];
}
-(NSString *)SystemName{
    return [[UIDevice currentDevice] systemName];
}
-(NSMutableDictionary *)publicData{
    NSMutableDictionary * publicData = [NSMutableDictionary dictionary];
    NSString * timestamp = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
    [publicData setObject:timestamp forKey:@"time"];
    [publicData setObject:self.gameID forKey:@"game"];
    [publicData setObject:@(self.platForm) forKey:@"platform"]; //--------------
    [publicData setObject:[self deviceImei] forKey:@"device_imei"];//------------------
    [publicData setObject:self.gameReferer forKey:@"referer"];
    [publicData setObject:@"" forKey:@"ad_param"]; //-----------------
    [publicData setObject:[self Model] forKey:@"device_model"];
    [publicData setObject:[self ScreenReslution] forKey:@"device_resolution"];
    [publicData setObject:[self SystemName] forKey:@"device_os"];
    [publicData setObject:[[NSString alloc] initWithFormat:@"%@",@""] forKey:@"device_carrier"];
    [publicData setObject:[self CurrentNetType] forKey:@"device_network"];
    [publicData setObject:[self ParameterSignWithTimestamp:timestamp] forKey:@"sign"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [publicData setObject:[infoDictionary objectForKey:@"CFBundleVersion"] forKey:@"ver"];
    [publicData setObject:SDKVER forKey:@"sdkver"];
    [publicData setObject:self.gameID forKey:@"gameid"];
    if (self.uuid)
    {
        [publicData setObject:self.uuid forKey:@"uuid"];
    }

    if (self.ad_param)
    {
        [publicData setObject:self.ad_param forKey:@"ad_param"];
    }
    if (self.referer_param)
    {
        [publicData setObject:self.referer_param forKey:@"referer_param"];
    }
    return publicData;
}
-(NSString *)ParameterSignWithTimestamp:(NSString *)timestamp
{
    return [self md5:[NSString stringWithFormat:@"%@%@%@%@%@", @"whatthefuckakeytj9377jkl", self.gameID, [self deviceImei], self.gameReferer, timestamp]];
}
-(NSString *)CurrentNetType
{
    CSReachability *rea = [CSReachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([rea currentReachabilityStatus])
    {
        case ReachableViaWiFi:
        {
            return @"WIFI";
        }
            break;
        case ReachableViaWWAN:
        {
            return @"WWAN";
        }
            break;
        default:
        {
            return @"unknown";
        }
            break;
    }
    return @"unknown";
}
+(NSString *)UUID:(NSString *)gameid
{
    NSString *uuid = [CSGSKeyschains passwordForService:gameid account:gameid];
    if (uuid&&uuid.length > 4){
        return uuid;
    }
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
    [CSGSKeyschains setPassword:uuid forService:gameid labl:gameid  account:gameid];
    return uuid;
}
- (NSString*)deviceImei{
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
- (NSString*)md5:(NSString*)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
- (NSMutableDictionary*)IAPDict:(SKProduct*)product withSKPaymentTransaction:(SKPaymentTransaction*)tran
{
        NSMutableDictionary * publicData = [NSMutableDictionary dictionary];
        NSMutableString *strall = [[NSMutableString alloc]init];
    
        NSMutableArray *keyarray;
        //    uuid
        if ([MJConfigModel shared].uuid)
        {
            [publicData setObject:[MJConfigModel shared].uuid forKey:@"uuid"];
            [strall appendString:[MJConfigModel shared].uuid];
            keyarray = [[NSMutableArray alloc]initWithObjects:@"uuid",@"idfa",@"locale",@"sandbox",@"price",@"game_id",@"server",@"username",@"currency",@"data",@"sign", nil];
    
        }
        else
        {
            keyarray = [[NSMutableArray alloc]initWithObjects:@"idfa",@"locale",@"sandbox",@"price",@"game_id",@"server",@"username",@"currency",@"data",@"sign", nil];
        }
    
    
        //    idfa
        [publicData setObject:[self deviceImei] forKey:@"idfa"];
        //    currency
        NSLocale *priceLocale = [product priceLocale];
        [publicData setObject:[priceLocale objectForKey:NSLocaleLanguageCode] forKey:@"currency"];
        //    sandbox
    
    #ifdef DEBUG
        [publicData setObject:[NSNumber numberWithBool:YES] forKey:@"sandbox"];
    #else
        [publicData setObject:[NSNumber numberWithBool:NO] forKey:@"sandbox"];
    #endif
    
    
    
        //    price
        [publicData setObject:self.price forKey:@"price"];
        //    game_id
        [publicData setObject:self.gameID forKey:@"game_id"];
        //    server
        if (self.serverType) //9377服务区
        {
            [publicData setObject:[NSString stringWithFormat:@"%ld", (long)self.serverType] forKey:@"server"];
        }
        else
        {
            [publicData setObject:[NSString stringWithFormat:@"%ld", (long)self.serverType] forKey:@"_server"];
            keyarray = [[NSMutableArray alloc]initWithObjects:@"uuid",@"idfa",@"locale",@"sandbox",@"price",@"game_id",@"_server",@"username",@"currency",@"data",@"sign", nil];
        }
    
        //    username
        [publicData setObject:self.UserName forKey:@"username"];
        //    locale
        NSString *displayName = [priceLocale displayNameForKey:NSLocaleCountryCode value:[priceLocale objectForKey:NSLocaleCountryCode]];
        [publicData setObject:[displayName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"locale"];
        //    data
    
    
        //    NSString * productIdentifier = tran.payment.productIdentifier;
    
        NSString *transactionReceiptString= nil;
    
        //系统IOS7.0以上获取支付验证凭证的方式应该改变，切验证返回的数据结构也不一样了。
        [publicData setObject:tran.transactionIdentifier forKey:@"transaction_id"];
        if([[UIDevice currentDevice].systemVersion doubleValue]>=7.0)
    
        {
            NSURLRequest*appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle]appStoreReceiptURL]];
            NSError *error = nil;
            NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
            transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            NSLog(@"re applicationUsername:%@",tran.payment.applicationUsername);
            [self.extrainStrlogo  appendString:@":苹果返回"];
            if (tran.payment.applicationUsername)
            {
                [publicData setObject:tran.payment.applicationUsername forKey:@"extra_info"];
                [self.extrainStrlogo  appendString:@":设置上报透传"];
                [self.extrainStrlogo  appendString:tran.payment.applicationUsername];
            }
            else
            {
                if (self.extrainStr)
                {
                    [publicData setObject:self.extrainStr forKey:@"extra_info"];
                    [self.extrainStrlogo  appendString:@":设置透传"];
                    [self.extrainStrlogo  appendString:self.extrainStr];
                }
            }
    
    
        }
        else
        {
            NSData * receiptData = tran.transactionReceipt;
            transactionReceiptString = [CSGTMBase64 stringByEncodingData:receiptData];
            if (self.extrainStr)
            {
                [publicData setObject:self.extrainStr forKey:@"extra_info"];
                [self.extrainStrlogo  appendString:@":ios6设置透传"];
                [self.extrainStrlogo  appendString:self.extrainStr];
            }
    
        }
        if (transactionReceiptString)
        {
            [publicData setObject:transactionReceiptString forKey:@"data"];
        }
        else
        {
            return nil;
        }
    
        [strall appendString:[publicData objectForKey:@"idfa"]];
        [strall appendString:[publicData objectForKey:@"locale"]];
        [strall appendString:[NSString stringWithFormat:@"%d",[[publicData objectForKey:@"sandbox"] intValue]]];
        [strall appendString:[NSString stringWithFormat:@"%0.0f", [[publicData objectForKey:@"price"] floatValue]]];
        [strall appendString:[publicData objectForKey:@"game_id"]];
        if (self.serverType) //9377服务区
        {
            //        [publicData setObject:[NSString stringWithFormat:@"%@",self.server] forKey:@"server"];
            [strall appendString:[publicData objectForKey:@"server"]];
        }
        else
        {
            //        [publicData setObject:[NSString stringWithFormat:@"%@",self.server] forKey:@"_server"];
            [strall appendString:[publicData objectForKey:@"_server"]];
        }
    
        [strall appendString:[publicData objectForKey:@"username"]];
        [strall appendString:[publicData objectForKey:@"currency"]];
        [strall appendString:[publicData objectForKey:@"data"]];
    
    
        [strall appendString:@"i4psu.@ckm$yb4%11s"];
        NSString *sign = [self md5:strall];
        [publicData setObject:sign forKey:@"sign"];
        [publicData setObject:self.extrainStrlogo forKey:@"extra_logo"];
        return  publicData;
}

+(BOOL)iscomment:(NSString*)commentversion
{
    NSString *sdkcomment = [[NSUserDefaults standardUserDefaults] objectForKey:@"sdk_comment"];
    if (sdkcomment.length == 0) {
        return YES;
    }
    if ([commentversion intValue] > [sdkcomment intValue]) {
        return YES;
    }
    return NO;
}
- (BOOL)saveIAP:(NSMutableDictionary*)iapDict{
    NSMutableArray *array = [self AllIAP];
    NSMutableArray *placesT = nil;
    if (array) {
        placesT = [array mutableCopy];
    } else {
        placesT = [[NSMutableArray alloc] init];
    }
    [placesT addObject:iapDict];
    [[NSUserDefaults standardUserDefaults] setObject:placesT forKey:@"CSIAP"];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSMutableArray *)AllIAP{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"CSIAP"];
}
@end

