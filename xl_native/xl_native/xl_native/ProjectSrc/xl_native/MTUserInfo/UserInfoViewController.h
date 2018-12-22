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

#import "ScalePresentAnimation.h"
#import "SwipeLeftInteractiveTransition.h"
#import "ScaleDismissAnimation.h"

#import "UserInfoPlayerListViewController.h"



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

//Controller 转场动画
@property (nonatomic, strong) ScalePresentAnimation            *scalePresentAnimation;
@property (nonatomic, strong) ScaleDismissAnimation            *scaleDismissAnimation;
@property (nonatomic, strong) SwipeLeftInteractiveTransition   *swipeLeftInteractiveTransition;

@property (nonatomic, assign) FromType                        fromType;
@property (nonatomic, copy) NSString                        *userNoodleId;


@end
