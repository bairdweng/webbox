//
//  GTypeView.m
//  MJBao
//
//  Created by Baird-weng on 2018/2/8.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "GTypeView.h"

@implementation GTypeView

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
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [imageView setImage:[UIImage imageNamed:[MJConfigModel shared].launchImageName]];
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self);
    }];
    [self initUserNameTextField];
    [self initPassWordTextField];
    [self initLoginBtn];
    [self initRegiestBtn];
    [self initAgreementBtn];
}
-(void)initUserNameTextField{
    UITextField *textField = [UITextField new];
    [self addSubview:textField];
    textField.placeholder = @"请输入6位数或以上的账户名";
    textField.textColor = [UIColor whiteColor];
    textField.textAlignment = 1;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@44);
    }];
    textField.layer.cornerRadius = 22;
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = [[CSColorManagement sharedHelper].hx_getMainColor CGColor];
    self.userNametextField = textField;
}
- (void)initPassWordTextField{
    UITextField *textField = [UITextField new];
    [self addSubview:textField];
    textField.textColor = [UIColor whiteColor];
    textField.placeholder = @"请输入6位数或以上的密码";
    textField.textAlignment = 1;
    textField.secureTextEntry = YES;
    [textField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.userNametextField.mas_bottom).equalTo(@10);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@44);
    }];
    textField.layer.cornerRadius = 22;
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = [[CSColorManagement sharedHelper].hx_getMainColor CGColor];
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
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@44);
        make.top.equalTo(self.passWordtextField.mas_bottom).equalTo(@20);
    }];
    btn.layer.cornerRadius = 22;
    self.loginBtn = btn;
    [btn addTarget:self action:@selector(clickOntheLoginBtn) forControlEvents:UIControlEventTouchUpInside];
}
-(void)initRegiestBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [CSColorManagement sharedHelper].hx_getMainColor;
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@44);
        make.top.equalTo(self.loginBtn.mas_bottom).equalTo(@20);
    }];
    btn.layer.cornerRadius = 22;
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
        make.bottom.equalTo(@(-15));
        make.height.equalTo(@44);
        make.width.equalTo(@100);
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
