//
//  CLPlayerMaskView.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/2/24.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "MtHomeTopView.h"


@interface MtHomeTopView ()



@end

@implementation MtHomeTopView

#pragma mark -----------懒加载----------------

- (UIButton *)searchButton{
    if (_searchButton == nil){
        _searchButton = [[UIButton alloc] init];
        _searchButton.size = [UIView getSize_width:23 height:23];
        _searchButton.origin = [UIView getPoint_x:20 y:self.height - _searchButton.height-20];
        [_searchButton setImage:[BundleUtil getCurrentBundleImageByName:@"icon_m_search"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}


- (UIButton *)recommendButton{
    if (_recommendButton == nil){
        _recommendButton = [[UIButton alloc] init];
        _recommendButton.size = [UIView getSize_width:40 height:23];
        _recommendButton.origin = [UIView getPoint_x:self.width/2 - _recommendButton.width -10
                                                   y:self.height - _recommendButton.height-20];
        _recommendButton.titleLabel.font = [UIFont defaultBoldFontWithSize:18];
        [_recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
        [_recommendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recommendButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

        [_recommendButton addTarget:self action:@selector(recommendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recommendButton;
}

- (UIButton *)cityButton{
    if (_cityButton == nil){
        _cityButton = [[UIButton alloc] init];
        _cityButton.size = [UIView getSize_width:40 height:23];
        _cityButton.origin = [UIView getPoint_x:self.width/2 + 10
                                                   y:self.height - _cityButton.height-20];
        _cityButton.titleLabel.font = [UIFont defaultBoldFontWithSize:18];
        [_cityButton setTitle:@"北京" forState:UIControlStateNormal];
        [_cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cityButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_cityButton addTarget:self action:@selector(cityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cityButton;
}

- (UIButton *)refreshButton{
    if (_refreshButton == nil){
        
        CGFloat scal = (CGFloat)64/29;
        
        _refreshButton = [[UIButton alloc] init];
        _refreshButton.size = [UIView getSize_width:25 height:25/scal];
        _refreshButton.origin = [UIView getPoint_x:self.width - _refreshButton.width-15
                                                 y:self.height - _refreshButton.height-25];
        [_refreshButton setImage:[BundleUtil getCurrentBundleImageByName:@"icon_m_list"] forState:UIControlStateNormal];
        //        [_searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

- (UIButton *)scanButton{
    
    if (_scanButton == nil){
        _scanButton = [[UIButton alloc] init];
        _scanButton.size = [UIView getSize_width:20 height:20];
        _scanButton.origin = [UIView getPoint_x:self.refreshButton.left - _scanButton.width - 15
                                              y:self.height - _scanButton.height-20];
        [_scanButton setImage:[BundleUtil getCurrentBundleImageByName:@"icon_m_scan"] forState:UIControlStateNormal];
        [_scanButton addTarget:self action:@selector(scanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}




-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    
//    self.backgroundColor = RGBAlphaColor(0, 0, 0, 0.5);
//    [self addSubview:self.scrollView];
    
    [self addSubview:self.searchButton];       //搜索按钮
    [self addSubview:self.recommendButton];    //推荐按钮
    [self addSubview:self.cityButton];         //城市按钮
    
    [self addSubview:self.refreshButton];      //刷新按钮
    [self addSubview:self.scanButton];         //扫描按钮
}

#pragma mark - 按钮点击事件

- (void)searchButtonAction:(id)sender{
    
    if ([self.mtHomeTopDelegate respondsToSelector:@selector(searchBtnClick)]) {
        [self.mtHomeTopDelegate searchBtnClick];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

- (void)recommendButtonAction:(id)sender{
    
    if ([self.mtHomeTopDelegate respondsToSelector:@selector(recommendBtnClick)]) {
        [self.mtHomeTopDelegate recommendBtnClick];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

- (void)cityButtonAction:(id)sender{
    
    if ([self.mtHomeTopDelegate respondsToSelector:@selector(cityBtnClick)]) {
        [self.mtHomeTopDelegate cityBtnClick];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}
- (void)scanButtonAction:(id)sender{
    
    if ([self.mtHomeTopDelegate respondsToSelector:@selector(scanBtnClick)]) {
        [self.mtHomeTopDelegate scanBtnClick];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

@end
