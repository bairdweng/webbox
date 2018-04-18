//
//  apiService.h
//  bjsaiche
//
//  Created by Baird-weng on 2018/2/24.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface apiService : NSObject
typedef void (^requestCallBack)(id dic);
@property (nonatomic, strong) apiService* iap;
+ (apiService*)shared;
- (void)loginWithUserName:(NSString*)username withPassWord:(NSString*)password withblock:(requestCallBack)block;
- (void)regiesterWithUserName:(NSString*)username withPassWord:(NSString*)password withblock:(requestCallBack)block;
- (void)getGameInfoWithblock:(requestCallBack)block;
- (void)getiapConfig:(requestCallBack)block;
- (void)inPurchasingWithProductId:(NSString*)productId withExtraInfo:(NSString*)extraInfo withBlock:(requestCallBack)block;
@end
