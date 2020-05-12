//
//  TopSerchCollectionViewCell.m
//  CMPLjhMobile
//
//  Created by Liyanjun on 2017/3/27.
//  Copyright © 2017年 CMP_Ljh. All rights reserved.
//

#import "VideoCollectionViewCell.h"
static NSString* const CollectionCellId=@"VideoCollectionViewCellId";

@interface VideoCollectionViewCell()

@property (nonatomic, strong)UIView *containView;

@property (nonatomic, strong)UILabel *contentLable;


@end

@implementation VideoCollectionViewCell

#pragma mark - 类方法
+ (NSString *)registerCellID{
    
    return CollectionCellId;
}


#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


#pragma mark - 初始化

- (void)initialization{
    
    [self setupUi];
    
}


#pragma mark -- setupUi

- (void)setupUi{
    
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _imageView = [[UIImageView alloc] init];
    _imageView.top = 0;
    _imageView.left = 0;
    _imageView.size = [UIView getSize_width:self.width height:self.height];
    _imageView.backgroundColor = ColorThemeGray;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds=true;
    [self.contentView addSubview:_imageView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)ColorClear.CGColor, (__bridge id)ColorBlackAlpha20.CGColor, (__bridge id)ColorBlackAlpha60.CGColor];
    gradientLayer.locations = @[@0.3, @0.6, @1.0];
    gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
    gradientLayer.frame = CGRectMake(0, self.frame.size.height - 100, self.frame.size.width, 100);
    [_imageView.layer addSublayer:gradientLayer];
    
    _favoriteNum = [[UIButton alloc] init];
    [_favoriteNum setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_favoriteNum setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
    [_favoriteNum setTitle:@"0" forState:UIControlStateNormal];
    [_favoriteNum setTitleColor:ColorWhite forState:UIControlStateNormal];
    _favoriteNum.titleLabel.font = SmallFont;
    [_favoriteNum setImage:[UIImage imageNamed:@"icon_home_likenum"] forState:UIControlStateNormal];
    [_favoriteNum setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
    [self.contentView addSubview:_favoriteNum];
    
//    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
//    [_favoriteNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(10);
//        make.bottom.right.equalTo(self.contentView).inset(10);
//    }];
    
    
}

- (void)fillDataWithModel:(HomeListModel *)model{
    
    self.listModel = model;
    
    NSRange range = [model.noodleVideoCover rangeOfString:@"f_webp"];
    if(range.location != NSNotFound){
        model.noodleVideoCover =  [model.noodleVideoCover stringByReplacingCharactersInRange:range withString:@"f_png"];
    }
    
    
    NSRange range2 = [model.noodleVideoCover rangeOfString:@"//"];
    if(range2.location != NSNotFound && ![model.noodleVideoCover hasPrefix:@"http://"]){
        model.noodleVideoCover = [NSString stringWithFormat:@"http:%@",model.noodleVideoCover];
    }
    NSRange range3 = [model.noodleVideoCover rangeOfString:@"@"];
    if(range3.location != NSNotFound){
        //去掉 @ 及其以后的 字符
        //http://publish-pic-cpu.baidu.com/4f9edf42-aba3-47e4-bb7b-587d54484630.jpeg@w_544,h_960|c_1,x_2,y_0,w_540,h_960
        
        //model.noodleVideoCover = [NSString stringWithFormat:@"http:%@",model.noodleVideoCover];
        
        model.noodleVideoCover = [model.noodleVideoCover substringToIndex:range3.location];
        
        NSLog(@"-----");
    }
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.noodleVideoCover]
                 placeholderImage:[UIImage imageNamed:@"actitvtiyDefout"]];
    [self.favoriteNum setTitle:[NSString formatCount:[model.likeSum integerValue]] forState:UIControlStateNormal];
    
    
    
//    self.titleLalbe.text = model.topicName;
//    self.useCountLalbe.text = [NSString stringWithFormat:@"%@次播放",[NSString formatCount:[model.playSum integerValue]]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.imageView setImage:nil];
}


@end
