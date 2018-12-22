//
//  SwipeLeftInteractiveTransition.h
//  Douyin
//
//  Created by songleilei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoPlayerListViewController;

@interface SwipeLeftInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;
-(void)wireToViewController:(UserInfoPlayerListViewController *)viewController;

@end
