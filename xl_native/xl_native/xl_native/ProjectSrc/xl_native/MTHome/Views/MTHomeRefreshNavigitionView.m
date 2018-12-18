
//
//  RefreshNavigitionView.m
//  douyin
//
//  Created by 澜海利奥 on 2018/4/12.
//  Copyright © 2018年 江萧. All rights reserved.
//

#import "MTHomeRefreshNavigitionView.h"

@implementation MTHomeRefreshNavigitionView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.size = [UIView getSize_width:100 height:44];
        titleLable.center = self.center;
//        titleLable.origin = [UIView getPoint_x:self. y:0];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.textColor = [UIColor whiteColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.numberOfLines = 0;
        titleLable.font = [UIFont defaultFontWithSize:16];
        titleLable.text = @"下拉刷新内容";
        [self addSubview:titleLable];
        
        _circleImage = [[UIImageView alloc] init];
        _circleImage.size = [UIView getSize_width:18 height:18];
        _circleImage.right  = self.width - 30;
        _circleImage.centerY = self.centerY;
        _circleImage.image = [UIImage imageNamed:@"circle"];
        [self addSubview:_circleImage];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
