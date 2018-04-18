//
//  BaseTypeView.h
//  MJBao
//
//  Created by Baird-weng on 2018/2/8.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
typedef NS_ENUM(NSInteger, MJModuleType) {
    MJModuleTypeLogin, //登录页面。
    MJModuleTypeRegiester//注册页面。
};
typedef void (^TypeViewBtnEvent)(UIButton* button);

@interface BaseTypeView : UIView
- (BaseTypeView*)initViewWithType:(NSInteger)index Withmodule:(MJModuleType)type;

@property (nonatomic, strong) UITextField* userNametextField;
@property (nonatomic, strong) UITextField* passWordtextField;
@property (nonatomic, strong) UIButton* loginBtn;
@property (nonatomic, strong) UIButton* regiestBtn;
@property (nonatomic, strong) UIButton* agreementBtn;

@property (nonatomic, strong) TypeViewBtnEvent loginBlock;
@property (nonatomic, strong) TypeViewBtnEvent regiestBlock;
@property (nonatomic, strong) TypeViewBtnEvent agreementBlock;

@end
