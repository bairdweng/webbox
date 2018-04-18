//
//  CSHttpRequest.m
//  CSGameSDK
//
//  Created by FreeGeek on 15/5/27.
//  Copyright (c) 2015年 xiezhongxi. All rights reserved.
//

#import "CSHttpRequest.h"
#import "CSAFNetworking.h"
@implementation CSHttpRequest

+(CSAFHTTPSessionManager *)shared
{
    static CSAFHTTPSessionManager * manager;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [CSAFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 15.0;   //网络超时时间
        manager.requestSerializer = [CSAFHTTPRequestSerializer serializer];
        manager.responseSerializer = [CSAFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:@"http://www.google.com" forHTTPHeaderField:@"Referer"];
    });
    return manager;
}


@end

