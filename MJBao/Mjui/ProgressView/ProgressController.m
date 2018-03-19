//
//  ProgressController.m
//  MJBao
//
//  Created by Baird-weng on 2018/3/13.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "ProgressController.h"
#import "Header.h"
#import "CSGameProgressView.h"

@interface ProgressController (){
    CSGameProgressView* _proGressView;
    CGFloat _progressValue;
    NSTimer* _timer;
}
@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, assign) BOOL isLoad;

@end

@implementation ProgressController
+ (ProgressController *) shared {
    static ProgressController * _sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[ProgressController alloc] init];
    });
    return _sharedHelper;
}
-(void)initController:(UIViewController *)controller{
    self.backgroundImageView = [UIImageView new];
    [controller.view addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(controller.view);
    }];
    self.backgroundImageView.image = [UIImage imageNamed:[MJConfigModel shared].launchImageName];
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    [self.backgroundImageView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(controller.view);
    }];
    _proGressView = [[CSGameProgressView alloc] initCSGameViewTypeWithIndex:0];
    [self.backgroundImageView addSubview:_proGressView];
    [_proGressView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.backgroundImageView);
    }];
    //设置超时时间,超过30s。
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGGAMELOADTIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf startTheAnimation];
    });
}
- (void)startTheAnimation
{
    if(!self.isLoad){
        _progressValue = 0;
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showAnimation) userInfo:nil repeats:YES];
        [_timer fire];
        _isLoad = YES;
    }
}
-(void)showAnimation{
    _progressValue += 0.03;
    if(_progressValue<=1){
        [_proGressView hx_setProgress:_progressValue];
    }
    else{
        [_timer invalidate];
        [self.backgroundImageView removeFromSuperview];
    }
}
@end
