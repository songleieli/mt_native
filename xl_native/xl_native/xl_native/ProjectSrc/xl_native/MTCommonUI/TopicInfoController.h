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
#import "MyTopicHeaderView.h"

#import "NetWork_mt_getHotVideosByTopic.h"
#import "NetWork_mt_collectionTopic.h"
#import "NetWork_mt_deleteCollection.h"

@interface TopicInfoController : ZJBaseViewController<UICollectionViewDelegate,
                                                                    UICollectionViewDataSource,
                                                                    UICollectionViewDelegateFlowLayout,
                                                                    UIViewControllerTransitioningDelegate,TopicHeadDelegate>


@property (nonatomic, strong) UICollectionView                 *collectionView;
@property (nonatomic, assign) NSInteger                        selectIndex;
@property (nonatomic, strong) MyTopicHeaderView             *topicHeader;
@property (nonatomic, strong) LoadMoreControl                  *loadMore;
@property (nonatomic, strong) GetHotVideosByTopicModel         *topicModel;

//Controller 转场动画
@property (nonatomic, strong) ScalePresentAnimation            *scalePresentAnimation;
@property (nonatomic, strong) ScaleDismissAnimation            *scaleDismissAnimation;
@property (nonatomic, strong) SwipeLeftInteractiveTransition   *swipeLeftInteractiveTransition;

@property (nonatomic, copy) NSString                        *topicName;

@end
