//
//  MJConfigModel.h
//  MJBao
//
//  Created by Baird-weng on 2018/1/26.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJConfigModel : NSObject
+ (MJConfigModel*)shared;
@property (nonatomic,strong) MJConfigModel *iap;
@property (nonatomic, strong) NSString* loadURL; //加载的URL。
@property (nonatomic, strong) NSString* version;//版本号。
@property (nonatomic, strong) NSString* disPlayName;//应用名称。
@property (nonatomic, strong) NSString* build; //编译版本号。
@property (nonatomic, strong) NSString* bundleIdentifier; //包的id。
@property (nonatomic, strong) NSString* bundleName; //工程名称。
@property (nonatomic, strong) NSString* idfa; //idfa
@end
