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
#import "MJUrlModel.h"
#import "CSIAPManager.h"
#import "CSSVProgressHUD.h"
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
- (void)getiapConfig:(requestCallBack)block{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"filter_data" forKey:@"do"];
    [dict setObject:@"IOS启动统计H" forKey:@"name"];
    [dict setObject:@"hbstat" forKey:@"postfix"];
    [dict setObject:[MJConfigModel shared].disPlayName forKey:@"map[title]"];
    [[CSHttpRequest shared] GET:[MJUrlModel shared].gameInfoURL
        parameters:dict
        progress:nil
        success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
            id result = [self dealResponseObject:responseObject];
            if ([result isKindOfClass:[NSArray class]] && [result count] > 0) {
                NSDictionary* dict = [result objectAtIndex:0];
                BOOL status = [[dict objectForKey:@"url"] isEqualToString:@"sesame"];
                NSString *ext1str = [dict objectForKey:@"ext1"];
                float ext2 = [[dict objectForKey:@"ext2"] floatValue];
                int money = [ext1str intValue];
                if (status && [MJConfigModel shared].UserMoney - money >= 0 && [self datePwithTime:ext2]) {
                    block(@YES); //h
                } else {
                    block(nil); //iap
                }
            }
            else{
                block(nil);
            }
        }
        failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
            block(nil);
        }];
}
-(BOOL)datePwithTime:(float)time{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowTime = [NSDate new];
    NSDate *regisTime = [df1 dateFromString:[MJConfigModel shared].RegisDate];
    NSDate *vardate = [NSDate dateWithTimeInterval:time sinceDate:regisTime];
    if([vardate isEqualToDate:[vardate earlierDate:nowTime]]){
        return YES;
    }
    return NO;
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
    [self hx_accountlive];
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
-(void)hx_accountlive{
    if (![self hx_IsActivation]) {
        NSMutableDictionary* dic = [[MJConfigModel shared] publicData];
        [dic setObject:@"device_data" forKey:@"do"];
        [[CSHttpRequest shared] GET:[MJUrlModel shared].statisticalURL
                          parameters:dic
                            progress:nil
                             success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                                 NSDictionary* resultDict = [self dealResponseObject:responseObject];
                                 if([resultDict isKindOfClass:[NSDictionary class]]){
                                     if ([[resultDict objectForKey:@"ret"] intValue] == 0) {
                                         [self hx_Activation];
                                     }
                                 }
                             }
                             failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error){
                             }];
    }
}
-(BOOL)hx_IsActivation{
    NSString *key = @"Activation";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:key] boolValue];
}
-(void)hx_Activation{
    NSString *key = @"Activation";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:key];
    [userDefaults synchronize];
}
//内购
- (void)inPurchasingWithProductId:(NSString*)productId withExtraInfo:(NSString*)extraInfo withBlock:(requestCallBack)block{
    __weak typeof(self) weakSelf = self;
    [[CSIAPManager sharedIAPManager] getProductsForIds:@[]
        completion:^(NSArray* products) {
            BOOL hasProducts = [products count] != 0;
            if(! hasProducts){
                block(@{@"error":@"未找到对应商品"});
            }
            else{
                SKProduct* product = products[0];
                if (product){
                    [[CSIAPManager sharedIAPManager] purchaseProduct:product
                        completion:^(SKPaymentTransaction* transaction) {
                            NSMutableDictionary* dic = [[MJConfigModel shared] IAPDict:product withSKPaymentTransaction:transaction];
                            [[MJConfigModel shared] saveIAP:dic];
                            [[CSHttpRequest shared] POST:@"http://wvw.9377.com/h5/api/iap.php"
                                parameters:dic
                                progress:nil
                                success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                                    block(responseObject);
                                }
                                failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                                    block(@{ @"error" : error.localizedDescription });
                                }];
                        }
                        error:^(NSError* error) {
                            block(@{ @"error" : error.localizedDescription });
                        }];
                }
            }
        }
        error:^(NSError* error) {
            [CSSVProgressHUD hx_showErrorWithStatus:error.localizedDescription];
        }];
}
@end

