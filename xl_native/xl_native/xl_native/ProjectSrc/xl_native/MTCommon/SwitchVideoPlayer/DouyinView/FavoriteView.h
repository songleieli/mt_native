//
//  FavoriteView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

//static const NSInteger kFavoriteViewLikeBeforeTag  = 0x01;
//static const NSInteger kFavoriteViewLikeAfterTag   = 0x02;

//1.第一种写法
//
//typedef enum
//
//{
//
//    XMGDemoTypeTop,
//
//    XMGDemoTypeBottom,
//
//}XMGDemoType;

typedef enum{
    kFavoriteViewLikeBeforeTag,
    kFavoriteViewLikeAfterTag
}kFavoriteViewType;


@interface FavoriteView : UIView

@property (nonatomic, strong) UIImageView      *favoriteBefore;
@property (nonatomic, strong) UIImageView      *favoriteAfter;

@property(nonatomic,copy) void (^likeClickBlock)(FavoriteView *favoriteView);

- (void)resetView;

@end
