//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "UserCollectionController.h"

#import "TopicInfoController.h"
#import "MusicInfoController.h"

#import "UserCollectionSubMusicViewController.h"
#import "UserCollectionSubTopicViewController.h"
#import "UserCollectionSubVideoViewController.h"

#import "ScrollPlayerListViewController.h"

@interface UserCollectionController ()<SubTopicCellDelegate,SubMusicCellDelegate,SubVideoCellDelegate>

@end

@implementation UserCollectionController

-(void)dealloc{
    NSLog(@"---------------%@ dealloc ",NSStringFromClass([self class]));
}


-(void)initNavTitle{
    self.isNavBackGroundHiden  = NO;
    self.btnLeft.hidden = YES;
    self.lableNavTitle.textColor = ColorWhite;
    self.lableNavTitle.font = BigBoldFont; //[UIFont defaultBoldFontWithSize:16];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft = leftButton;
    

    self.title = @"收藏";
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
    NSDictionary *dicThree = @{@"parameter":@"2",@"delegate":self};
//    NSArray *arrayParameters = @[dicOne,dicTwo,dicThree,dicFour,dicFive];
    NSArray *arrayParameters = @[dicOne,dicTwo,dicThree];
    NSArray *arrayTitles = @[@"视频",@"话题",@"音乐"];
    NSArray *arrayControllers = @[@"UserCollectionSubVideoViewController",@"UserCollectionSubTopicViewController",@"UserCollectionSubMusicViewController"];
    
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark SubCellDelegate

-(void)subCellTopicClick:(GetTopicCollectionModel *)model{
    
    TopicInfoController *topicInfoController = [[TopicInfoController alloc] init];
    topicInfoController.topicName = model.topicName;
    [self pushNewVC:topicInfoController animated:YES];
    
}

-(void)subMusicClick:(MusicModel *)model{
    
    MusicInfoController *musicInfoController = [[MusicInfoController alloc] init];
    musicInfoController.musicId = model.musicId;
    [self pushNewVC:musicInfoController animated:YES];
}

-(void)subCellVideoClick:(NSMutableArray *)videoList selectIndex:(NSInteger)selectIndex{
    
    ScrollPlayerListViewController *controller;
    controller = [[ScrollPlayerListViewController alloc] initWithVideoData:videoList currentIndex:selectIndex];
    [self pushNewVC:controller animated:YES];
}

@end
