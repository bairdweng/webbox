//
//  ProgressController.h
//  MJBao
//
//  Created by Baird-weng on 2018/3/13.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ProgressController : NSObject
+ (ProgressController*)shared;
- (void)initController:(UIViewController*)controller;
-(void)startTheAnimation;
@end
