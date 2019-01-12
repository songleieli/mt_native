//
//  MyViewTableViewCell.m
//  CMPLjhMobile
//
//  Created by Liyanjun on 2017/6/26.
//  Copyright © 2017年 CMP_Ljh. All rights reserved.
//

#import "MyViewTableViewCell.h"

@implementation MyViewTableViewCellModel


@end


static NSString* const ViewTableViewCellId=@"MyViewTableViewCellId";

@interface MyViewTableViewCell()

@property (nonatomic, strong)UILabel *titleLalbe;//标题lable
@property (nonatomic,strong)UIImageView* imgView;//图片
@property (nonatomic, strong)UIView* lineView;//底部横线
@property (nonatomic, strong)UIImageView *narrowImg;//箭头

@end




@implementation MyViewTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier{
    
    self=[super initWithStyle: style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupUi];
    }
    return self;
}


#pragma mark - 懒加载

- (UIImageView *)imgView{
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.size = [UIView getScaleSize_width:14 height:14];
        _imgView.origin = [UIView getPoint_x:15 y:(MyViewTableViewCellHeight - _imgView.height)/2];
    }
    return _imgView;
}



- (UILabel*)titleLalbe{

    if (!_titleLalbe) {
        _titleLalbe = [[UILabel alloc] init];
        _titleLalbe.font = [UIFont defaultBoldFontWithSize:14];
        _titleLalbe.textColor = [UIColor whiteColor];
        _titleLalbe.size = [UIView getSize_width:150 height:30];
        _titleLalbe.origin = [UIView getPoint_x:self.imgView.right+15
                                              y:(MyViewTableViewCellHeight - _titleLalbe.height)/2];
    }
    return _titleLalbe;
}

- (UIImageView *)narrowImg{
    //narrow_gray
    if (!_narrowImg) {
        _narrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_m_s_right"]];
        _narrowImg.size = [UIView getSize_width:9 height:15];
        _narrowImg.origin = [UIView getPoint_x:ScreenWidth - _narrowImg.width - 15
                                             y:(MyViewTableViewCellHeight - _narrowImg.height)/2];
    }
    return _narrowImg;
}

- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor =  RGBA(132, 135, 144, 0.6);
        _lineView.size = [UIView getSize_width:ScreenWidth-15*2 height:0.5];
        _lineView.origin = [UIView getPoint_x:15 y:MyViewTableViewCellHeight-_lineView.height];
    }
    return _lineView;
    
}


#pragma mark - 设置UI

- (void)setupUi{
    
    self.contentView.backgroundColor = ColorThemeBackground;
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLalbe];
    [self.contentView addSubview:self.narrowImg];
    [self.contentView addSubview:self.lineView];
}


#pragma mark - 实例方法
- (void)dataBind:(MyViewTableViewCellModel*)model{
    
    self.imgView.image = [UIImage imageNamed:model.imageStr];
    self.titleLalbe.text = model.titleStr;
    self.lineView.hidden = !model.isShowLine;
}

#pragma mark - 类方法
+ (NSString*) cellId{
    return ViewTableViewCellId;
}


@end


