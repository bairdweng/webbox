//
//  AgreementViewController.m
//  MJBao
//
//  Created by Baird-weng on 2018/2/24.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad {

    NSString* mainlocalURL = [[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"MJwebResoures.bundle"] stringByAppendingString:@"/dist"];
    //    - (void)hx_loadLocalURL:(NSString*)URL withMainDicPath:(NSString *)path withViewStyle:(WebBoxViewControllerStyle)style;
    [self hx_loadLocalURL:[mainlocalURL stringByAppendingString:@"/agreement.html"] withMainDicPath:mainlocalURL withViewStyle:WebBoxViewControllerWk];
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
