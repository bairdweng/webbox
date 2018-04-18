//
//  RegiestViewController.m
//  MJBao
//
//  Created by Baird-weng on 2018/2/24.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "RegiestViewController.h"
#import "CSColorManagement.h"
#import "BaseTypeView.h"
#import "GameViewController.h"
@interface RegiestViewController ()

@end

@implementation RegiestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    BaseTypeView* typeView = [[BaseTypeView alloc] initViewWithType:[MJConfigModel shared].uiIndex Withmodule:MJModuleTypeLogin];
    [self.view addSubview:typeView];
    [typeView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
    __weak typeof(self) weakSelf = self;
    __weak typeof(typeView) weaktypeView = typeView;
    [typeView setLoginBlock:^(UIButton* button){
        if (weaktypeView.userNametextField.text.length==0) {
            [CSSVProgressHUD hx_showErrorWithStatus:@"请输入您的用户名"];
        } else if (weaktypeView.userNametextField.text.length < 6) {
            [CSSVProgressHUD hx_showErrorWithStatus:@"请输入6位数以上的密码"];
        }
        else{
            [CSSVProgressHUD hx_showWithStatus:@"正在注册"];
            [[apiService shared] regiesterWithUserName:weaktypeView.userNametextField.text
                                          withPassWord:weaktypeView.passWordtextField.text
                                             withblock:^(id dic) {
                                                 if ([dic objectForKey:@"status"] && [[dic objectForKey:@"status"] intValue] == 0) {
                                                     [[NSUserDefaults standardUserDefaults] setObject:weaktypeView.userNametextField.text forKey:@"userName"];
                                                     [[NSUserDefaults standardUserDefaults] setObject:weaktypeView.passWordtextField.text forKey:@"passWord"];
                                                     [CSSVProgressHUD hx_showSuccessWithStatus:@"登录成功"];
                                                     GameViewController* gameViewControler = [[GameViewController alloc] init];
                                                     [weakSelf presentViewController:gameViewControler animated:NO completion:nil];
                                                 }
                                                 else{
                                                     NSString* msg = [dic objectForKey:@"msg"];
                                                     [CSSVProgressHUD hx_showErrorWithStatus:msg];
                                                 }
                                             }];
        }
    }];
    [typeView.loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    typeView.regiestBtn.hidden = YES;
    typeView.agreementBtn.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

