
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

        _titleLable = [[UILabel alloc] init];
        _titleLable.size = [UIView getSize_width:100 height:44];
        _titleLable.center = self.center;
//        titleLable.origin = [UIView getPoint_x:self. y:0];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.numberOfLines = 0;
        _titleLable.font = [UIFont defaultFontWithSize:16];
        _titleLable.text = @"下拉刷新内容";
        [self addSubview:_titleLable];
        
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
