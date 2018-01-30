//
//  MJUrlModel.m
//  MJBao
//
//  Created by Baird-weng on 2018/1/26.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//http://game.e9e66.com 7Y2U1MGFIUjBjRG92TDJkaGJXVXVaVGxsTmpZdVkyOXQ0ce503a1

#import "MJUrlModel.h"
#import "CSGTMBase64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MJUrlModel
+ (MJUrlModel *) shared {
    static MJUrlModel * _sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[MJUrlModel alloc] init];
        _sharedHelper.iap = nil;
    });
    return _sharedHelper;
}
-(NSString *)gameInfoURL{
    return [NSString stringWithFormat:@"%@/api/hstat.php", [self hx_getHost]];
}
-(NSString *)loginURL{
    return [NSString stringWithFormat:@"%@/login.php",[self hx_getHost]];
}
-(NSString *)registerURL{
    return [NSString stringWithFormat:@"%@/register.php",[self hx_getHost]];
}
-(NSString *)statisticalURL{
    return [NSString stringWithFormat:@"%@/h5/api/tj.php",[self hx_getHost]];
}
-(NSString *)sdkURL{
    return [NSString stringWithFormat:@"%@/h5/api/sdk.php", [self hx_getHost]];
}

- (NSString*)hx_getHost{
    return [self hx_decodeStringWithStr:@"7Y2U1MGFIUjBjRG92TDJkaGJXVXVaVGxsTmpZdVkyOXQ0ce503a1"];
}

-(NSString *)hx_decodeStringWithStr:(NSString *)resultsStr
{
    if (resultsStr.length > 0 )
    {
        int n = [[resultsStr substringWithRange:NSMakeRange(0,1)] intValue];
        if (n == 0 )
        {
            return nil;
        }
        NSMutableString *str = [[NSMutableString alloc]initWithString:resultsStr];
        [str deleteCharactersInRange:NSMakeRange(0,1)];
        [str deleteCharactersInRange:NSMakeRange(str.length - n, n)];
        NSString *restr  = [NSString stringWithFormat:@"%@",str];
        restr = [restr stringByReplacingOccurrencesOfString:@"|" withString:@"="];
        NSString *base = [self csGTMBase64WithString:restr];
        n = [[base substringWithRange:NSMakeRange(base.length-1,1)] intValue];
        if (n == 0 )
        {
            return nil;
        }
        str = [[NSMutableString alloc]initWithString:base];
        [str deleteCharactersInRange:NSMakeRange(0,n)];
        [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
        restr  = [NSString stringWithFormat:@"%@",str];
        restr = [restr stringByReplacingOccurrencesOfString:@"|" withString:@"="];
        base = [self csGTMBase64WithString:restr];
        return base;
    }
    return nil;
}
//加密
-(NSString *)hx_enCodeStringWithResult:(NSString *)result
{
    if (result){
        NSString* str = [[result dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        str = [str stringByReplacingOccurrencesOfString:@"=" withString:@"|"];
        int n = (arc4random() % 8) + 1;
        NSString *time = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
        NSString *key = [[self md5:time] substringWithRange:NSMakeRange(0,n)];
        str = [NSString stringWithFormat:@"%@%@%d",key,str,n];
        str = [[str dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        str = [str stringByReplacingOccurrencesOfString:@"=" withString:@"|"];
        n = (arc4random() % 8) + 1;
        time = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
        key = [[self md5:time] substringWithRange:NSMakeRange(0,n)];
        str = [NSString stringWithFormat:@"%d%@%@",n,str,key];
        return str;
    }
    return nil;
}
-(NSString *)csGTMBase64WithString:(NSString *)string{
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [CSGTMBase64 decodeData:data];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
- (NSString *)md5:(NSString *)str{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
@end
