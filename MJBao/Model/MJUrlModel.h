//
//  MJUrlModel.h
//  MJBao
//
//  Created by Baird-weng on 2018/1/26.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJUrlModel : NSObject
+ (MJUrlModel*)shared;
@property (nonatomic,strong) MJUrlModel *iap;
@property(nonatomic,strong)NSString *gameInfoURL;//游戏信息的URL。
@property(nonatomic,strong)NSString *loginURL;//游戏信息的URL。
@property(nonatomic,strong)NSString *registerURL;//游戏信息的URL。
@property (nonatomic, strong) NSString* statisticalURL; //统计.
@property (nonatomic, strong) NSString* sdkURL; //sdk
@end
