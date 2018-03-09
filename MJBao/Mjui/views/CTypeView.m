//
//  CTypeView.m
//  MJBao
//
//  Created by Baird-weng on 2018/2/8.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "CTypeView.h"

@implementation CTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}
-(void)initView{
    [self initUserNameTextField];
    [self initPassWordTextField];
    [self initLoginBtn];
    [self initRegiestBtn];
    [self initAgreementBtn];
}
-(void)initUserNameTextField{
    UITextField *textField = [UITextField new];
    [self addSubview:textField];
    UILabel *l_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    l_label.text = @"账户";
    l_label.textAlignment = 0;
    textField.leftView = l_label;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@44);
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(textField);
        make.height.equalTo(@0.5);
        make.top.equalTo(textField.mas_bottom).equalTo(@1);
    }];
    self.userNametextField = textField;
}
- (void)initPassWordTextField{
    UITextField *textField = [UITextField new];
    [self addSubview:textField];
    UILabel *l_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    l_label.text = @"密码";
    l_label.textAlignment = 0;
    textField.leftView = l_label;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.secureTextEntry = YES;
    [textField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.userNametextField.mas_bottom).equalTo(@10);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@44);
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(textField);
        make.height.equalTo(@0.5);
        make.top.equalTo(textField.mas_bottom).equalTo(@1);
    }];
    self.passWordtextField = textField;
}
-(void)initLoginBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [CSColorManagement sharedHelper].hx_getMainColor;
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.height.equalTo(@44);
        make.left.equalTo(@15);
        make.top.equalTo(self.passWordtextField.mas_bottom).equalTo(@20);
    }];
    btn.layer.cornerRadius = 5.0f;
    self.loginBtn = btn;
    [btn addTarget:self action:@selector(clickOntheLoginBtn) forControlEvents:UIControlEventTouchUpInside];
}
-(void)initRegiestBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitleColor:[CSColorManagement sharedHelper].hx_getMainColor forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.height.equalTo(@44);
        make.width.equalTo(@100);
        make.top.equalTo(self.loginBtn.mas_bottom).equalTo(@20);
    }];
    btn.layer.cornerRadius = 5.0f;
    [btn addTarget:self action:@selector(clickOntheRegiestBtn) forControlEvents:UIControlEventTouchUpInside];
    self.regiestBtn = btn;
}
- (void)initAgreementBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[CSColorManagement sharedHelper].hx_getMainColor forState:UIControlStateNormal];
    [btn setTitle:@"用户协议" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.height.equalTo(@44);
        make.width.equalTo(@100);
        make.centerY.equalTo(self.regiestBtn);
    }];
    btn.layer.cornerRadius = 5.0f;
    [btn addTarget:self action:@selector(clickOntheAgreementBtn) forControlEvents:UIControlEventTouchUpInside];
    self.agreementBtn = btn;
}

- (void)clickOntheLoginBtn{
    if(self.loginBlock){
        self.loginBlock(self.loginBtn);
    }
}
-(void)clickOntheRegiestBtn{
    if(self.regiestBlock){
        self.regiestBlock(self.regiestBtn);
    }
}
-(void)clickOntheAgreementBtn{
    if(self.agreementBlock){
        self.agreementBlock(self.agreementBtn);
    }
}
@end
