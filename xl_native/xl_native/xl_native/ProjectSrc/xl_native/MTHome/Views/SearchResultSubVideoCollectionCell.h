//
//  AwemeCollectionCell.h
//  Douyin
//
//  Created by songleilei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetWork_mt_getFuzzyVideoList.h"

@interface SearchResultSubVideoCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView    *imageView;
@property (nonatomic, strong) UIImageView    *imageViewUser;
@property (nonatomic,strong) UILabel *labelNickName;
@property (nonatomic,strong) UILabel *labelDesc;

@property (nonatomic, strong) UIButton         *favoriteNum;

- (void)initData:(HomeListModel *)aweme withKeyWord:(NSString*)withKeyWord;

@end
