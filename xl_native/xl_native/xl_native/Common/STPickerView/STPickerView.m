//
//  STPickerView.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/17.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerView.h"

#define STScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define STScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

@interface STPickerView()
@property (nonatomic, assign, getter=isIphonePlus)BOOL iphonePlus;
@end

@implementation STPickerView

#pragma mark - --- init 视图初始化 ---


- (instancetype)initWithFeame:(CGRect)frame
{
    self = [super init];
    if (self) {
        [self setupDefault:frame];
        [self setupUI];
    }
    return self;
}


- (void)setupDefault:(CGRect)frame
{
    // 1.设置数据的默认值
    _title             = nil;
    _font              = [UIFont systemFontOfSize:17];
    _titleColor        = [UIColor blackColor];
//    _borderButtonColor = [UIColor colorWithRed:205.0/255 green:205.0/255 blue:205.0/255 alpha:1] ;
    
    _borderButtonColor = [UIColor whiteColor];
    _heightPicker      = 200;
    
    // 2.设置自身的属性
    self.bounds = frame;
    
    
    self.backgroundColor =  ColorThemeBackground;//[UIColor colorWithRed:0 green:0 blue:0 alpha:102.0/255];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // 3.添加子视图
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.pickerView];
    [self.contentView addSubview:self.labelTitle];
    [self.contentView addSubview:self.lineViewDown];
}

- (void)setupUI
{}

#pragma mark - --- private methods 私有方法 ---


- (void)showWithFrame:(CGRect)frame parentView:(UIView*)parentView{

    [parentView addSubview:self];
    self.frame = frame;
    self.contentView.frame = frame;
//    [self.layer setOpacity:0.5];
}

#pragma mark - --- setters 属性 ---

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.labelTitle setText:title];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [self.labelTitle setFont:font];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self.labelTitle setTextColor:titleColor];
}

- (void)setBorderButtonColor:(UIColor *)borderButtonColor
{
    _borderButtonColor = borderButtonColor;
}

- (void)setHeightPicker:(CGFloat)heightPicker
{
    _heightPicker = heightPicker;
    self.contentView.st_height = heightPicker;
}

#pragma mark - --- getters 属性 ---
- (UIView *)contentView
{
    if (!_contentView) {
        CGFloat contentX = 0;
        CGFloat contentY = 0;
        CGFloat contentW = STScreenWidth;
        CGFloat contentH = self.heightPicker;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(contentX, contentY, contentW, contentH)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _contentView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        CGFloat lineX = 0;
        CGFloat lineY = STControlSystemHeight;
        CGFloat lineW = self.contentView.st_width;
        CGFloat lineH = 0.5;
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        [_lineView setBackgroundColor:self.borderButtonColor];
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _lineView;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        CGFloat pickerW = self.contentView.st_width;
        CGFloat pickerH = self.contentView.st_height - self.lineView.st_bottom;
        CGFloat pickerX = 0;
        CGFloat pickerY = self.lineView.st_bottom;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerX, pickerY, pickerW, pickerH)];
        [_pickerView setBackgroundColor:ColorThemeBackground];
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _pickerView;
}

- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        CGFloat titleX =  STMarginSmall;
        CGFloat titleY = 0;
        CGFloat titleW = self.contentView.st_width - titleX * 2;
        CGFloat titleH = self.lineView.st_top;
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        [_labelTitle setTextAlignment:NSTextAlignmentCenter];
        [_labelTitle setTextColor:self.titleColor];
        [_labelTitle setFont:self.font];
        _labelTitle.adjustsFontSizeToFitWidth = YES;
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _labelTitle;
}

- (UIView *)lineViewDown
{
    if (!_lineViewDown) {
        CGFloat lineX = 0;
        CGFloat lineY = self.pickerView.st_bottom;
        CGFloat lineW = self.contentView.st_width;
        CGFloat lineH = 0.5;
        _lineViewDown = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        [_lineViewDown setBackgroundColor:self.borderButtonColor];
        _lineViewDown.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _lineViewDown;
}

- (BOOL)isIphonePlus{
    return (CGRectGetHeight([UIScreen mainScreen].bounds) >= 736) |
    (CGRectGetWidth([UIScreen mainScreen].bounds) >= 736);
}

@end

