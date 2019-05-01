//
//  SettingAboutViewController.m
//  CMPLjhMobile
//
//  Created by Liyanjun on 2017/5/25.
//  Copyright © 2017年 CMP_Ljh. All rights reserved.
//

#import "UserProtocolViewController.h"

@interface UserProtocolViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic ,strong)NSMutableArray *dataSource;

@end

@implementation UserProtocolViewController

- (WKWebView *)webDefault{
    
    if (!_webDefault) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
        config.mediaTypesRequiringUserActionForPlayback = false;
        
        _webDefault = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight_New, ScreenWidth, ScreenHeight - kNavBarHeight_New) configuration:config];
        _webDefault.backgroundColor = ColorThemeBackground;
//        _webDefault.UIDelegate = self;
//        _webDefault.navigationDelegate = self;
        _webDefault.scrollView.showsVerticalScrollIndicator = NO;
        _webDefault.scrollView.showsHorizontalScrollIndicator = NO;
        
        _webDefault.opaque = NO;
        
        if (@available(iOS 11.0, *)) {
            _webDefault.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
//        [_webDefault addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
//        [_webDefault addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    }
    return _webDefault;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
        [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)initNavTitle{
    self.title = @"用户服务协议";
    self.isNavBackGroundHiden = NO;
    
    self.isNavBackGroundHiden = NO;
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
    
    [self.btnLeft setImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.left = 0;
    viewLine.size = [UIView getSize_width:ScreenWidth - viewLine.left height:0.6];
    viewLine.bottom = self.navBackGround.height - viewLine.height;
    viewLine.backgroundColor = [UIColor grayColor];
    [self.navBackGround addSubview:viewLine];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUi];
}

#pragma mark - 懒加载

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
    
}

#pragma mark - 设置UI
- (void)setupUi{
    
    self.view.backgroundColor = ColorThemeBackground;

    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.miantiaotech.com:8080/miantiao/setting/userAgreement"] encoding:NSUTF8StringEncoding error:nil];
    [self.webDefault loadHTMLString:htmlString baseURL:nil];

    [self.view addSubview:self.webDefault];
}



@end
