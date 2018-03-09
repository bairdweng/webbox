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
@property (nonatomic, strong) NSString* appVersion;//版本号。
@property (nonatomic, strong) NSString* disPlayName;//应用名称。
@property (nonatomic, strong) NSString* appBuild; //编译版本号。
@property (nonatomic, strong) NSString* bundleIdentifier; //包的id。
@property (nonatomic, strong) NSString* bundleName; //工程名称。
@property (nonatomic, strong) NSString* idfa; //idfa
@property (nonatomic, assign) NSInteger uiIndex; //UI版本
@property (nonatomic, strong) NSString* launchImageName; //启动图。

@property (nonatomic, strong) NSString* gameReferer;
@property (nonatomic, strong) NSString* gameID;
@property (nonatomic, strong) NSString* appID;
@property (nonatomic, assign) NSInteger serverType;
@property (nonatomic, assign) NSInteger platForm;
@property (nonatomic, assign) BOOL isPublish; //是否发布状态
@property (nonatomic, assign) BOOL useWkWebView;//是否使用wk


@end
