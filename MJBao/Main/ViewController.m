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
#import "LoginRegisterViewController.h"
@interface ViewController ()

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickOntheTap2)];
    [self.view addGestureRecognizer:tap];
    [[CSColorManagement sharedHelper] hx_setNavigationColorWithTarget:self withColor:[CSColorManagement sharedHelper].hx_getMainColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LoginRegisterViewController *vc = [[LoginRegisterViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    });

    NSLog(@"===%@", [[self valueForKey:@"view"] valueForKey:@"frame"]);
    

    // Do any additional setup after loading the view, typically from a nib.
}
-(void)clickOntheTap2{
    LoginRegisterViewController *vc = [[LoginRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clickOntheTap{
    WebBoxViewController* viewController = [[WebBoxViewController alloc] init];
    [viewController hx_loadURL:@"https://wvw.9377.com/h5/login.php?gourl=http%3A%2F%2Fwvw.9377.com%2Fh5%2Fgame_login.php%3Fgid%3D397%26sid%3D1" withViewStyle:WebBoxViewControllerNormal];
    viewController.hiddenStateBar = YES;
    
//    viewController.dissShowProgressView = YES;
    viewController.hiddenNavigationBar = YES;
    viewController.showDocumentTitel = YES;
    __weak typeof(self) weakSelf = self;
    [viewController hx_regisFunctions:@[ @"PrtSc", @"get_start", @"iap", @"regToken", @"jumpCmt", @"clientCopy", @"winOpen", @"callPhone", @"callWeChat" ]
               withCallBack:^(NSString* name, id data) {
                   NSLog(@"fuctionName:%@\ndata:%@", name, data);
                   if ([name isEqualToString:@"get_start"]) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           WebBoxViewController* box = [[WebBoxViewController alloc] init];
                           box.showRefresh = YES;
                           box.title = @"充值";
                           box.interactivePopDisabled = YES;
                           if([data isKindOfClass:[NSDictionary class]]){
                               [box hx_loadURL:data[@"url"] withViewStyle:WebBoxViewControllerNormal];
                           }
                           else if([data isKindOfClass:[NSString class]]){
                               [box hx_loadURL:data withViewStyle:WebBoxViewControllerNormal];
                           }
                           [box hx_setJumpConfig:@[ @"weixin://", @"mqqapi://", @"itms-apps://", @"alipay://" ]
                                    withCallBack:^(NSString* name, id data) {
                                        NSLog(@"跳转======%@\n=======%@", name, data);
                                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:data]];
                                    }];
                           [weakSelf.navigationController pushViewController:box animated:YES];
                       });
                   }
               }];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
