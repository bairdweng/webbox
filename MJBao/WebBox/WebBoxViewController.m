//
//  WebBoxViewController.m
//  MJBao
//
//  Created by Baird-weng on 2018/1/26.
//  Copyright © 2018年 Baird-weng. All rights reserved.
//

#import "WebBoxViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Header.h"
#import "JSMiddleFunction.h"
@interface WebBoxViewController () <UIWebViewDelegate,
    NJKWebViewProgressDelegate,
    WKUIDelegate,
    WKScriptMessageHandler,
    WKNavigationDelegate> {
    FinishBlock _fBlock;
    FailLoadBlock _faBlock;
    CallBackDataBlock _callBackBlock;
    NSArray *_JumpConfig;
    NSArray *_functions;
    NJKTWebViewProgressView *_progressView;
    NJKSWesbViewProgress *_progressProxy;
    NSString *_localPathDic;
}
@property(nonatomic,strong)NSString *webURL;
@property(nonatomic,assign)WebBoxViewControllerStyle webStyle;
@property (strong, nonatomic) UIWebView* webview;
@property (strong, nonatomic) WKWebView* wkWebView;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) CallBackDataBlock fcallBackDataBlock;
@property (strong, nonatomic) UIProgressView *wkprogressView;
@end
@implementation WebBoxViewController
- (void)hx_regisFunctions:(NSArray*)array withCallBack:(CallBackDataBlock)block{
    _functions = array;
    self.fcallBackDataBlock = block;
}
- (void)hx_loadURL:(NSString*)URL withViewStyle:(WebBoxViewControllerStyle)style{
    self.webURL = URL;
    self.webStyle = style;
}
- (void)hx_loadLocalURL:(NSString*)URL withMainDicPath:(NSString *)path withViewStyle:(WebBoxViewControllerStyle)style{
    self.webURL = URL;
    self.webStyle = style;
    _localPathDic = path;
}
- (void)hx_finishLoad:(FinishBlock)block{
    _fBlock = block;
}
- (void)hx_failLoad:(FailLoadBlock)block
{
    _faBlock = block;
}
-(void)hx_setJumpConfig:(NSArray *)array withCallBack:(CallBackDataBlock)block{
    _JumpConfig = array;
    _callBackBlock = block;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = self.hiddenNavigationBar;
    self.fd_interactivePopDisabled = self.interactivePopDisabled;
    [[UIApplication sharedApplication] setStatusBarHidden:self.hiddenStateBar];
    [self initProgress];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self deallocProgress];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = self.hiddenNavigationBar;
    self.fd_interactivePopDisabled = self.interactivePopDisabled;
    if(self.webStyle == WebBoxViewControllerNormal){
        self.webview = [[UIWebView alloc]init];
        self.webview.scrollView.bounces=!self.dissScrollViewbounces;
        self.webview.delegate = self;
        [self.view addSubview:self.webview];
        [self.webview mas_makeConstraints:^(MASConstraintMaker* make) {
            make.edges.equalTo(self.view);
        }];
    }
    else if(self.webStyle == WebBoxViewControllerWk){
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        // 注入JS对象Native，
        [config.userContentController addScriptMessageHandler:self name:@"Native"];
        // 声明WKScriptMessageHandler 协议
        self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        self.wkWebView.scrollView.bounces = !self.dissScrollViewbounces;
        self.wkWebView.UIDelegate = self;
        self.wkWebView.navigationDelegate = self;
        [self.view addSubview:self.wkWebView];
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.edges.equalTo(self.view);
        }];
    }
    else{
        NSLog(@"webStyle类型错误");
    }
    [self initURL];
    [self initProgress];
    if (self.showRefresh) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(initURL)];
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    //    self.view.backgroundColor = [UIColor redColor]
    // Do any additional setup after loading the view.
}
-(void)initProgress{
    if(!self.dissShowProgressView){
        if(self.wkWebView){
            [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
            if(!self.wkprogressView){
                UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
                progressView.tintColor = [CSColorManagement sharedHelper].hx_getMainColor;
                progressView.trackTintColor = [UIColor whiteColor];
                [self.view addSubview:progressView];
                self.wkprogressView = progressView;
            }
        }
        else if (self.webview){
            if(!_progressView){
                _progressProxy = [[NJKSWesbViewProgress alloc] init];
                self.webview.delegate = _progressProxy;
                _progressProxy.webViewProxyDelegate = self;
                _progressProxy.progressDelegate = self;
                _progressView = [[NJKTWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
                _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
                _progressView.progressBarView.backgroundColor = [CSColorManagement sharedHelper].hx_getMainColor;
                _progressView.TitinColor = [UIColor redColor];
                [self.view addSubview:_progressView];
                [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.equalTo(@0);
                    make.height.equalTo(@2);
                }];
            }
        }
    }
}
-(void)deallocProgress{
    if(!self.dissShowProgressView){
        if(self.wkWebView){
            [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
            [self.wkprogressView removeFromSuperview];
        }
        else if(self.webview){
            [_progressView removeFromSuperview];
        }
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"] && !self.dissShowProgressView) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.wkprogressView.hidden = YES;
            [self.wkprogressView setProgress:0 animated:NO];
        }else {
            self.wkprogressView.hidden = NO;
            [self.wkprogressView setProgress:newprogress animated:YES];
        }
    }
}
- (void)webViewProgress:(NJKSWesbViewProgress *)webViewProgress updateProgress:(float)progress{
    if(_progressView&&!self.dissShowProgressView){
        [_progressView setProgress:progress animated:YES];
    }
}
-(void)initURL{
    if(self.webview){
        NSURLRequest* urlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]];
        [self.webview loadRequest:urlrequest];
    }
    else if (self.wkWebView){
        if ([self.webURL rangeOfString:@"http://"].length > 0 || [self.webURL rangeOfString:@"https://"].length > 0) {
            NSURLRequest* urlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]];
            [self.wkWebView loadRequest:urlrequest];
        }
        else{
            NSString* htmlstr = [NSString stringWithContentsOfFile:self.webURL encoding:NSUTF8StringEncoding error:nil];
            if (htmlstr && _localPathDic) {
                [self.wkWebView loadHTMLString:htmlstr baseURL:[NSURL fileURLWithPath:_localPathDic]];
            }
        }
    }
    else{
        NSLog(@"webStyle类型错误");
    }
}
//处理跳转。
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = [NSString stringWithFormat:@"%@",request.URL];
    if (_callBackBlock) {
        BOOL isNext = YES;
        for (NSString* name in _JumpConfig) {
            if ([url rangeOfString:name].length > 0) {
                _callBackBlock(name,url);
                isNext = NO;
            }
        }
        return isNext;
    }
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if(_fBlock){
        _fBlock(webView);
    }
    if(self.fcallBackDataBlock){
        __weak typeof(self) weakSelf=  self;
        self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
        };
        self.context[@"native"] = self;
        for (NSString* function in _functions) {
            self.context[function] = ^(id data) {
                weakSelf.fcallBackDataBlock(function, data);
            };
        }
    }
    if(self.showDocumentTitel||self.title.length==0){
        self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }

}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(_faBlock){
        _faBlock(webView, error);
    }
    [self deallocProgress];

}
/* --------------------------------wk-------------------------------------*/
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction* action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController
                       animated:YES
                     completion:^{
                     }];
}
//处理跳转
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    NSString* url = [NSString stringWithFormat:@"%@", navigationAction.request.URL];
    if (_callBackBlock) {
        for (NSString* name in _JumpConfig) {
            if ([url rangeOfString:name].length > 0) {
                _callBackBlock(name,url);
            }
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    //    Decides whether to allow or cancel a navigation after its response is known.
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)userContentController:(WKUserContentController*)userContentController
      didReceiveScriptMessage:(WKScriptMessage*)message
{
    
    __weak typeof(self) weakSelf = self;
    if (message.name && [message.name isEqualToString:@"Native"]) {
        NSDictionary *bodyParam = (NSDictionary*)message.body;
        NSString* function = [bodyParam objectForKey:@"function"];
        NSDictionary *parameters = [bodyParam objectForKey:@"parameters"];
        for (NSString* function2 in _functions) {
            if(weakSelf.fcallBackDataBlock){
                if ([function2 isEqualToString:function]) {
                    weakSelf.fcallBackDataBlock(function, parameters);
                }
            }
        }
        //设置动态设置webBox属性。
        if ([function isEqualToString:@"webBoxConfig"]) {
            if ([parameters isKindOfClass:[NSDictionary class]] && parameters.allKeys.count > 0) {
                [JSMiddleFunction initWithTarget:weakSelf withParams:parameters];
            }
        }
    }
}
- (void)webView:(WKWebView*)webView didFinishNavigation:(WKNavigation*)navigation
{
    if (_fBlock) {
        _fBlock(webView);
    }
    if(self.showDocumentTitel||self.title.length==0){
        self.title = webView.title;
    }
    [self dissShowProgressView];
}
- (void)webView:(WKWebView*)webView didFailProvisionalNavigation:(WKNavigation*)navigation withError:(NSError*)error{
    [self deallocProgress];
    if(_faBlock){
        _faBlock(webView, error);
    }
}
- (void)hx_evaluateJavaScriptFuntionName:(NSString*)name withParames:(NSDictionary*)dic
{
    NSString* handleStr = [NSString stringWithFormat:@"NativeCallBack('%@','%@')", name, [NSString jsonWithDic:dic]];
    [self.wkWebView evaluateJavaScript:handleStr completionHandler:nil];
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

