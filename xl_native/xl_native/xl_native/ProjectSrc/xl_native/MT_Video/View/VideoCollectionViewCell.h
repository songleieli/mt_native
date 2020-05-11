//
//  TopSerchCollectionViewCell.h
//  CMPLjhMobile
//
//  Created by Liyanjun on 2017/3/27.
//  Copyright © 2017年 CMP_Ljh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCollectionViewCell : UICollectionViewCell


- (void)dataBind:(NSString *)titleStr;


// 创建id

+ (NSString *)registerCellID;

@end
