//
//  CSColorManagement.h
//  CSGameLib
//
//  Created by  on 2017/9/23.
//  Copyright © 2017年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CSColorManagement : NSObject
@property (nonatomic,strong) CSColorManagement *iap;
+ (CSColorManagement*)sharedHelper;
-(UIColor *)hx_getMainColor;
- (UIColor*)hx_getMainColorStr;
- (void)hx_setNavigationColorWithTarget:(id)target withColor:(UIColor*)color;
@end
