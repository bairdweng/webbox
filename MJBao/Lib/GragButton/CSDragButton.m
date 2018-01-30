//
//  GragButton.m
//  MoveButton
//
//  Created by FreeGeek on 15/5/28.
//  Copyright (c) 2015年 FreeGeek. All rights reserved.
//

#import "CSDragButton.h"
//#import "CSGameTabBarViewController.h"
#define CSisiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CSScreenWidth [UIScreen mainScreen].bounds.size.width
#define CSScreenHeight [UIScreen mainScreen].bounds.size.height
#define CSButtonAnimateDuration  0.1
#define CSShowViewAnimateDuration 0.1


#define CSButtonImageArray @[@"CSSYGameSDK.bundle/userblank.png",@"CSSYGameSDK.bundle/helpblank.png",@"CSSYGameSDK.bundle/gameblank.png"]
#define CSButtonTitleArray @[@"账号",@"帮助",@"隐藏"]
//ios7下 横屏以后坐标系问题的适配
#define DifferenceBetween  [[UIDevice currentDevice].systemVersion doubleValue] < 8.0 && [[UIScreen mainScreen] applicationFrame].size.height == [UIScreen mainScreen].bounds.size.height
#define CSios7 [[UIDevice currentDevice].systemVersion doubleValue] < 8.0
@interface CSDragButton ()
{
    float CSButtonSize;
    float CSDetailsButtonSize;
    float CSDetailsLabelHeight;
    float CSShowViewWidth;
    float CSShowViewHeight;
    float CSDetailsLabelSize;
    float CSDetailsInterval;
}
@end
static CSDragButton * DragBtn;
@implementation CSDragButton

-(instancetype)init
{
    if (CSisiPad)
    {
        CSButtonSize = 60;
        CSDetailsButtonSize = 43;
        CSDetailsLabelHeight = 20;
    }
    else
    {
        CSButtonSize = 40;
        CSDetailsButtonSize = 30;
        CSDetailsLabelHeight = 10;
    }
    CSShowViewWidth = 4 * CSButtonSize;
    CSShowViewHeight = CSButtonSize;
    CSDetailsLabelSize = CSButtonSize;
    CSDetailsInterval = (CSShowViewWidth - 3 * CSDetailsButtonSize) / 4.0;
//    if (DifferenceBetween)//
//    {
//        self = [super initWithFrame:CGRectMake((DifferenceBetween?CSScreenWidth:CSScreenHeight) / 2 - CSButtonSize / 2,0, CSButtonSize, CSButtonSize)];//
//        self.transform = CGAffineTransformMakeRotation(M_PI_2);//
//    }
//    else
//    {
        self = [super initWithFrame:CGRectMake(0,(DifferenceBetween?CSScreenWidth:CSScreenHeight) / 2 - CSButtonSize / 2, CSButtonSize, CSButtonSize)];
//    }
    
    if (self)
    {
        
    }
    [self setImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/dragbutton.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/dragbutton.png"] forState:UIControlStateHighlighted];
  
    self.layer.cornerRadius = CSButtonSize / 2;
    self.layer.masksToBounds = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchButton)];
    [self addGestureRecognizer:tap];
    
//    id appDelegate = [[UIApplication sharedApplication] delegate];
//    if ([appDelegate respondsToSelector:@selector(window)]) {
//        UIWindow * window = (UIWindow *) [appDelegate performSelector:@selector(window)];
//        [window addSubview:self];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WithFrame:) name:UIDeviceOrientationDidChangeNotification object:nil];
    return self;
}

+(CSDragButton *)defaultFloatViewWithButton
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        DragBtn = [[CSDragButton alloc]init];
    });
    [[UIApplication sharedApplication].keyWindow addSubview:DragBtn];
    return DragBtn;
}


-(void)WithFrame:(CGRect)frame
{
    if ([view window])
    {
        [view removeFromSuperview];
    }
    self.frame = CGRectMake(0,(DifferenceBetween?CSScreenWidth:CSScreenHeight) / 2 - CSButtonSize / 2, CSButtonSize, CSButtonSize);
}

-(void)TouchButton
{
    
    
    //视图存在删除视图
    if (view.bounds.size.width > 0)
    {
        for (UIView * views in view.subviews)
        {
            views.hidden = YES;
        }
        [UIView animateWithDuration:CSShowViewAnimateDuration animations:^{
            if (DifferenceBetween)
            {
                if (self.frame.origin.x < CSScreenHeight / 2)
                {
                    view.frame = CGRectMake(self.frame.origin.x + CSButtonSize,  self.frame.origin.y,0,CSShowViewHeight);
                }
                else
                {
                    view.frame = CGRectMake(CSScreenHeight - CSButtonSize, self.frame.origin.y , 0, CSShowViewHeight);
                }
            }
            else
            {
                if (self.frame.origin.x < CSScreenWidth / 2)
                {
                    view.frame = CGRectMake(self.frame.origin.x + CSButtonSize,  self.frame.origin.y,0,CSShowViewHeight);
                }
                else
                {
                    view.frame = CGRectMake(CSScreenWidth - CSButtonSize, self.frame.origin.y, 0, CSShowViewHeight);
                }
            }
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    else  //视图不存在创建视图
    {
        view = [[UIImageView alloc]init];
        view.image = [UIImage imageNamed:@"CSSYGameSDK.bundle/floatView.png"];
        if (self.center.x > CSScreenWidth / 2)
        {
            view.transform = CGAffineTransformMakeRotation(M_PI);
        }
        //add button
        for (int i = 0; i < CSButtonImageArray.count; i++)
        {
            UIButton * Detailsbtn = [[UIButton alloc]init];
            if (self.center.x > CSScreenWidth / 2)
            {
                Detailsbtn.frame = CGRectMake(5 + CSDetailsInterval * (i +1) + CSDetailsButtonSize * i,15, CSDetailsButtonSize, CSDetailsButtonSize);
            }
            else
            {
                Detailsbtn.frame = CGRectMake(5 + CSDetailsInterval * (i +1) + CSDetailsButtonSize * i, 0, CSDetailsButtonSize, CSDetailsButtonSize);
            }
            [Detailsbtn setImage:[UIImage imageNamed:[CSButtonImageArray objectAtIndex:i]] forState:UIControlStateNormal];
            if (self.center.x > CSScreenWidth / 2)
            {
                Detailsbtn.transform = CGAffineTransformMakeRotation(M_PI);
            }
            Detailsbtn.tag = i;
            [Detailsbtn addTarget:self action:@selector(DetailsbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:Detailsbtn];
        }
        //add label
        for (int i = 0; i < CSButtonTitleArray.count; i++)
        {
            UILabel * Detailslabel = [[UILabel alloc]init];
            if (self.center.x > CSScreenWidth / 2)
            {
                Detailslabel.frame = CGRectMake(5 + CSDetailsInterval * (i +1) + CSDetailsButtonSize * i, CSisiPad?0:3, CSDetailsButtonSize, CSDetailsLabelHeight);
            }
            else
            {
                Detailslabel.frame = CGRectMake(5+ CSDetailsInterval * (i +1) + CSDetailsButtonSize * i,CSisiPad?38:28, CSDetailsButtonSize, CSDetailsLabelHeight);
            }
            Detailslabel.font = [UIFont boldSystemFontOfSize:CSisiPad?14:9];
            Detailslabel.textAlignment = NSTextAlignmentCenter;
            Detailslabel.textColor = [UIColor whiteColor];
            Detailslabel.text = [CSButtonTitleArray objectAtIndex:i];
            if (self.center.x > CSScreenWidth / 2)
            {
                Detailslabel.transform = CGAffineTransformMakeRotation(M_PI);
            }
            [view addSubview:Detailslabel];
        }
        for (UIView * views in view.subviews)
        {
            views.hidden = YES;
        }
        if (DifferenceBetween)
        {
            if (self.frame.origin.x<CSScreenHeight / 2)
            {
                [UIView animateWithDuration:CSButtonAnimateDuration animations:^{
                    self.frame = CGRectMake(0, self.frame.origin.y, CSButtonSize, CSButtonSize);
                } completion:^(BOOL finished) {
                    
                }];
            }
            else
            {
                [UIView animateWithDuration:CSButtonAnimateDuration animations:^{
                    self.frame = CGRectMake(CSScreenHeight - CSButtonSize, self.frame.origin.y, CSButtonSize, CSButtonSize);
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            if (self.frame.origin.x < CSScreenHeight / 2)
            {
                view.frame = CGRectMake(self.frame.origin.x + CSButtonSize, self.frame.origin.y,0,CSShowViewHeight);
            }
            else
            {
                view.frame = CGRectMake(CSScreenHeight - CSButtonSize, self.frame.origin.y,0,CSShowViewHeight);
            }
        }
        else
        {
            if (self.frame.origin.x<CSScreenWidth / 2)
            {
                [UIView animateWithDuration:CSButtonAnimateDuration animations:^{
                    self.frame = CGRectMake(0, self.frame.origin.y, CSButtonSize, CSButtonSize);
                } completion:^(BOOL finished) {
                    
                }];
            }
            else
            {
                [UIView animateWithDuration:CSButtonAnimateDuration animations:^{
                    self.frame = CGRectMake(CSScreenWidth - CSButtonSize, self.frame.origin.y, CSButtonSize, CSButtonSize);
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            if (self.frame.origin.x < CSScreenWidth / 2)
            {
                view.frame = CGRectMake(self.frame.origin.x + CSButtonSize, self.frame.origin.y,0,CSShowViewHeight);
            }
            else
            {
                view.frame = CGRectMake(CSScreenWidth - CSButtonSize, self.frame.origin.y,0,CSShowViewHeight);
            }
        }
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewTapAction:)];
        [view addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [UIView animateWithDuration:CSShowViewAnimateDuration animations:^{
            
            if (DifferenceBetween)
            {
                if (view.frame.origin.x < CSScreenHeight / 2)
                {
                    view.frame = CGRectMake(self.frame.origin.x + CSButtonSize, self.frame.origin.y, CSShowViewWidth, CSShowViewHeight);
                }
                else
                {
                    view.frame = CGRectMake(CSScreenHeight - CSButtonSize - CSShowViewWidth,  self.frame.origin.y, CSShowViewWidth, CSShowViewHeight);
                }
            }
            else
            {
                if (view.frame.origin.x < CSScreenWidth / 2)
                {
                    view.frame = CGRectMake(self.frame.origin.x + CSButtonSize,  self.frame.origin.y, CSShowViewWidth, CSShowViewHeight);
                }
                else
                {
                    view.frame = CGRectMake(CSScreenWidth - CSButtonSize - CSShowViewWidth,  self.frame.origin.y, CSShowViewWidth, CSShowViewHeight);
                }
            }
            
        } completion:^(BOOL finished)
        {
            for (UIView * views in view.subviews)
            {
                views.hidden = NO;
            }
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //视图存在删除视图
            if (view.bounds.size.width > 0)
            {
                for (UIView * views in view.subviews)
                {
                    views.hidden = YES;
                }
                [UIView animateWithDuration:CSShowViewAnimateDuration animations:^{
                    if (DifferenceBetween)
                    {
                        if (self.frame.origin.x < CSScreenHeight / 2)
                        {
                            view.frame = CGRectMake(self.frame.origin.x + CSButtonSize,  self.frame.origin.y,0,CSShowViewHeight);
                        }
                        else
                        {
                            view.frame = CGRectMake(CSScreenHeight - CSButtonSize, self.frame.origin.y , 0, CSShowViewHeight);
                        }
                    }
                    else
                    {
                        if (self.frame.origin.x < CSScreenWidth / 2)
                        {
                            view.frame = CGRectMake(self.frame.origin.x + CSButtonSize,  self.frame.origin.y,0,CSShowViewHeight);
                        }
                        else
                        {
                            view.frame = CGRectMake(CSScreenWidth - CSButtonSize, self.frame.origin.y, 0, CSShowViewHeight);
                        }
                    }
                } completion:^(BOOL finished) {
                    [view removeFromSuperview];
                }];
            }
        });
    }
}

-(void)DetailsbuttonAction:(id)sender
{
//    if ([view window])
//    {
//        [view removeFromSuperview];
//    }
//    UIButton * btn = (UIButton *)sender;
//
//    CSGameTabBarViewController * tabbarVC = [[CSGameTabBarViewController alloc]init];
//    tabbarVC.selectedIndex = btn.tag;
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:tabbarVC animated:YES completion:^{
//        
//    }];

}

-(void)ViewTapAction:(id)sender
{
    //获取当前控件的ViewController对象
//    for (UIView * next = [self superview]; next; next = next.superview)
//    {
//        UIResponder * nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]])
//        {
//            [(UIViewController *)nextResponder presentViewController:[CSGameTabBarController new] animated:YES completion:^{
            
//            }];
//        }
//    }
    
//    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = appRootVC;
//    while (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//        [appRootVC presentViewController:[CSGameTabBarController new] animated:YES completion:nil];
//    }
    
    
    [view removeFromSuperview];
//    id appDelegate = [[UIApplication sharedApplication] delegate];
//    if ([appDelegate respondsToSelector:@selector(window)]) {
//        UIWindow * window = (UIWindow *) [appDelegate performSelector:@selector(window)];
//        [window.rootViewController presentViewController:[CSGameTabBarController new] animated:YES completion:nil];
//    }

    
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //当视图存在,那么移除视图
    if ([view window])
    {
        [view removeFromSuperview];
    }

    //计算位移=当前位置-起始位置
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - startPoint.x;
    float dy = point.y - startPoint.y;
    
    //计算移动后的view中心点
    newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    /* 限制用户不可将视图托出屏幕 */
    float halfx = CGRectGetMidX(self.bounds);
    //x坐标左边界
    newcenter.x = MAX(halfx, newcenter.x);
    //x坐标右边界
    newcenter.x = MIN(self.superview.bounds.size.width + halfx, newcenter.x);
    
    //y坐标同理
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height + halfy, newcenter.y);
    
    self.center = CGPointMake(newcenter.x - 25, newcenter.y - 25);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (DifferenceBetween) //ios7横屏
    {
        if (self.frame.origin.x < CSScreenHeight / 2)
        {
            [UIView animateWithDuration:CSButtonAnimateDuration animations:^{
                self.frame = CGRectMake(0, self.frame.origin.y, CSButtonSize, CSButtonSize);
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [UIView animateWithDuration:CSButtonAnimateDuration animations:^{
            self.frame = CGRectMake(CSScreenHeight - CSButtonSize, self.frame.origin.y,CSButtonSize, CSButtonSize);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else
    {
        if (self.frame.origin.x < CSScreenWidth / 2)
        {
            [UIView animateWithDuration:CSButtonAnimateDuration animations:^{
                self.frame = CGRectMake(0, self.frame.origin.y, CSButtonSize, CSButtonSize);
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [UIView animateWithDuration:CSButtonAnimateDuration animations:^{
            self.frame = CGRectMake(CSScreenWidth - CSButtonSize, self.frame.origin.y,CSButtonSize, CSButtonSize);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

+(void)setDragButtonHidden:(BOOL)hidden
{
    DragBtn.hidden = hidden;
}

@end
