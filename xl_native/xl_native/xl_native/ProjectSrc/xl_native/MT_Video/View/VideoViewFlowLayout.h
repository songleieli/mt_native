//
//  HoverViewFlowLayout.h
//  Douyin
//
//  Created by songleilei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat      topHeight;

- (instancetype)initWithTopHeight:(CGFloat)height;

@end
