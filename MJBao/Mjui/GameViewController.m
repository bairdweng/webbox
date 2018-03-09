//
//  GameViewController.m
//  MJBao
//
//  Created by Baird-weng on 2018/2/27.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "GameViewController.h"
#import "MJConfigModel.h"
@interface GameViewController ()

@end

@implementation GameViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewDidLoad {
    self.dissScrollViewbounces = YES;
    if([MJConfigModel shared].useWkWebView){
        [self hx_loadURL:[MJConfigModel shared].loadURL withViewStyle:WebBoxViewControllerWk];
    }
    else{
        [self hx_loadURL:[MJConfigModel shared].loadURL withViewStyle:WebBoxViewControllerNormal];
    }
    [super viewDidLoad];
    
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
