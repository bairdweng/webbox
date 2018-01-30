//
//  CSColorManagement.m
//  CSGameLib
//
//  Created by  on 2017/9/23.
//  Copyright © 2017年 . All rights reserved.
//

#import "CSColorManagement.h"
#import "UIColor+Hex.h"
#import "Header.h"
@implementation CSColorManagement
+ (CSColorManagement *) sharedHelper {
    static CSColorManagement * _sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[CSColorManagement alloc] init];
        _sharedHelper.iap = nil;
    });
    return _sharedHelper;
}
-(UIColor *)hx_getMainColor{
    return [self hx_getColor];
}
- (NSString*)hx_getMainColorStr{
    NSArray* colors = @[
        @"001f3f",
        @"0074D9",
        @"7FDBFF",
        @"39CCCC",
        @"3D9970",
        @"F012BE",
        @"FF4136",
        @"FF851B",
        @"01FF70",
        @"1565c0",
        @"4caf50",
        @"f57f17",
        @"aeea00",
        @"00bfa5",
        @"3e2723",
        @"F7971E",
        @"E44D26",
        @"F7971E",
        @"6190E8",
        @"34e89e",
        @"F7971E",
        @"1cefff"
    ];
    int index = 0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:GSMAINCOLORINDEX]){
        int GSmainColorInxdex = [[userDefaults objectForKey:GSMAINCOLORINDEX] intValue];
        if(GSmainColorInxdex<colors.count){
            index = GSmainColorInxdex;
        } else {
            index = arc4random() % (colors.count-1);
            [userDefaults setObject:[NSNumber numberWithInt:index] forKey:GSMAINCOLORINDEX];
        }
    }
    else{
        index = arc4random() % (colors.count-1);
        [userDefaults setObject:[NSNumber numberWithInt:index] forKey:GSMAINCOLORINDEX];
    }
    return colors[index];
}
-(UIColor *)hx_getColor{
    return [UIColor colorWithHexString:[self hx_getMainColorStr]];
}
- (void)hx_setNavigationColorWithTarget:(id)target withColor:(UIColor *)color{
    if ([target isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)target;
        UIImage *Navimage = [self imageWithColor:color size:CGSizeMake(vc.view.frame.size.width, 48)];
        [vc.navigationController.navigationBar setBackgroundImage:Navimage forBarMetrics:UIBarMetricsDefault];
        [vc.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [vc.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        vc.navigationController.navigationBar.translucent = NO;
    }
}
//绘制单色的图片
-(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
}
@end
