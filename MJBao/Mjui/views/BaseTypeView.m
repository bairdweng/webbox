//
//  BaseTypeView.m
//  MJBao
//
//  Created by Baird-weng on 2018/2/8.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "BaseTypeView.h"
#import "ATypeView.h"
#import "BTypeView.h"
#import "CTypeView.h"
#import "DTypeView.h"
#import "ETypeView.h"
#import "FTypeView.h"
#import "GTypeView.h"
@interface BaseTypeView()
@property (nonatomic, assign) MJModuleType moduleType;
@end
@implementation BaseTypeView
- (BaseTypeView*)initViewWithType:(NSInteger)index Withmodule:(MJModuleType)type
{
    self.moduleType = type;
    switch (index) {
        case 0:
            return [[ATypeView alloc] init];
            break;
        case 1:
            return [[BTypeView alloc] init];
            break;
        case 2:
            return [[CTypeView alloc] init];
            break;
        case 3:
            return [[DTypeView alloc] init];
            break;
        case 4:
            return [[ETypeView alloc] init];
            break;
        case 5:
            return [[FTypeView alloc] init];
            break;
        case 6:
            return [[GTypeView alloc] init];
            break;
        default:
            return [[ATypeView alloc] init];
            break;
        }
}
@end

