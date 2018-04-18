//
//  CSSVProgressHUD.h
//  CSGameMb
//
//  Created by Baird-weng on 2017/10/10.
//  Copyright © 2017年 Baird-weng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CSSVProgressHUD : NSObject
+ (void)hx_showWithStatus:(nullable NSString*)status;
+ (void)hx_showSuccessWithStatus:(nullable NSString*)status;
+ (void)hx_showErrorWithStatus:(nullable NSString*)status;
+ (void)hx_dismiss;
@end
