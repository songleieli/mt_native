//
//  GKDouyinScrollView.m
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "GKDouyinScrollView.h"

@implementation GKDouyinScrollView

#pragma mark - 解决全屏滑动时的手势冲突
// 当UIScrollView在水平方向滑动到第一个时，默认是不能全屏滑动返回的，通过下面的方法可实现其滑动返回。
//gestureRecognizerShouldBegin 开始进行手势识别时调用的方法，返回NO则结束识别，不再触发手势，用处：可以在控件指定的位置使用手势识别
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    //    return NO;
    
    if(self.isPanUse){
        
        if ([self panBack:gestureRecognizer]) {
            return NO;
        }
        return YES;
    }
    else{
        return self.isPanUse;
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.panGestureRecognizer) {
        CGPoint point = [self.panGestureRecognizer translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        
        // 设置手势滑动的位置距屏幕左边的区域
        CGFloat locationDistance = [UIScreen mainScreen].bounds.size.width;
        
        NSLog(@"---------point = %@",NSStringFromCGPoint(point));
        NSLog(@"---------locationDistance = %f",locationDistance);


        
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStatePossible) {
            CGPoint location = [gestureRecognizer locationInView:self];
            NSLog(@"---------location = %@",NSStringFromCGPoint(point));
            NSLog(@"---------self.contentOffset.x = %f",self.contentOffset.x);

            
            if (point.x > 0 && location.x < locationDistance && self.contentOffset.x <= 0) {
                return YES;
            }
            
            // 临界点：scrollView滑动到最后一屏时的x轴位置，可根据需求改变
            CGFloat criticalPoint = [UIScreen mainScreen].bounds.size.width;
            
            
            
            // point.x < 0 代表左滑即手指从屏幕右边向左移动
            // 当UIScrollview滑动到临界点时，则不再相应UIScrollview的滑动左滑手势，防止与左滑手势冲突
            if (point.x < 0 && self.contentOffset.x == criticalPoint) {
                return YES;
            }
        }
    }
    return NO;
}

@end
