//
//  apiService.m
//  bjsaiche
//
//  Created by Baird-weng on 2018/2/24.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "apiService.h"
#define URL @"http://game.e9e66.com"
#import "CSHttpRequest.h"
#import "MJConfigModel.h"
@implementation apiService
+ (apiService*)shared{
    static apiService * _sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[apiService alloc] init];
        _sharedHelper.iap = nil;
    });
    return _sharedHelper;
}
- (void)loginWithUserName:(NSString*)username withPassWord:(NSString*)password withblock:(requestCallBack)block{
    NSString* loginURL = [NSString stringWithFormat:@"%@/%@", URL, @"login.php"];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"login" forKey:@"do"];
    [dict setObject:username forKey:@"username"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:@"1" forKey:@"login_save"];
    [dict setObject:@"1" forKey:@"return_json"];
    [[CSHttpRequest shared] POST:loginURL
        parameters:dict
        progress:nil
        success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
            block([self dealResponseObject:responseObject]);
        }
        failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
            block(nil);
        }];
}
- (void)regiesterWithUserName:(NSString*)username withPassWord:(NSString*)password withblock:(requestCallBack)block{
    NSString* signupURL = [NSString stringWithFormat:@"%@/%@", URL, @"register.php"];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"register" forKey:@"do"];
    [dict setObject:username forKey:@"LOGIN_ACCOUNT"];
    [dict setObject:password forKey:@"PASSWORD"];
    [dict setObject:password forKey:@"PASSWORD1"];
    [dict setObject:@"1" forKey:@"client"];
    [dict setObject:@"893D1EC9-795E-45E8-ABE9-685C969C8B41" forKey:@"device_imei"];
    [dict setObject:@"1" forKey:@"is_ajax"];
    [[CSHttpRequest shared] POST:signupURL
        parameters:dict
        progress:nil
        success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
            block([self dealResponseObject:responseObject]);
        }
        failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
            block(nil);
        }];
}
- (void)getGameInfoWithblock:(requestCallBack)block{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    NSString *version = [MJConfigModel shared].appVersion;
    [dict setObject:version forKey:@"map[ext6]"];
    [dict setObject:@"filter_data" forKey:@"do"];
    [dict setObject:@"游戏启动H" forKey:@"name"];
    [dict setObject:@"click" forKey:@"postfix"];
    [dict setObject:[MJConfigModel shared].disPlayName forKey:@"map[title]"];
    NSString* game_url = [NSString stringWithFormat:@"%@/%@", URL, @"api/hstat.php"];
    [[CSHttpRequest shared] POST:game_url
        parameters:dict
        progress:nil
        success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
            NSDictionary *r_dic = [self dealResponseObject:responseObject];
            NSMutableArray* array = (NSMutableArray*)r_dic;
            if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
                NSDictionary* dict = [array objectAtIndex:0];
                NSString* gameid = [dict objectForKey:@"ext1"];
                NSString* ext3 = dict[@"ext3"]; //渠道
                if (gameid.length > 0) {
                    [MJConfigModel shared].gameReferer = @"";
                    [MJConfigModel shared].gameID = gameid;
                    [MJConfigModel shared].serverType = 0;
                    if(ext3&&ext3.length>0){
                        [MJConfigModel shared].gameReferer = ext3;
                    }
                    else{
                        [MJConfigModel shared].gameReferer = @"";
                    }
                    [MJConfigModel shared].platForm = 1;
                    [self activationWithBlock:nil];
                }
                block(dict);
            }
            else{
                block(nil);
            }
        }
        failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
            block(nil);
        }];
}
//统计激活。
- (void)activationWithBlock:(requestCallBack)block{
    
}
-(id)dealResponseObject:(id)responseObject{
    if ([responseObject isKindOfClass:[NSArray class]] || [responseObject isKindOfClass:[NSDictionary class]]){
        return responseObject;
    } else {
        NSMutableDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if(dictionary){
            return dictionary;
        }
        else{
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            return str;
        }
    }
}
@end
