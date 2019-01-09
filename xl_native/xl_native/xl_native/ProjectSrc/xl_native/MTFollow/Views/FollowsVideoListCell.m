//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "FollowsVideoListCell.h"

static NSString* const ViewTableViewCellId = @"FollowsVideoListCellId";


@implementation FollowsVideoListCell


#pragma mark - 类方法
+ (NSString*) cellId{
    return ViewTableViewCellId;
}


- (UIButton *)viewBg{
    if (_viewBg == nil){
        _viewBg = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewBg.size = [UIView getSize_width:ScreenWidth height:FollowsVideoListCellHeight];
        _viewBg.origin = [UIView getPoint_x:0 y:0];
        [_viewBg setBackgroundColor:ColorThemeBackground forState:UIControlStateNormal];
        [_viewBg setBackgroundColor:RGBAlphaColor(29, 32, 42, 1) forState:UIControlStateHighlighted];
    }
    return _viewBg;
}

- (UILabel *)labelLine{
    if (_labelLine == nil){
        _labelLine = [[UILabel alloc]init];
        _labelLine.size = [UIView getSize_width:ScreenWidth - 30 height:0.3];
        _labelLine.origin = [UIView getPoint_x:15 y:FollowsVideoListCellHeight - _labelLine.height];
        _labelLine.backgroundColor = [UIColor grayColor]; //RGBAlphaColor(222, 222, 222, 0.8);
    }
    return _labelLine;
}

- (UIImageView *)imageVeiwIcon{
    if (_imageVeiwIcon == nil){
        _imageVeiwIcon = [[UIImageView alloc]init];
        _imageVeiwIcon.size = [UIView getSize_width:30 height:30];
        _imageVeiwIcon.origin = [UIView getPoint_x:10 y:10];
        
        _imageVeiwIcon.layer.cornerRadius = self.imageVeiwIcon.width/2;
        _imageVeiwIcon.layer.borderColor = ColorWhiteAlpha80.CGColor;
        _imageVeiwIcon.layer.borderWidth = 0.0;
        [_imageVeiwIcon.layer setMasksToBounds:YES];
        _imageVeiwIcon.userInteractionEnabled = YES;
    }
    return _imageVeiwIcon;
}

- (UILabel *)labelUserName{
    if (_labelUserName == nil){
        _labelUserName = [[UILabel alloc]init];
        _labelUserName.size = [UIView getSize_width:200 height:20];
        _labelUserName.centerY = self.imageVeiwIcon.centerY;
        _labelUserName.left = self.imageVeiwIcon.right + 10;
        _labelUserName.font = [UIFont defaultBoldFontWithSize:12];
        _labelUserName.textColor = [UIColor whiteColor];
    }
    return _labelUserName;
}

- (UILabel *)labelTitle{
    if (_labelTitle == nil){
        _labelTitle = [[UILabel alloc]init];
        _labelTitle.size = [UIView getSize_width:FollowsVideoListCellTitleWidth height:20]; //宽度为屏幕的 718/1080
        _labelTitle.top = self.imageVeiwIcon.bottom + 10;
        _labelTitle.left = self.imageVeiwIcon.left;
        _labelTitle.font = FollowsVideoListCellTitleFont;
        _labelTitle.textColor = [UIColor whiteColor];
        _labelTitle.numberOfLines = 0;

    }
    return _labelTitle;
}





- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [self.contentView addSubview:self.viewBg];
    
    [self.viewBg addSubview:self.labelLine];
    [self.viewBg addSubview:self.imageVeiwIcon];
    [self.viewBg addSubview:self.labelUserName];
    [self.viewBg addSubview:self.labelTitle];
}
- (void)fillDataWithModel:(HomeListModel *)model{
    
    /*cell 的高度组成部分相加*/
    CGFloat cellHeight = FollowsVideoListCellIconHeight + model.fpllowVideoListTitleHeight + FollowsVideoListCellVideoHeight+FollowsVideoListCellBottomHeight;
    self.viewBg.height = cellHeight;
    self.labelLine.top = self.viewBg.height - self.labelLine.height;
    self.listModel = model;
    
    
    [self.imageVeiwIcon sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"img_find_default"]];
    self.labelUserName.text = [NSString stringWithFormat:@"@%@",model.nickname];
    self.labelTitle.height = model.fpllowVideoListTitleHeight;
    self.labelTitle.text = model.title;
    
    
    
    
    
    
}

- (void)btnDelClick:(id)sender{
    
//    if ([self.getFollowsDelegate respondsToSelector:@selector(btnDeleteClick:)]) {
//        [self.getFollowsDelegate btnDeleteClick:self.listModel];
//    } else {
//        NSLog(@"代理没响应，快开看看吧");
//    }
}

@end
