//
//  FocusView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FocusView : UIImageView


@property(nonatomic,copy) void (^focusClickBlock)(FocusView *focusView);

- (void)resetView;

-(void)setUserFollow;
-(void)setUserUnFollow;

@end
