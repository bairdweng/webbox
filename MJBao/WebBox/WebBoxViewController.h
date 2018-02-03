//
//  WebBoxViewController.h
//  MJBao
//
//  Created by Baird-weng on 2018/1/26.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
typedef NS_ENUM(NSInteger, WebBoxViewControllerStyle) {
    WebBoxViewControllerNormal = 0, //普通的webview
    WebBoxViewControllerWk //WkwebView
};
typedef void (^FinishBlock)(id webview);
typedef void (^FailLoadBlock)(id webview, NSError* error);
typedef void (^CallBackDataBlock)(NSString* name, id data);

@interface WebBoxViewController : UIViewController
@property (nonatomic, strong) UIColor* navigationColor; //导航颜色。
@property (nonatomic, assign) BOOL hiddenNavigationBar; //隐藏导航栏。
@property (nonatomic, assign) BOOL interactivePopDisabled;//禁止手势。
@property (nonatomic, assign) BOOL hiddenStateBar; //隐藏状态栏。
@property (nonatomic, assign) BOOL showDocumentTitle; //显示网页标题。
@property (nonatomic, assign) BOOL dissScrollViewbounces; //禁止跳动。
@property (nonatomic, assign) BOOL dissShowProgressView; //禁止显示进度条。
@property (nonatomic, assign) BOOL showRefresh; //显示右边刷新按钮。
@property(assign)BOOL *fuck;
/**
 加载链接
 @param URL URL
 @param style wkwebview
 */
- (void)hx_loadURL:(NSString*)URL withViewStyle:(WebBoxViewControllerStyle)style;

/**
 加载本地资源

 @param URL 本地链接
 @param path 本地资源的根目录。
 @param style 类型
 */
- (void)hx_loadLocalURL:(NSString*)URL withMainDicPath:(NSString *)path withViewStyle:(WebBoxViewControllerStyle)style;

/**
 加载完毕

 @param block webview
 */
- (void)hx_finishLoad:(FinishBlock)block;

/**
 加载异常

 @param block error
 */
- (void)hx_failLoad:(FailLoadBlock)block;

/**
 截取URL跳转。
 @param array 规则。weixin://
 */
- (void)hx_setJumpConfig:(NSArray*)array withCallBack:(CallBackDataBlock)block;

/**
 @param array 函数集合。
 @param block 参数。
 */
- (void)hx_regisFunctions:(NSArray*)array withCallBack:(CallBackDataBlock)block;

/**
 传递参数
 @param name 函数名称。
 @param dic 参数。
 */
-(void)hx_evaluateJavaScriptFuntionName:(NSString *)name withParames:(NSDictionary *)dic;
@end

