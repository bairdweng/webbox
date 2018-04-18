//
//  ViewController.m
//  MJBao
//
//  Created by Baird-weng on 2018/1/26.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "ViewController.h"
#import "WebBoxViewController.h"
#import "Header.h"
#import "LoginViewController.h"
#import "apiService.h"
#import "MJConfigModel.h"
#import "GameViewController.h"
#import "M13ProgressViewPie.h"
#import "ProgressController.h"
@interface ViewController ()

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[CSColorManagement sharedHelper] hx_setNavigationColorWithTarget:self withColor:[CSColorManagement sharedHelper].hx_getMainColor];
    [MJConfigModel shared].uiIndex = 6;
    __weak typeof(self)weakSelf = self;
    [[apiService shared] getGameInfoWithblock:^(id dic){
        if(dic){
            NSString* gameid = dic[@"ext1"];//游戏id
            NSString *url = dic[@"ext4"];//游戏链接
            NSString* ext2 = dic[@"ext2"];//是否使用wk
            NSString* appid = dic[@"ext5"];//appid
            NSString* thumb = dic[@"thumb"]; //环境0是过审，1是发布。
            ext2 = @"";
            url = @"http://wvw.9377.com/h5/game_login.php?gid=616&sid=1";
            thumb = @"0";
            [MJConfigModel shared].gameID = gameid;
            [MJConfigModel shared].loadURL = url;
            [MJConfigModel shared].appID = appid;
            [MJConfigModel shared].useWkWebView = [ext2 isEqualToString:@"wk"];
            if([thumb intValue]==1){
                [MJConfigModel shared].isPublish = YES;
                GameViewController *gameViewController = [[GameViewController alloc]init];
                UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:gameViewController];
                [weakSelf presentViewController:navigation animated:nil completion:nil];
            }
            else{
                [MJConfigModel shared].isPublish = false;
                LoginViewController *vc = [[LoginViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:NO];
            }
        }
    }];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
