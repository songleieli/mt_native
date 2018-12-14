//
//  FavoriteView.h
//  Douyin
//
//  Created by songlei on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
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

@end
