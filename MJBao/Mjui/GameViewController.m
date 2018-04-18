//
//  GameViewController.m
//  MJBao
//
//  Created by Baird-weng on 2018/2/27.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "GameViewController.h"
#import "MJConfigModel.h"
#import "ProgressController.h"
#import "Header.h"
@interface GameViewController (){
   
}
@property (nonatomic, strong) UIImageView* backgroundImageView;
@end

@implementation GameViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidLoad {
    self.dissScrollViewbounces = YES;
        self.hiddenNavigationBar = YES;
    if([MJConfigModel shared].useWkWebView){
        [self hx_loadURL:[MJConfigModel shared].loadURL withViewStyle:WebBoxViewControllerWk];
    }
    else{
        [self hx_loadURL:[MJConfigModel shared].loadURL withViewStyle:WebBoxViewControllerNormal];
    }
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    if ([MJConfigModel shared].isPublish) {
        [CSSVProgressHUD hx_showWithStatus:@"进入游戏中..."];
    }
    else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[ProgressController shared] initController:weakSelf];
        });
    }
    [self hx_finishLoad:^(id webview) {
        if([MJConfigModel shared].isPublish){
            [CSSVProgressHUD hx_dismiss];
        }
        else{
            [[ProgressController shared] startTheAnimation];
        }
    }];
    [self hx_regisFunctions:@[
        @"PrtSc",
        @"ios_pay",
        @"regToken",
        @"jumpCmt",
        @"clientCopy",
        @"winOpen",
        @"callPhone",
        @"callWeChat"]
               withCallBack:^(NSString* name, id data) {
                   if ([name isEqualToString:@"PrtSc"]) {
                       UIGraphicsBeginImageContext(weakSelf.view.bounds.size);//currentView 当前的view。
                       [weakSelf.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                       UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                       UIGraphicsEndImageContext();
                       UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
                   } else if ([name isEqualToString:@"ios_pay"]) {
                       NSString* URL = [data objectForKey:@"url"];
                       [[apiService shared] getiapConfig:^(id dic) {
                           if(dic){
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   WebBoxViewController* mb = [[WebBoxViewController alloc] init];
                                   [mb hx_loadURL:URL withViewStyle:WebBoxViewControllerNormal];
                                   [weakSelf.navigationController pushViewController:mb animated:YES];
                               });
                           }
                           else{
                               
                           }
                       }];
                       return ;
                       
                   }
                   else if ([name isEqualToString:@"regToken"]){
                       
                   }
                   else if ([name isEqualToString:@"jumpCmt"]){
                       
                   }
                   else if ([name isEqualToString:@"clientCopy"]){
                       
                   }
                   else if ([name isEqualToString:@"winOpen"]){
                       
                   }
                   else if ([name isEqualToString:@"callPhone"]){
                       
                   }
                   else if ([name isEqualToString:@"callWeChat"]){
                       
                   }
                   NSLog(@"name：%@  data：%@", name, data);
               }];
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
