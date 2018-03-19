#import <Foundation/Foundation.h>
#import "Masonry.h"
#import "NJKSWesbViewProgress.h"
#import "NSString+Helper.h"
#import "NJKTWebViewProgressView.h"
#import "apiService.h"
//#import "LoadImage.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "CSColorManagement.h"
#import "SCLAlertsView.h"
#import "MJConfigModel.h"
#import "BWSVProgressHUD.h"
#import "CSSVProgressHUD.h"
//登陆页面UI
#define GSLOGINVIEWTYPEINDEX @"GSLginViewTypeIndex"
//注册页面UI
#define GSREHISTVIEWTYPEINDEX @"GSRegistViewTypeIndex"
//提示页面
#define CSUIALERTVIEWINDEX @"CSUIAlertviewindex"
//颜色
#define GSMAINCOLORINDEX @"GSmainColorIndex"
//是否模糊
#define GSISEFFECT @"GSisEffect"
//是否使用本地协议
#define GSLOCALAGREEMENT @"GSLocalAgreement"
//游戏链接
#define GSGAMEURL @"GSgameurl"
//使用WKWebView。
#define USERWKWEBVIEWCONFIG @"USERWKWEBVIEWCONFIG"
//环境
#define GSENVIRONMENT @"GSEnvironment"
#define CGGAMELOADTIMEOUT 30
//内购
#define CSINPURCHASING @"CSInpurchasing"
//游戏加载loadinigndex
#define GSGAMELODINGTYPEINDEX @"CGGameLoadingTypeIndex"
//推送
#define GSAPNSSISEABLE @"GSAPNSSISEABLE"
//应用id或链接。
#define APPSTOREAPPID @"APPSTOREAPPID"

//用户评论信息。
#define USERCOMMENTSINFO @"USERCOMMENTSINFO"

//CSGSKEYCHAINKEY
#define CSGSKEYCHAINKEY @"csgskeychainkey"
#define mainSize    [UIScreen mainScreen].bounds.size
#ifdef DEBUG
#define CSGame_DLog(fmt, ...) NSLog((@"[函数名:%s]"  \
                                      "[行号:%d]" fmt), \
    __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define CSGame_DLog(...);
#endif

//扫荡三国特殊需求
#define sanguoKey 1
//9377旧版
#define SDKVER @""
#define SDKDoMain @""

//KeyChain
//存放账户密码标识符
#define CSGame_KeyChainIdentifier @"9377GameSDKKey"
//快速登录帐号密码保存
//#define CSGame_KeyChainidentifier_FastLogin @"9377GameSDKFastKey"
//自动登录标识符
#define CSGame_AutoLogin [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey]
//Icon标识符
#define CSGame_Icon @"9377Icon"
//Icon标识符
#define CSGame_Domain @""

//CSGame.bundle路径
#define CSGame_BundlePath [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CSSYGameSDK.bundle"]]
#define CSLocalizedStringForKey(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
//OTA
#define CSGame_API_OTA  [NSString stringWithFormat:@"itms-services://?action=download-manifest&url={0}{1}{2}"]

#define CSGame_UIImageName(A) [UIImage imageNamed:[NSString stringWithFormat:@"CSSYGameSDK.bundle/%@",A]]

#define CSGame_Path(A) [NSString stringWithFormat:@"CSSYGameSDK.bundle/%@",A]

#define CSGame_HideNavigationBarTitle self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]
#define CSGame_MAINFONTSIZE [UIFont systemFontOfSize:17]
#define CSGame_Font(A) [UIFont systemFontOfSize:A]
#define CSGame_boldFont(A) [UIFont boldSystemFontOfSize:A]

#define CSgame_isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define CSGame_Cellheight if (CSgame_isiPad){return CSGame_ScreenHeight / (CSGame_ios7?17:14);}else{if (CSGame_isPortrait){return CSGame_ScreenHeight / 14;}else{return CSGame_ScreenHeight / (CSGame_ios7?14:8);}}

//#define CSGame_Cellheight if (CSgame_isiPad){return CSGame_ScreenHeight / 12;}else{return CSGame_isPortrait?CSGame_ScreenHeight / 15:CSGame_ScreenHeight / 8;}

#define CSGame_iphone4 [UIScreen mainScreen].bounds.size.width == 480.00 || [UIScreen mainScreen].bounds.size.height == 480.00
#define CSGame_iphone5 [UIScreen mainScreen].bounds.size.width == 568.00 || [UIScreen mainScreen].bounds.size.height == 568.00
#define CSGame_iphone6 [UIScreen mainScreen].bounds.size.width == 667.00 || [UIScreen mainScreen].bounds.size.height == 667.00
#define CSGame_iphone6p [UIScreen mainScreen].bounds.size.width == 736.00 || [UIScreen mainScreen].bounds.size.height == 736.00

#define CSGame_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define CSGame_ScreenHeight [UIScreen mainScreen].bounds.size.height
#define CSGame_ios6 [[UIDevice currentDevice].systemVersion doubleValue] < 7.0
#define CSGame_ios7 [[UIDevice currentDevice].systemVersion doubleValue] < 8.0
#define CSGame_ios8 [[UIDevice currentDevice].systemVersion doubleValue] >= 8.0

#define CSGame_isPortrait [UIApplication sharedApplication].statusBarOrientation ==  UIInterfaceOrientationPortrait && [UIScreen mainScreen].bounds.size.height != [[UIScreen mainScreen] applicationFrame].size.height
#define CSGame_isLandscape [UIApplication sharedApplication].statusBarOrientation ==  UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation ==  UIInterfaceOrientationLandscapeRight

//iphone各尺寸横竖屏宏
#define CSGame_Iphone4Portrait  [UIScreen mainScreen].bounds.size.height != [[UIScreen mainScreen] applicationFrame].size.height && [UIScreen mainScreen].bounds.size.height == 480.00
#define CSGame_Iphone4Landscape  [UIScreen mainScreen].bounds.size.height == [[UIScreen mainScreen] applicationFrame].size.height && [UIScreen mainScreen].bounds.size.height == 480.00
#define CSGame_Iphone5Portrait  [UIScreen mainScreen].bounds.size.height != [[UIScreen mainScreen] applicationFrame].size.height && [UIScreen mainScreen].bounds.size.height == 568.00
#define CSGame_Iphone5Landscape  [UIScreen mainScreen].bounds.size.height == [[UIScreen mainScreen] applicationFrame].size.height && [UIScreen mainScreen].bounds.size.height == 568.00
#define CSGame_Iphone6Portrait  [UIScreen mainScreen].bounds.size.height != [[UIScreen mainScreen] applicationFrame].size.height && [UIScreen mainScreen].bounds.size.height == 667.00
#define CSGame_Iphone6Landscape  [UIScreen mainScreen].bounds.size.height == [[UIScreen mainScreen] applicationFrame].size.height && [UIScreen mainScreen].bounds.size.height == 667.00
#define CSGame_Iphone6pPortrait  [UIScreen mainScreen].bounds.size.height != [[UIScreen mainScreen] applicationFrame].size.height && [UIScreen mainScreen].bounds.size.height == 736.00
#define CSGame_Iphone6pLandscape  [UIScreen mainScreen].bounds.size.height == [[UIScreen mainScreen] applicationFrame].size.height && [UIScreen mainScreen].bounds.size.height == 736.00
