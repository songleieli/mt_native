//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "BgMusicListViewController.h"



//#import "ScrollPlayerListViewController.h"

@interface BgMusicListViewController ()<SubCollectionDelegate,SubHotDelegate>

@end

@implementation BgMusicListViewController

-(void)dealloc{
    NSLog(@"---------------%@ dealloc ",NSStringFromClass([self class]));
}


-(void)initNavTitle{
    self.isNavBackGroundHiden  = NO;
    self.btnLeft.hidden = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft = leftButton;
    self.title = @"音乐";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

-(void)setUpUI{
    self.view.backgroundColor = ColorThemeBackground;
    
    
    CGFloat bodyViewHeight = ScreenHeight - kNavBarHeight_New;
    CGFloat topSpace = 20.0f;
    
    /*
     *多个参数写法，ZJMyRepairSubViewController 要声明对应的参数名称
     */
    NSDictionary *dicOne = @{@"parameter":@"0",@"delegate":self};
    NSDictionary *dicTwo = @{@"parameter":@"1",@"delegate":self};
    NSArray *arrayParameters = @[dicOne,dicTwo];
    NSArray *arrayTitles = @[@"热门",@"收藏"];
    NSArray *arrayControllers = @[@"BgMusicListHotSubViewController",@"BgMusicListCollectionSubViewController"];
    
    self.pageView = [[HYPageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight_New, ScreenWidth, bodyViewHeight+topSpace)
                                           withTitles:arrayTitles
                                  withViewControllers:arrayControllers
                                    withParametersDic:arrayParameters];
    
    self.pageView.isTranslucent = NO;
    self.pageView.selectedColor = ColorWhite;
    self.pageView.unselectedColor = ColorWhiteAlpha60;
    self.pageView.topTabScrollViewBgColor = ColorThemeBackground;
    self.pageView.topTabBottomLineColor = [UIColor grayColor];
    self.pageView.delegate = self;
    
    [self.view addSubview:self.pageView];
}

-(void)backBtnClick:(UIButton*)btn{
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark SubCellDelegate


-(void)subMusicClick:(MusicModel *)model{
    
    NSLog(@"----------");
    
    if ([self.delegate respondsToSelector:@selector(useHotMusicClick:)]) {
        [self.delegate useHotMusicClick:model.localUrl];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)subCellVideoClick:(NSMutableArray *)videoList selectIndex:(NSInteger)selectIndex{

}

@end
