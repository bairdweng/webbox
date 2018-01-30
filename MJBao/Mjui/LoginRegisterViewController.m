//
//  LoginRegisterViewController.m
//  MJBao
//
//  Created by Baird-weng on 2018/1/26.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "LoginRegisterViewController.h"
#import "CSColorManagement.h"
@interface LoginRegisterViewController ()

@end

@implementation LoginRegisterViewController





- (void)viewDidLoad {
//    [self test];
    
    
    
    
    
    NSString* dic = [[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"MJwebResoures.bundle"] stringByAppendingString:@"/dist"];
    dic = @"/Users/baird/Desktop/webbox/MJBao/MJwebResoures.bundle/dist";
    [self hx_loadLocalURL:[dic stringByAppendingString:@"/index.html"] withMainDicPath:dic withViewStyle:WebBoxViewControllerWk];
    self.showDocumentTitel = YES;
    self.showRefresh = YES;
  
    __weak typeof(self) weakSelf = self;
//    if([WebBoxViewController instancesRespondToSelector:NSSelectorFromString(@"view.alpha")]){
//        weakSelf.view.backgroundColor = [UIColor yellowColor];
//    }
//    [weakSelf setValue:@0.8 forKey:@"view.alpha"];
    [self hx_regisFunctions:@[ @"nativeLog", @"pushViewController", @"getMainColor" ]
               withCallBack:^(NSString* name, id data) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if ([name isEqualToString:@"pushViewController"]) {
                           WebBoxViewController *ViewController = [[WebBoxViewController alloc]init];
                           if([data isKindOfClass:[NSDictionary class]]){
                               NSString* URL = data[@"URL"];
                               NSString* dicPath = data[@"dicPath"];
                               if(URL){
                                   [ViewController hx_evaluateJavaScriptFuntionName:@"fuck" withParames:@{ @"fuck" : @"fuck" }];
                                   [ViewController hx_loadLocalURL:URL withMainDicPath:dicPath withViewStyle:WebBoxViewControllerWk];
                                   [weakSelf.navigationController pushViewController:ViewController animated:YES];
                               }
                           }
                       } else if ([name isEqualToString:@"getMainColor"]) {
                           [weakSelf hx_evaluateJavaScriptFuntionName:@"getMainColor"
                                                          withParames:@{ @"name" :[[CSColorManagement sharedHelper] hx_getMainColorStr]}];
                       }
                   });
               }];
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

