//
//  UserInfoViewController.h
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/8.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "UserCollectionHeader.h"
#import "AwemeCollectionCell.h"
#import "LoadMoreControl.h"
#import "PhotoView.h"
#import "MenuPopView.h"

//转场动画
#import "ScalePresentAnimation.h"
#import "SwipeLeftInteractiveTransition.h"
#import "ScaleDismissAnimation.h"

#import "UserInfoPlayerListViewController.h"
//#import "NetWork_mt_saveflour.h"
//#import "NetWork_mt_delflour.h"

#import "NetWork_mt_collectionVideo.h"
#import "NetWork_mt_getTopicCollections.h"


@interface UserCollectionController : ZJBaseViewController<UICollectionViewDelegate,
                                                                    UICollectionViewDataSource,
                                                                    UICollectionViewDelegateFlowLayout,
                                                                    UIViewControllerTransitioningDelegate,
                                                                    UserInfoDelegate,
                                                                    OnTabTapActionDelegate>


@property (nonatomic, strong) UICollectionView                 *collectionView;
@property (nonatomic, assign) NSInteger                        selectIndex;
@property (nonatomic, strong) PersonalModel                     *user;
@property (nonatomic, strong) UserCollectionHeader             *collectionHeader;
@property (nonatomic, strong) LoadMoreControl                  *loadMore;

//Controller 转场动画
@property (nonatomic, strong) ScalePresentAnimation            *scalePresentAnimation;
@property (nonatomic, strong) ScaleDismissAnimation            *scaleDismissAnimation;
@property (nonatomic, strong) SwipeLeftInteractiveTransition   *swipeLeftInteractiveTransition;

@property (nonatomic, copy) NSString                        *userNoodleId;

@property (nonatomic, strong) SlideTabBar                  *slideTabBar;



@end
