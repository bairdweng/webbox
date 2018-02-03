//
//  JSMeddleFunction.h
//  MJBao
//
//  Created by Baird-weng on 2018/1/29.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JSMiddleFunction : NSObject
+ (void)initWithTarget:(NSString*)className withParams:(NSDictionary*)params;

+ (void)initWithTarget:(NSString*)className withTarget:(id)target withParams:(NSDictionary*)params;
@end
