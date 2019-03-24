//
//  CustomTabBar.m
//  CustomTabBarController
//
//  Created by Hu Zhiqiang on 22/05/2012.
//  Copyright (c) 2012 __My Computer__. All rights reserved.
//

#import "ZJCustomTabBar.h"

@implementation ZJCustomTabBar
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;

- (id)initWithButtonImages:(NSArray *)imageArray
                titleArray:(NSArray*)titleArray
                  delegate:(id<ZJCustomTabBarDelegate>)delegate{
    
    self = [super init];
    if (self){
        
        self.delegate = delegate;
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.4)];
        lineLabel.backgroundColor = [UIColor grayColor]; //RGBAlphaColor(222, 222, 222, 0.8);
        [self addSubview:lineLabel];
        
        if([NSStringFromClass([self.delegate class]) isEqualToString:@"GKDouyinHomeViewController"]){
            //self.backgroundColor = [UIColor clearColor];
            self.backgroundColor = RGBAlphaColor(0, 0, 0, 0.2);
        }
        else{
            self.backgroundColor = [UIColor blackColor];
        }
        
        self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
        CGFloat offX = 0;
        CGFloat width = (CGFloat)ScreenWidth/imageArray.count;
        
        for (int i = 0; i < [imageArray count]; i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(offX, 0.4, width, kTabBarHeight_New);
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            offX += width;
            
            
            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.size = [UIView getSize_width:30 height:5];
            imgBtn.origin = [UIView getPoint_x:(btn.width - imgBtn.width)/2
                                             y:kTabBarHeight - imgBtn.height];
            [imgBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
            [imgBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            titleBtn.tag = i;
            titleBtn.size = [UIView getSize_width:imgBtn.width height:kTabBarHeight-imgBtn.height];
            titleBtn.origin = [UIView getPoint_x:imgBtn.left
                                               y:lineLabel.bottom];
            titleBtn.titleLabel.font = [UIFont defaultBoldFontWithSize: 15.0];
            [titleBtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [titleBtn setTitleColor:ColorWhiteAlpha60 forState:UIControlStateNormal];
            [titleBtn setTitleColor:MTColorTitle forState:UIControlStateSelected];
            [titleBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:titleBtn];
            
            //test
//            titleBtn.backgroundColor = [UIColor redColor];
            


            
            imgBtn.tag = i;

            if(i == 2){
                imgBtn.frame = CGRectMake(0, 5, 50, 32);
                UIImage *img = [BundleUtil getCurrentBundleImageByName:@"mt_publish"];
                [imgBtn setImage:img  forState:UIControlStateNormal];
            }
            imgBtn.left = (btn.width - imgBtn.width)/2;
            [btn addSubview:imgBtn];
            [imgBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttons addObject:btn];
            [self addSubview:btn];
        }
    }
    return self;
}


////暂时不用了
//- (void)longPressBtn:(UILongPressGestureRecognizer*)guester{
//     NSLog(@"长按事件%ld",guester.view.tag);
//
//
//    if ([_delegate respondsToSelector:@selector(tabBar:longPressed:guester:)]){
//        [_delegate tabBar:self longPressed:guester.view.tag guester:guester];
//    }
//
//}


- (void)tabBarButtonClicked:(id)sender{
    UIButton *btn = sender;
    if ([_delegate respondsToSelector:@selector(tabBar:shouldSelectIndex:)]){
        BOOL should = [_delegate tabBar:self shouldSelectIndex:btn.tag];
        if(should == NO){
            return;
        }
    }
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]){
        [_delegate tabBar:self didSelectIndex:btn.tag];
    }
}

- (void)selectTabAtIndex:(NSInteger)index{
    for (int i = 0; i < [self.buttons count]; i++){
        UIButton *imgBtn = [[[self.buttons objectAtIndex:i] subviews] objectAtIndex:0];
        UIButton *titleBtn = [[[self.buttons objectAtIndex:i] subviews] objectAtIndex:1];
        imgBtn.selected = NO;
        titleBtn.selected = NO;
        
        
    }
    UIButton *imgBtn = [[[self.buttons objectAtIndex:index] subviews] objectAtIndex:0];
    UIButton *titleBtn = [[[self.buttons objectAtIndex:index] subviews] objectAtIndex:1];
    imgBtn.selected = YES;
    titleBtn.selected = YES;
    
    [imgBtn setUserInteractionEnabled:NO];
}

@end
