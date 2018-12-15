//
//  AwemeCollectionCell.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWork_mt_getLikeVideoList.h"

//@class WebPImageView;

@interface AwemeCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView    *imageView;
@property (nonatomic, strong) UIButton         *favoriteNum;

- (void)initData:(HomeListModel *)aweme;

@end
