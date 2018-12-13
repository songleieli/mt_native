//
//  CustomTabBar.h
//  CustomTabBarController
//
//  Created by Hu Zhiqiang on 22/05/2012.
//  Copyright (c) 2012 __My Computer__. All rights reserved.
//

#import "UIView+Common.h"

@protocol TBCustomTabBarDelegate;

@interface TBCustomTabBar : UIView{
	NSMutableArray *_buttons;
}
@property (nonatomic, weak) id <TBCustomTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;

//区分 CustomTabBarController 用来判断，是不是集团要闻。如果是集团要闻，第二个按钮不需要放大。
@property (nonatomic, copy) NSString *strCVClass;

- (id)initWithButtonImages:(NSArray *)imageArray titleArray:(NSArray*)titleArray delegate:(id<TBCustomTabBarDelegate>)delegate;

- (void)selectTabAtIndex:(NSInteger)index;
- (void)tabBarButtonClicked:(id)sender;
@end

@protocol TBCustomTabBarDelegate<NSObject>
@optional
- (BOOL)tabBar:(TBCustomTabBar *)tabBar shouldSelectIndex:(NSInteger)index;
- (void)tabBar:(TBCustomTabBar *)tabBar didSelectIndex:(NSInteger)index;
- (void)tabBar:(TBCustomTabBar *)tabBar longPressed:(NSInteger)index guester:(UILongPressGestureRecognizer*)guester;//长按事件

@end
