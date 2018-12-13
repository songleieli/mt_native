//
//  CustomTabBarController.m
//  CustomTabBarController
//
//  Created by angie on 22/05/2012.
//  Copyright (c) 2012 cetetek. All rights reserved.
//

#import "TBCustomTabWebController.h"
#import "TBCustomTabBar.h"


@interface TBCustomTabWebController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
@end

@implementation TBCustomTabWebController

@synthesize selectedIndex = _selectedIndex;

//- (id)initWithViewControllers:(NSArray *)controllers imageArray:(NSArray *)images  titleArray:(NSArray*)titleArray{
//    self = [super init];
//    if (self != nil){
//        _tabBar = [[ZJCustomTabBar alloc] initWithButtonImages:images titleArray:titleArray delegate:self];
//        
//        _tabBar.delegate = self;
//    }
//    return self;
//}

-(CGFloat)getTabbarTop{

    CGFloat top = ScreenHeight - kTabBarHeight_New;//默认隐藏
    if(self.isNavBackGroundHiden == NO){
//        top = ScreenHeight - kTabBarHeight_New-kNavBarHeight_New-KTabBarHeightOffset_New;
    }
    
    UIViewController *rootViewController = [[self parentViewController] parentViewController];
    UIViewController *baseNavViewController = [self parentViewController];

    NSLog(@"self class = %@",NSStringFromClass([self class]));
    
//    if([rootViewController isKindOfClass:[JunrongLoanRootViewController class]]
//       && [baseNavViewController isKindOfClass:[BaseNavigationController class]]){
//        
//        /*
//         用于判断应用启用无线热点，的页面适配
//         */
//    
//    if(rootViewController.view.top == 0 && baseNavViewController.view.top == 0){
//        /*
//         正常启动 或 正常启动切换到热点再切换到正常
//         */
//        NSLog(@"正常启动 或 正常启动切换到热点再切换到正常");
//    }
//    else if (rootViewController.view.top == 20 && baseNavViewController.view.top == 0){
//        /*
//         正常启动情况下，切换到热点
//         */
//        NSLog(@"正常启动情况下，切换到热点");
//        
//        top = top -20;
//
//    }
//    else if (rootViewController.view.top == 20 && baseNavViewController.view.top == 20){
//        /*
//         热点启动 或 热点启动切换到正常在切换到热点
//         */
//        NSLog(@"热点启动");
//        
//        if(self.navigationController.navigationBarHidden == NO){//显示NAV
//            top = top -20;
//        }
//        else{//不显示NAV
//            top = top -40;
//        }
//    }
//    else if (rootViewController.view.top == 0 && baseNavViewController.view.top == 20){
//        /*
//         热点启动，切换到正常
//         */
//        NSLog(@"热点启动，切换到正常");
//        if(self.navigationController.navigationBarHidden == NO){//显示NAV
//            //不处理
//        }
//        else{//不显示NAV
//            top = top - 20;
//        }
//    }
//    }
    

    
    return top;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view bringSubviewToFront:self.tabBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameDidChange:) name : UIApplicationDidChangeStatusBarFrameNotification object : nil ];

    NSArray *titles     = @[@"财富计划",@"乡邻订单",@"乡邻档案"];
    
    
    NSMutableDictionary * propertyProjectImageDic= [NSMutableDictionary dictionaryWithCapacity:0];
    [propertyProjectImageDic setObject:[UIImage imageNamed:@"tabBar0"] forKey:@"Default"];
    [propertyProjectImageDic setObject:[UIImage imageNamed:@"tabBar0_H"] forKey:@"Seleted"];
    
    NSMutableDictionary *neighboursImageDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [neighboursImageDic setObject:[UIImage imageNamed:@"tabBar1"] forKey:@"Default"];
    [neighboursImageDic setObject:[UIImage imageNamed:@"tabBar1_H"] forKey:@"Seleted"];
    
    NSMutableDictionary *plusImageDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [plusImageDic setObject:[UIImage imageNamed:@"tabBar2"] forKey:@"Default"];
    [plusImageDic setObject:[UIImage imageNamed:@"tabBar2_H"] forKey:@"Seleted"];
    
    NSArray *imageArray = [NSArray arrayWithObjects:propertyProjectImageDic, neighboursImageDic,plusImageDic, nil];
    
    _tabBar = [[TBCustomTabBar alloc] initWithButtonImages:imageArray titleArray:titles delegate:self];
    
    
    self.tabBar.frame = CGRectMake(0, [self getTabbarTop], ScreenWidth, kTabBarHeight_New);
    [self.tabBar selectTabAtIndex:_selectedIndex];
    
//    _tabBar.delegate = self;
    [self.view addSubview:self.tabBar];
}

- (void)viewDidUnload{
	[super viewDidUnload];
	
	_tabBar = nil;
	//_viewControllers = nil;
}

#pragma mark - 热点frame 变化通知 ---

-(void)statusBarFrameDidChange:(NSNotification *)notification{
    self.tabBar.top = [self getTabbarTop];
}


#pragma mark - instant methods

- (TBCustomTabBar *)tabBar{
	return _tabBar;
}

- (NSUInteger)selectedIndex{
	return _selectedIndex;
}

#pragma mark - Private methods

- (void)hiddenTabBar:(BOOL)hidden isAnimat:(BOOL)isAnimat{
    if(isAnimat){
        if (hidden  && self.tabBar.frame.origin.y == self.view.height - kTabBarHeight_New ) {       //隐藏tabbar
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            
            self.tabBar.frame = CGRectMake(0, self.view.height+25, ScreenWidth, kTabBarHeight_New);
            [UIView commitAnimations];
            
        } else if(!hidden  && self.tabBar.frame.origin.y - 25 == self.view.height ){                 //显示tabbar
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            
            self.tabBar.frame = CGRectMake(0, self.view.height - kTabBarHeight_New, ScreenWidth, kTabBarHeight_New);
            [UIView commitAnimations];
        }
    }
    else{
        if(hidden  && self.tabBar.frame.origin.y == self.view.height - kTabBarHeight_New ){       //隐藏tabbar
            self.tabBar.frame = CGRectMake(0, self.view.height, ScreenWidth, kTabBarHeight_New);
            
        } else if(!hidden && self.tabBar.frame.origin.y == self.view.height ){                 //显示tabbar
            self.tabBar.frame = CGRectMake(0, self.view.height - kTabBarHeight_New, ScreenWidth, kTabBarHeight_New);
        }
    }
    
    [self tabBarDidHide:hidden];
}

#pragma mark tabBar delegates

- (BOOL)tabBar:(TBCustomTabBar *)tabBar shouldSelectIndex:(NSInteger)index{
    
    if(index == _selectedIndex){
        return NO;
    }
    else{
        if ([_changeIndexDelegate respondsToSelector:@selector(customTabBar:shouldSelectIndex:)]){
            return [_changeIndexDelegate customTabBar:self shouldSelectIndex:index];
        }
        return YES;
    }
}

- (void)tabBar:(TBCustomTabBar *)tabBar didSelectIndex:(NSInteger)index{
    if ([_changeIndexDelegate respondsToSelector:@selector(customTabBar:didSelectIndex:)]){
        return [_changeIndexDelegate customTabBar:self didSelectIndex:index];
    }
}

-(void)tabBarDidHide:(BOOL)hidden{
    NSLog(@"---------------over write me-----------在子类中实现tabBar隐藏后的操作-------");
}

@end
