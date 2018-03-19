//
//  CSSVProgressHUD.m
//  CSGameMb
//
//  Created by Baird-weng on 2017/10/10.
//  Copyright © 2017年 Baird-weng. All rights reserved.
//

#import "CSSVProgressHUD.h"
#import "BWSVProgressHUD.h"
#import "CSColorManagement.h"
@implementation CSSVProgressHUD
+(void)initialize{
    [BWSVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [BWSVProgressHUD setBackgroundColor:[[CSColorManagement sharedHelper]hx_getMainColor]];
    [BWSVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [BWSVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
     BWSVProgressHUD.minimumDismissTimeInterval = 1.5;
}
+ (void)hx_showWithStatus:(nullable NSString*)status{
    [BWSVProgressHUD showWithStatus:status];
}
+ (void)hx_showSuccessWithStatus:(nullable NSString*)status{
    [BWSVProgressHUD showSuccessWithStatus:status];
}
+ (void)hx_showErrorWithStatus:(nullable NSString*)status{
    [BWSVProgressHUD showErrorWithStatus:status];
}
+(void)hx_dismiss{
    [BWSVProgressHUD dismiss];
}
@end
