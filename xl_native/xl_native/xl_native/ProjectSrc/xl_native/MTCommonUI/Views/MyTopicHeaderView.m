//
//  MYHeaderView.m
//  CMPLjhMobile
//
//  Created by lei song on 16/7/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "MyTopicHeaderView.h"

@implementation MyTopicHeaderView


- (UILabel*)lableTopicIcon{
    
    if (!_lableTopicIcon) {
        _lableTopicIcon = [[UILabel alloc] init];
        _lableTopicIcon.font = [UIFont defaultFontWithSize:74];
        _lableTopicIcon.textColor = [UIColor whiteColor];
        _lableTopicIcon.size = [UIView getSize_width:120 height:120];
        _lableTopicIcon.textAlignment = NSTextAlignmentCenter;
        _lableTopicIcon.text = @"#";
        _lableTopicIcon.backgroundColor = RGBA(54, 58, 67, 1);
        _lableTopicIcon.origin = [UIView getPoint_x:15 y:15];
        
        //test
//        _lableTopicIcon.backgroundColor = [UIColor greenColor];
    }
    return _lableTopicIcon;
}
- (UILabel*)lableTopicName{
    
    if (!_lableTopicName) {
        _lableTopicName = [[UILabel alloc] init];
        _lableTopicName.font = [UIFont defaultBoldFontWithSize:25];
        _lableTopicName.textColor = [UIColor whiteColor];
        _lableTopicName.size = [UIView getSize_width:self.width - self.lableTopicIcon.width - 15*3 height:30];
        _lableTopicName.textAlignment = NSTextAlignmentLeft;
        _lableTopicName.origin = [UIView getPoint_x:self.lableTopicIcon.right + 15 y:15];
    }
    return _lableTopicName;
}
- (UILabel*)lablePlayCount{
    
    if (!_lablePlayCount) {
        _lablePlayCount = [[UILabel alloc]init];
        _lablePlayCount.size = [UIView getSize_width:220 height:35];
        _lablePlayCount.origin = [UIView getPoint_x:self.lableTopicName.left y:self.lableTopicName.bottom];
        _lablePlayCount.font = [UIFont defaultFontWithSize:14];
        _lablePlayCount.textColor = RGBA(120, 122, 132, 1);
    }
    return _lablePlayCount;
}

- (UIButton*)btnCollectionBg{
    
    if (!_btnCollectionBg) {
        _btnCollectionBg = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCollectionBg.size = [UIView getSize_width:85 height:25];
        _btnCollectionBg.origin = [UIView getPoint_x:self.lableTopicName.left y:self.lablePlayCount.bottom];
        [_btnCollectionBg setBackgroundColor:RGBA(54, 58, 67, 1) forState:UIControlStateNormal];
        [_btnCollectionBg setBackgroundColor:RGBA(120, 122, 132, 1) forState:UIControlStateHighlighted];
        _btnCollectionBg.layer.cornerRadius = 2.0f;
        _btnCollectionBg.layer.masksToBounds = true;//给按钮添加边框效果
        [_btnCollectionBg addSubview:self.imageViewCollectionIcon];
        [_btnCollectionBg addSubview:self.lableCollectionTitle];
        [_btnCollectionBg addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCollectionBg;
}

- (UIImageView*)imageViewCollectionIcon{
    
    if (!_imageViewCollectionIcon) {
        _imageViewCollectionIcon = [[UIImageView alloc] init];
        _imageViewCollectionIcon.size = [UIView getSize_width:12.5 height:12.5];
        _imageViewCollectionIcon.origin = [UIView getPoint_x:(_btnCollectionBg.width - _imageViewCollectionIcon.width)/2 - _imageViewCollectionIcon.width-2
                                                           y:(_btnCollectionBg.height - _imageViewCollectionIcon.height)/2];
        _imageViewCollectionIcon.image = [UIImage imageNamed:@"icon_home_all_share_collention"];
    }
    return _imageViewCollectionIcon;
}

- (UILabel*)lableCollectionTitle{
    
    if (!_lableCollectionTitle) {
        _lableCollectionTitle = [[UILabel alloc] init];
        _lableCollectionTitle.size = [UIView getSize_width:_btnCollectionBg.width/2 height:_btnCollectionBg.height];
        _lableCollectionTitle.origin = [UIView getPoint_x:self.imageViewCollectionIcon.right+5 y:0];
        _lableCollectionTitle.textColor = [UIColor whiteColor];
        _lableCollectionTitle.textAlignment = NSTextAlignmentLeft;
        _lableCollectionTitle.text = @"收藏";
        _lableCollectionTitle.font = [UIFont defaultFontWithSize:12];
        
        //test
//        _lableCollectionTitle.backgroundColor = [UIColor redColor];
    }
    return _lableCollectionTitle;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}


-(void)setUI{
    [self addSubview:self.lableTopicIcon];
    [self addSubview:self.lableTopicName];
    [self addSubview:self.lablePlayCount];
    
    [self addSubview:self.btnCollectionBg];
}


- (void)initData:(GetHotVideosByTopicModel *)topicModel {
    
    NSLog(@"-----------");
    
    self.topicModel = topicModel;
    
    self.lableTopicName.text = topicModel.topic;
    self.lablePlayCount.text = [NSString formatCount:[topicModel.playSum integerValue]];
    if([topicModel.isCollect integerValue] == 1){
        self.lableCollectionTitle.text = @"已收藏";
    }
    else{
        self.lableCollectionTitle.text = @"收藏";
    }
}

#pragma -mark --------- 点击事件 ------------
-(void)btnClick:(UIButton*)btn{
    
    if ([self.delegate respondsToSelector:@selector(btnCollectionClick:)]) {
        [self.delegate btnCollectionClick:self.topicModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

@end
