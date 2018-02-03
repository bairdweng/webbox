//
//  JSMiddleFunction.m
//  MJBao
//
//  Created by Baird-weng on 2018/1/29.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "JSMiddleFunction.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation JSMiddleFunction
+ (void)initWithTarget:(NSString*)className withParams:(NSDictionary*)params
{
//    [JSMiddleFunction currentObject:target withIndex:0 withAllKeys:@[ @"view", @"backgroundColor" ]];
NSLog(@"params===%@", [self getclass_copyIvarList:@"WebBoxViewController"]);

return;
//id vc = target;
//for (NSString* key in params.allKeys) {
//    id setObject = nil;
//    NSString* value = params[key];
//    NSArray* keys = [key componentsSeparatedByString:@"."];
//
//    if (keys && keys.count > 0) {
//
//        NSLog(@"=============%@", [JSMiddleFunction currentObject:target withIndex:0 withAllKeys:keys]);
//        [self getclass_copyIvarList:@""];
//
//        //            for (int i = 0; i<keys.count; i++) {
//        //                id obj1 = [vc objectForKey:keys[i]];
//        //                id lastvc = obj1;
//        //            }
//    } else {
//    }
//    NSArray* values = [value componentsSeparatedByString:@"."];
//    for (NSString* value in values) {
//    }
//    }
    
//    NSArray *webatt= [self getclass_copyIvarList:@"WebBoxViewController"];
//    for (NSDictionary *dic in webatt) {
//        if([dic[@"name"] isEqualToString:@"_wkWebView"]){
//            NSLog(@"att=======%@",[self getclass_copyIvarList:@"WKWebView"]);
//        }
//    }
}

/**
 递归

 @param object 当前对象
 @param index 当前下标
 @param keys 所有的属性列表
 @return 返回值。
 */
+ (id)currentObject:(UIViewController *)object withIndex:(int)index withAllKeys:(NSArray*)keys
{
    
    
//    object = [self getclass_copyIvarList:@"LoginRegisterViewController"];
    NSLog(@"aa=========%@",[self viewControllerWithTarget:object]);
    return @{};
}
+ (UIViewController*)viewControllerWithTarget:(UIViewController*)target
{
    for (UIView* next = [target.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
+ (NSArray*)getclass_copyIvarList:(NSString*)className
{
    unsigned int count = 0;
    Ivar* allVariables = class_copyIvarList(NSClassFromString(className), &count);
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (int i = 0;i<count;i++) {
        Ivar ivar = allVariables[i];
        const char *variablename = ivar_getName(ivar); //获取成员变量名称
        const char* variableType = ivar_getTypeEncoding(ivar); //获取成员变量类型
        NSString *name = [NSString stringWithUTF8String:variablename];
        NSString *type = [NSString stringWithUTF8String:variableType];
        [array addObject:@{
            @"name" : name,
            @"type" : type
        }];
    }
    return array;
}
@end

