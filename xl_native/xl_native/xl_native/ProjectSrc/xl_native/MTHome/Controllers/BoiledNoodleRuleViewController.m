//
//  SettingAboutViewController.m
//  CMPLjhMobile
//
//  Created by Liyanjun on 2017/5/25.
//  Copyright © 2017年 CMP_Ljh. All rights reserved.
//

#import "BoiledNoodleRuleViewController.h"

@interface BoiledNoodleRuleViewController ()<WKNavigationDelegate>

@end

@implementation BoiledNoodleRuleViewController


#pragma mark - 懒加载

- (WKWebView *)webDefault{
    
    if (!_webDefault) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        config.allowsInlineMediaPlayback = YES;
        config.mediaTypesRequiringUserActionForPlayback = false;
        
        _webDefault = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight_New, ScreenWidth, ScreenHeight - kNavBarHeight_New) configuration:config];
        _webDefault.backgroundColor = ColorThemeBackground;
//        _webDefault.UIDelegate = self;
        _webDefault.navigationDelegate = self;
        _webDefault.scrollView.showsVerticalScrollIndicator = NO;
        _webDefault.scrollView.showsHorizontalScrollIndicator = NO;
        
        _webDefault.opaque = NO;
        
        if (@available(iOS 11.0, *)) {
            _webDefault.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _webDefault;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
        [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)initNavTitle{
    
    [super initNavTitle];
    
    self.title = @"煮面规则";
    self.isNavBackGroundHiden = NO;
    
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnLeft = leftButton;

    self.navBackGround.backgroundColor = ColorThemeBackground;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUi];
}


-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置UI
- (void)setupUi{

    self.view.backgroundColor = ColorThemeBackground;

    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.miantiaotech.com:8080/miantiao/boiled/getRule"] encoding:NSUTF8StringEncoding error:nil];
    [self.webDefault loadHTMLString:htmlString baseURL:nil];

    [self.view addSubview:self.webDefault];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    CGFloat scale = 234.0f; //sizeScale(200);
    NSString *html = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%.2f%%'",scale];
    //修改字体大小
    [ webView evaluateJavaScript:html completionHandler:nil];
    //修改字体颜色
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#ffffff'" completionHandler:nil];
}



@end
