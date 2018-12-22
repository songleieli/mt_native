//
//  PhotoView.h
//  Douyin
//
//  Created by songleilei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleProgressView;

@interface PhotoView:UIView

@property (nonatomic, strong) CircleProgressView        *progressView;
@property (nonatomic, strong) UIView                    *container;
@property (nonatomic, strong) UIImageView               *imageView;

- (instancetype)initWithUrl:(NSString *)urlPath;
- (instancetype)initWithImage:(UIImage *)image urlPath:(NSString *)urlPath;
- (instancetype)initWithImage:(UIImage *)image;

- (void)show;
- (void)dismiss;

@end
