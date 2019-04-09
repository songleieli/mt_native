//
//  UserInfoViewController.h
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/8.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//



//typedef enum{
//    kFavoriteViewLikeBeforeTag,
//    kFavoriteViewLikeAfterTag
//}kFavoriteViewType;

typedef enum{
    FromTypeMy,
    FromTypeHome,
}FromType;



#import "ZJCustomTabBarLjhTableViewController.h"

#import "UserInfoHeader.h"
#import "AwemeCollectionCell.h"
#import "LoadMoreControl.h"
#import "PhotoView.h"
#import "MenuPopView.h"


//#import "UserInfoPlayerListViewController.h"
#import "ScrollPlayerListViewController.h"

#import "NetWork_mt_saveflour.h"
#import "NetWork_mt_delflour.h"

#import "UserCollectionController.h"
#import "MySettingViewController.h"
#import "UserSettingViewController.h"


@interface UserInfoViewController : ZJCustomTabBarLjhTableViewController<UICollectionViewDelegate,
                                                                    UICollectionViewDataSource,
                                                                    UICollectionViewDelegateFlowLayout,
                                                                    UIViewControllerTransitioningDelegate,
                                                                    UserInfoDelegate,
                                                                    OnTabTapActionDelegate>


@property (nonatomic, strong) UICollectionView                 *collectionView;
@property (nonatomic, assign) NSInteger                        selectIndex;
@property (nonatomic, strong) PersonalModel                     *user;
@property (nonatomic, strong) UserInfoHeader                   *userInfoHeader;
@property (nonatomic, strong) LoadMoreControl                  *loadMore;

@property (nonatomic, assign) FromType                        fromType;
@property (nonatomic, copy) NSString                          *userNoodleId;

@property (nonatomic, strong) NetWork_mt_getMyVideos *requestMyVideo;
@property (nonatomic, strong) NetWork_mt_getDynamics *requestDynamic;
@property (nonatomic, strong) NetWork_mt_getLikeVideoList *requestLike;

@end
