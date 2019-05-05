//
//  AwemeCollectionCell.m
//  Douyin
//
//  Created by songleilei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import "SearchResultSubVideoCollectionCell.h"
//#import "WebPImageView.h"
//#import "Aweme.h"
#import "AwemesResponse.h"

@implementation SearchResultSubVideoCollectionCell


//封面
- (UIImageView *) imageView{
    if (_imageView == nil){
        
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.bounds;
        _imageView.backgroundColor = ColorThemeGray;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        //底部添加 100 的距离添加渐变阴影
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)ColorClear.CGColor, (__bridge id)ColorBlackAlpha20.CGColor, (__bridge id)ColorBlackAlpha60.CGColor];
        gradientLayer.locations = @[@0.3, @0.6, @1.0];
        gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
        gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
        gradientLayer.frame = CGRectMake(0, _imageView.size.height - 200, _imageView.size.width, 200);
        [_imageView.layer addSublayer:gradientLayer];
    }
    return _imageView;
}

//用户头像
- (UIImageView *) imageViewUser{
    if (_imageViewUser == nil){
        
        _imageViewUser = [[UIImageView alloc] init];
        _imageViewUser.size = [UIView getSize_width:22 height:22];
        _imageViewUser.left = 5;
        _imageViewUser.bottom = self.imageView.height - (self.favoriteNum.height-_imageViewUser.height)/2;
        _imageViewUser.backgroundColor = ColorThemeGray;
        _imageViewUser.contentMode = UIViewContentModeScaleAspectFill;
        
        _imageViewUser.layer.cornerRadius = _imageViewUser.width/2;
        _imageViewUser.layer.borderColor = ColorWhiteAlpha80.CGColor;
        _imageViewUser.layer.borderWidth = 1;
        [_imageViewUser.layer setMasksToBounds:YES];
    }
    return _imageViewUser;
}

//用户昵称
- (UILabel *) labelNickName{
    if (_labelNickName == nil){
        
        _labelNickName = [[UILabel alloc]init];
        _labelNickName.size = [UIView getSize_width:200 height:self.favoriteNum.height];
        _labelNickName.origin = [UIView getPoint_x:self.imageViewUser.right+5 y:self.favoriteNum.top];
        _labelNickName.font = SmallFont;
        _labelNickName.textColor = ColorWhiteAlpha80;
    }
    return _labelNickName;
}

- (UILabel *) labelDesc{
    if (_labelDesc == nil){ //
        _labelDesc = [[UILabel alloc]init];
        _labelDesc.numberOfLines = 0;
        _labelDesc.textColor = ColorWhite;
        _labelDesc.font = MediumBoldFont;
        _labelDesc.left = 5;
        _labelDesc.bottom = self.favoriteNum.top;
        _labelDesc.width = self.imageView.width-10;
    }
    return _labelDesc;
}



- (UIButton *) favoriteNum{
    if (_favoriteNum == nil){
        
        _favoriteNum = [[UIButton alloc] init];
        _favoriteNum.size = [UIView getSize_width:100 height:25];
        _favoriteNum.right = self.imageView.width - 10;
        _favoriteNum.bottom = self.imageView.height;
        [_favoriteNum setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_favoriteNum setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
        [_favoriteNum setTitle:@"0" forState:UIControlStateNormal];
        [_favoriteNum setTitleColor:ColorWhite forState:UIControlStateNormal];
        _favoriteNum.titleLabel.font = SmallFont;
        [_favoriteNum setImage:[UIImage imageNamed:@"icon_home_likenum"] forState:UIControlStateNormal];
        [_favoriteNum setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
        
        //test
//        _favoriteNum.backgroundColor = [UIColor redColor];
    }
    return _favoriteNum;
}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        self.clipsToBounds = YES;
        
        
        [self setupUI];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:NO];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.imageView setImage:nil];
}

-(void)setupUI{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.imageViewUser];
    [self.contentView addSubview:self.labelNickName];
    [self.contentView addSubview:self.favoriteNum];
    [self.contentView addSubview:self.labelDesc];
}

- (void)initData:(HomeListModel *)aweme  withKeyWord:(NSString*)withKeyWord{
    
    NSRange range = [aweme.noodleVideoCover rangeOfString:@"f_webp"];
    if(range.location != NSNotFound){
        aweme.noodleVideoCover =  [aweme.noodleVideoCover stringByReplacingCharactersInRange:range withString:@"f_png"];
    }
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:aweme.noodleVideoCover] placeholderImage:[UIImage imageNamed:@"default_bg_cover"]];
    [self.imageViewUser sd_setImageWithURL:[NSURL URLWithString:aweme.head] placeholderImage:[UIImage imageNamed:@"user_default_icon"]];
    
    self.labelNickName.text = aweme.nickname;
    [self.favoriteNum setTitle:[NSString formatCount:[aweme.likeSum integerValue]] forState:UIControlStateNormal];
    
    CGRect contentLabelSize = [aweme.title boundingRectWithSize:CGSizeMake(self.labelDesc.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelDesc.font,NSFontAttributeName, nil] context:nil];
    self.labelDesc.height = contentLabelSize.size.height;
    
    self.labelDesc.bottom = self.favoriteNum.top;
    
    [GlobalFunc setContentLabelColor:aweme.title.trim
                              subStr:withKeyWord
                            subColor:[UIColor yellowColor]
                        contentLabel:self.labelDesc];
}

@end
