//
//  FavoriteView.h
//  Douyin
//
//  Created by songlei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kFavoriteViewLikeBeforeTag,
    kFavoriteViewLikeAfterTag
}kFavoriteViewType;


@interface FavoriteView : UIView

@property (nonatomic, strong) UIImageView      *favoriteBefore;
@property (nonatomic, strong) UIImageView      *favoriteAfter;

@property(nonatomic,copy) void (^likeClickBlock)(FavoriteView *favoriteView);

- (void)resetView;

-(void)setUserLike;
-(void)setUserUnLike;

#pragma mark ------------ 首页第一行下拉刷新，添加蒙版，响应事件添加方法，模仿响应事件,特殊处理----------------

- (void)favoriteViewLikeClick:(BOOL)isLike;

@end
