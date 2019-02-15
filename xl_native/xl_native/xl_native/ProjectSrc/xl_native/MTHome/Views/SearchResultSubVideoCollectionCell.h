//
//  AwemeCollectionCell.h
//  Douyin
//
//  Created by songleilei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NetWork_mt_getLikeVideoList.h"
//#import "NetWork_mt_getMyVideos.h"
//#import "NetWork_mt_getDynamics.h"
#import "NetWork_mt_getFuzzyVideoList.h"

//@class WebPImageView;

@interface SearchResultSubVideoCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView    *imageView;
@property (nonatomic, strong) UIButton         *favoriteNum;

- (void)initData:(HomeListModel *)aweme;

@end
