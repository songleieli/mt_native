//
//  UserInfoViewController.h
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/8.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "AwemeCollectionCell.h"
#import "LoadMoreControl.h"
//转场动画
#import "ScalePresentAnimation.h"
#import "SwipeLeftInteractiveTransition.h"
#import "ScaleDismissAnimation.h"


#import "UserInfoPlayerListViewController.h"
#import "MyMusicHeaderView.h"

#import "NetWork_mt_getHotVideosByMusic.h"
#import "NetWork_mt_collectionTopic.h"

@interface MusicInfoController : ZJBaseViewController<UICollectionViewDelegate,
                                                                    UICollectionViewDataSource,
                                                                    UICollectionViewDelegateFlowLayout,
                                                                    UIViewControllerTransitioningDelegate,MusicHeadDelegate>


@property (nonatomic, strong) UICollectionView                 *collectionView;
@property (nonatomic, assign) NSInteger                        selectIndex;
@property (nonatomic, strong) MyMusicHeaderView             *topicHeader;
@property (nonatomic, strong) LoadMoreControl                  *loadMore;
@property (nonatomic, strong) GetHotVideosByMusicModel         *musicModel;

//Controller 转场动画
@property (nonatomic, strong) ScalePresentAnimation            *scalePresentAnimation;
@property (nonatomic, strong) ScaleDismissAnimation            *scaleDismissAnimation;
@property (nonatomic, strong) SwipeLeftInteractiveTransition   *swipeLeftInteractiveTransition;

@property (nonatomic, copy) NSString                        *musicId;

@end
