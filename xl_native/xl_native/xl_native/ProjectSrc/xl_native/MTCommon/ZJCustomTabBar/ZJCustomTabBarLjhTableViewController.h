//
//  CustomTabBarController.h
//  CustomTabBarController
//
//  Created by Hu Zhiqiang on 22/05/2012.
//  Copyright (c) 2012 __My Computer__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJCustomTabBar.h"

@protocol ZJChangeIndexDelegate;

@interface ZJCustomTabBarLjhTableViewController : ZJBaseViewController <ZJCustomTabBarDelegate>{
//    ZJCustomTabBar        *_tabBar;
//    NSUInteger      _selectedIndex;
}

@property(nonatomic) NSUInteger pageIndex;
@property(nonatomic) BOOL isTableHiden;
@property (nonatomic, retain) ZJCustomTabBar *tabBar;
@property (nonatomic, weak) id <ZJChangeIndexDelegate> changeIndexDelegate;


-(CGFloat)getTabbarTop;

- (void)hiddenTabBar:(BOOL)hidden isAnimat:(BOOL)isAnimat;

@end

@protocol ZJChangeIndexDelegate<NSObject>
@optional

- (BOOL)customTabBar:(ZJCustomTabBarLjhTableViewController *)tabBar shouldSelectIndex:(NSInteger)index;
- (void)customTabBar:(ZJCustomTabBarLjhTableViewController *)tabBar didSelectIndex:(NSInteger)index;

@end

