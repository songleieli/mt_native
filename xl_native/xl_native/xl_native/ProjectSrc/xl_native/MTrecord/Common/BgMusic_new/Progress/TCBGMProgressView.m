//
//  TCBGMProgressView.m
//  TXXiaoShiPinDemo
//
//  Created by shengcui on 2018/7/26.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "TCBGMProgressView.h"

@implementation TCBGMProgressView
{
    UIView  *_maskView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    
    self.layer.masksToBounds = YES;
    
    self.maskView = [[UIView alloc] init];
    self.maskView.size = self.bounds.size;
    self.maskView.top = 0;
    self.maskView.right = -self.maskView.width;
    
    self.maskView.backgroundColor = [UIColor redColor];
    
    [self addSubview:self.maskView];
}

- (void)setProgressBackgroundColor:(UIColor *)progressBackgroundColor{
    
    self.maskView.backgroundColor = progressBackgroundColor;
}

- (void)setProgress:(float)progress{

    self.maskView.right = progress * self.width;
    [self layoutIfNeeded];
}

@end
