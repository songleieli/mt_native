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


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}


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
    
    [self.contentView addSubview:self.containView];
    
    [self.contentView addSubview:self.contentLable];
   
    
    [self containViewF];

    
    [self contentLableF];
    
    
    
    
}
#pragma mark - 懒加载

- (UILabel *)contentLable{


    if (!_contentLable) {
        _contentLable = [[UILabel alloc] init];
        
        _contentLable.font = [UIFont defaultFontWithSize:MasScale_1080(33)];
        
        _contentLable.textColor = NavLableColor;
        
        
        _contentLable.textAlignment = NSTextAlignmentCenter;
        

        
    }

    return _contentLable;
}

- (void)contentLableF{

    [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.mas_equalTo(_containView);
    

    }];

}



- (UIView *)containView{


    if (!_containView) {
        _containView = [[UIView alloc] init];
        
        _containView.backgroundColor = RGBFromColor(0xeaeef7);
        
        
        _containView.layer.masksToBounds = YES;
        
        _containView.layer.cornerRadius = MasScale_1080(28);

        
    }
    
    return _containView;
    

}


- (void)containViewF{


    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.contentView.mas_top).offset(0);
      
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(MasScale_1080(0));
        
        make.height.mas_equalTo(MasScale_1080(60));
        make.width.mas_equalTo(MasScale_1080(300));
       
    }];


}


#pragma mark - 实例方法


- (void)dataBind:(NSString *)titleStr{


    self.contentLable.text = titleStr;

}

#pragma mark - 类方法
+ (NSString *)registerCellID
{
    
    return CollectionCellId;
    
}




#pragma mark  - delegate



@end
