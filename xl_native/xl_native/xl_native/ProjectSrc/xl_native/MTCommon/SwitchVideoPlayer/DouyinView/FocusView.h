//
//  FocusView.h
//  Douyin
//
//  Created by songleilei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FocusView : UIImageView


@property(nonatomic,copy) void (^focusClickBlock)(FocusView *focusView);

- (void)resetView;

-(void)setUserFollow;
-(void)setUserUnFollow;

#pragma mark ------------ 首页第一行下拉刷新，添加蒙版，响应事件添加方法，模仿响应事件,特殊处理----------------

-(void)beginAnimation;

@end
