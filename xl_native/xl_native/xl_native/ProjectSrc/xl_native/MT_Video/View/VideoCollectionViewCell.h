//
//  TopSerchCollectionViewCell.h
//  CMPLjhMobile
//
//  Created by Liyanjun on 2017/3/27.
//  Copyright © 2017年 CMP_Ljh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWork_mt_home_list.h"

@interface VideoCollectionViewCell : UICollectionViewCell


#pragma mark ------- 属性 ------

@property(nonatomic,strong) HomeListModel * listModel;

@property (nonatomic, strong) UIImageView    *imageView;
@property (nonatomic, strong) UIButton         *favoriteNum;

#pragma mark ------- 方法 ------

+ (NSString *)registerCellID;

- (void)fillDataWithModel:(HomeListModel *)listModel;


@end
