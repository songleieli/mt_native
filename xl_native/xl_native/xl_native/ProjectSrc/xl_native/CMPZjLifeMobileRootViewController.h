//
//  CMPLjhMobileRootViewController.h
//  CMPLjhMobile
//
//  Created by sl on 16/5/11.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"
#import "WYPopoverController.h"
#import "QBImagePickerController.h"

//test
#import "PublishViewController.h"
#import "MTGiftView.h"
#import "LSMarqueeView.h"
#import "NetWork_mt_getPrizeList.h"
#import "NetWork_mt_luckdraw.h"
#import "NetWork_mt_getWinners.h"

@class BaseNavigationController;

@class GKDouyinHomeViewController;
@class MTFollowViewController;
@class MTMessageViewController;
@class UserInfoViewController;

@interface CMPZjLifeMobileRootViewController : UIViewController

//viewController
@property (nonatomic, strong) GKDouyinHomeViewController* homeNewViewController;
@property (nonatomic, strong) MTFollowViewController* followViewController;
@property (nonatomic, strong) UIViewController* topicViewController;
@property (nonatomic, strong) MTMessageViewController *messageViewController;
@property (nonatomic, strong) UserInfoViewController* userInfoViewController; 

//NavViewController
@property (nonatomic, strong) BaseNavigationController *xlHomeNavViewController;
@property (nonatomic, strong) BaseNavigationController *followNavViewController;
@property (nonatomic,strong)   BaseNavigationController * topicNavViewController;
@property (nonatomic, strong) BaseNavigationController *messageNavViewController;
@property (nonatomic,strong)   BaseNavigationController * userInfoNavViewController;


@property (nonatomic, strong) BaseNavigationController *currentViewController;
@property (nonatomic, assign) NSInteger currentSelectIndex;

/*
 *popview
 */
@property (nonatomic,strong)PopViewController * popVC;
@property (nonatomic,strong)WYPopoverController * wy;

/*
 *QBImagePickerMediaType
 */
@property (nonatomic) QBImagePickerMediaType mediaType;

@property (strong, nonatomic) UIImageView *viewPopAd; //弹出广告黑色背景View
@property (strong, nonatomic) UIImageView *imageViewNoolde; //挑面动画
@property (strong, nonatomic) MTGiftView *viewGift; //礼品View
@property (nonatomic, strong) LSMarqueeView *marqueeView; //中奖人员，跑马灯

@property (nonatomic ,strong)NSMutableArray *advertisingPopSource;//弹出广告数据源
@property (nonatomic ,strong)NSMutableArray *prizeWinerSource;//获奖人员数据源



- (void)selectTabAtIndex:(NSInteger)toIndex;

@end
