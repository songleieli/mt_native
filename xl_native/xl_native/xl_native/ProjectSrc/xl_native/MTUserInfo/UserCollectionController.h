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

@property (nonatomic, copy) NSString                        *userNoodleId;

@property (nonatomic, strong) SlideTabBar                  *slideTabBar;



@end
