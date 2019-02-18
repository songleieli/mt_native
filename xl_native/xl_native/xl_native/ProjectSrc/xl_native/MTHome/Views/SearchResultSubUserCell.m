//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "SearchResultSubUserCell.h"

static NSString* const ViewTableViewCellId = @"SearchResultSubUserCellId";


@implementation SearchResultSubUserCell


#pragma mark - 类方法
+ (NSString*) cellId{
    return ViewTableViewCellId;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.viewBg = [UIButton buttonWithType:UIButtonTypeCustom];
    self.viewBg.size = [UIView getSize_width:ScreenWidth height:SearchResultSubUserCellHeight];
    self.viewBg.origin = [UIView getPoint_x:0 y:0];
    [self.viewBg setBackgroundColor:ColorThemeBackground forState:UIControlStateNormal];
    [self.viewBg setBackgroundColor:RGBAlphaColor(29, 32, 42, 1) forState:UIControlStateHighlighted];
    
    [self.viewBg addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.viewBg];

    self.imageVeiwIcon = [[UIImageView alloc]init];
    self.imageVeiwIcon.size = [UIView getSize_width:SearchResultSubUserCellHeight/5*3 height:SearchResultSubUserCellHeight/5*3];
    self.imageVeiwIcon.origin = [UIView getPoint_x:10 y:(self.viewBg.height - self.imageVeiwIcon.height)/2];
    
    self.imageVeiwIcon.layer.cornerRadius = self.imageVeiwIcon.width/2;
    self.imageVeiwIcon.layer.borderColor = ColorWhiteAlpha80.CGColor;
    self.imageVeiwIcon.layer.borderWidth = 0.0;
    [self.imageVeiwIcon.layer setMasksToBounds:YES];
    self.imageVeiwIcon.userInteractionEnabled = YES;
    
    [self.viewBg addSubview:self.imageVeiwIcon];
    

    self.labelTitle = [[UILabel alloc]init];
    self.labelTitle.size = [UIView getSize_width:200 height:20];
    self.labelTitle.origin = [UIView getPoint_x:self.imageVeiwIcon.right+10 y:18];
    self.labelTitle.font = [UIFont defaultBoldFontWithSize:15];
    self.labelTitle.textColor = [UIColor whiteColor];
    [self.viewBg addSubview:self.labelTitle];

    self.labelSign = [[UILabel alloc]init];
    self.labelSign.size = [UIView getSize_width:220 height:20];
    self.labelSign.origin = [UIView getPoint_x:self.labelTitle.left y:self.labelTitle.bottom+5];
    self.labelSign.font = [UIFont defaultFontWithSize:14];
    self.labelSign.textColor = RGBA(120, 122, 132, 1);
    [self.viewBg addSubview:self.labelSign];
    
    
    self.focusButton = [[UIButton alloc] init];
    self.focusButton.size = [UIView getSize_width:80 height:30];
    self.focusButton.right = ScreenWidth - 15;
    self.focusButton.top = (SearchResultSubUserCellHeight - self.focusButton.height)/2;
    [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.focusButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    self.focusButton.titleLabel.font = [UIFont defaultFontWithSize:14];
    self.focusButton.clipsToBounds = YES;
    [self.focusButton setImage:[UIImage imageNamed:@"icon_personal_add_little"] forState:UIControlStateNormal];
    [self.focusButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
    self.focusButton.layer.backgroundColor = ColorThemeRed.CGColor;
    self.focusButton.layer.cornerRadius = 2;
    [self.viewBg addSubview:self.focusButton];
}
- (void)fillDataWithModel:(GetFuzzyAccountListModel *)model{
    
    self.listModel = model;
    [self.imageVeiwIcon sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"img_find_default"]];
    
    self.labelTitle.text = [NSString stringWithFormat:@"@%@",model.nickname];
    self.labelSign.text = model.signature.length == 0?@"暂时还没有签名":model.signature;
}


- (void)btnDelClick:(id)sender{
    
    if ([self.subCellDelegate respondsToSelector:@selector(btnCellClick:)]) {
        [self.subCellDelegate btnCellClick:self.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

@end
