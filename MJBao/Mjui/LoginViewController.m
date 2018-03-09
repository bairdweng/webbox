//
//  LoginRegisterViewController.m
//  MJBao
//
//  Created by Baird-weng on 2018/1/26.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "LoginViewController.h"
#import "CSColorManagement.h"
#import "BaseTypeView.h"
#import "RegiestViewController.h"
#import "AgreementViewController.h"
#import "Header.h"
#import "GameViewController.h"
@interface LoginViewController ()
@property (nonatomic, weak) BaseTypeView* typeView;
@end
@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString* userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString* passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"];
    if(userName&&passWord){
        self.typeView.userNametextField.text = userName;
        self.typeView.passWordtextField.text = passWord;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    BaseTypeView* typeView = [[BaseTypeView alloc] initViewWithType:[MJConfigModel shared].uiIndex Withmodule:MJModuleTypeLogin];
    [self.view addSubview:typeView];
    [typeView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
    self.typeView = typeView;
    __weak typeof(self) weakSelf = self;
    __weak typeof (typeView) weaktypeView = typeView;
    [typeView setLoginBlock:^(UIButton* button) {
        if (weaktypeView.userNametextField.text.length==0) {
            [BWSVProgressHUD showErrorWithStatus:@"请输入您的用户名"];
        } else if (weaktypeView.userNametextField.text.length < 6) {
            [BWSVProgressHUD showErrorWithStatus:@"请输入6位数以上的密码"];
        }
        else{
            [[apiService shared] loginWithUserName:weaktypeView.userNametextField.text
                                      withPassWord:weaktypeView.passWordtextField.text
                                         withblock:^(id dic) {
                                             if([dic objectForKey:@"status"]){
                                                 NSInteger status = [[dic objectForKey:@"status"]intValue];
                                                 NSString* msg = [dic objectForKey:@"msg"];
                                                 if(status==0){
                                                     [[NSUserDefaults standardUserDefaults] setObject:weaktypeView.userNametextField.text forKey:@"userName"];
                                                     [[NSUserDefaults standardUserDefaults] setObject:weaktypeView.passWordtextField.text forKey:@"passWord"];
                                                     [BWSVProgressHUD showSuccessWithStatus:@"登录成功"];
                                                     GameViewController *gameViewControler = [[GameViewController alloc]init];
                                                     [weakSelf presentViewController:gameViewControler animated:NO completion:nil];
                                                 }
                                                 else{
                                                     [BWSVProgressHUD showErrorWithStatus:msg];
                                                 }
                                             }
                                         }];
        }
    }];
    [typeView setRegiestBlock:^(UIButton* button){
        RegiestViewController *regiestViewController = [[RegiestViewController alloc]init];
        [weakSelf.navigationController pushViewController:regiestViewController animated:YES];
    }];
    [typeView setAgreementBlock:^(UIButton* button){
        AgreementViewController *agreeViewController = [[AgreementViewController alloc]init];
        [weakSelf.navigationController pushViewController:agreeViewController animated:YES];
    }];
    UIButton *temBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:temBtn];
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

