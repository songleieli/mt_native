//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "UserCollectionController_temp.h"

//#import "TopicInfoController.h"
//#import "MusicInfoController.h"
//#import "UserInfoViewController.h"
#import "UserCollectionSubMusicViewController.h"
#import "UserCollectionSubTopicViewController.h"
#import "UserCollectionSubVideoViewController.h"

#import "ScrollPlayerListViewController.h"

@interface UserCollectionController_temp ()

@end

@implementation UserCollectionController_temp

-(void)dealloc{
    NSLog(@"---------------%@ dealloc ",NSStringFromClass([self class]));
}

- (instancetype)initWithKeyWord:(NSString*)keyWord{
    
    self = [super init];
    if (self) {
        self.keyWord = keyWord;
    }
    return self;

}


-(void)initNavTitle{
    self.isNavBackGroundHiden  = NO;
    self.btnLeft.hidden = YES;
    
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
    
    //暂时先屏蔽，转场动画
    //    _scalePresentAnimation = [ScalePresentAnimation new];
    //    _scaleDismissAnimation = [ScaleDismissAnimation new];
    //    _swipeLeftInteractiveTransition = [SwipeLeftInteractiveTransition new];
    
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
    self.pageView.selectedColor = [UIColor whiteColor];
    self.pageView.unselectedColor = RGBA(120, 122, 132, 1);
    self.pageView.topTabScrollViewBgColor = ColorThemeBackground;
    self.pageView.topTabBottomLineColor = [UIColor grayColor];
    self.pageView.delegate = self;
    
    [self.view addSubview:self.pageView];
}





-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark SubCellDelegate

-(void)subCellTopicClick:(GetFuzzyTopicListModel *)model{
    NSLog(@"-------------");
    
//    TopicInfoController *topicInfoController = [[TopicInfoController alloc] init];
//    topicInfoController.topicName = model.topic;
//    [self pushNewVC:topicInfoController animated:YES];
    
}

//-(void)subMusicClick:(GetFuzzyMusicListModel *)model{
//    MusicInfoController *musicInfoController = [[MusicInfoController alloc] init];
//    musicInfoController.musicId = model.id;
//    [self pushNewVC:musicInfoController animated:YES];
//}

-(void)subCellVideoClick:(NSMutableArray *)videoList selectIndex:(NSInteger)selectIndex{
    NSLog(@"-------------");
    ScrollPlayerListViewController *controller;
    controller = [[ScrollPlayerListViewController alloc] initWithVideoData:videoList currentIndex:selectIndex];
    controller.transitioningDelegate = self;
    
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [_swipeLeftInteractiveTransition wireToViewController:controller];
    [self presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark --------------- UIViewControllerTransitioningDelegate Delegate  Controller 之间的转场动画 -----------------

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _scalePresentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _scaleDismissAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _swipeLeftInteractiveTransition.interacting ? _swipeLeftInteractiveTransition : nil;
}


@end
