//
//  NSString+Helper.m
//  MJBao
//
//  Created by Baird-weng on 2018/1/29.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)
+(NSString *)jsonWithDic:(NSDictionary *)dic{
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return nil;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonStr;
}
@end
