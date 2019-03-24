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
    
    
    self.focusButton = [[UIButton alloc] init];
    self.focusButton.size = [UIView getSize_width:sizeScale(60.0f) height:sizeScale(25.5f)];
    self.focusButton.right = ScreenWidth - 10;
    self.focusButton.top = (SearchResultSubUserCellHeight - self.focusButton.height)/2;
    [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.focusButton setTitleColor:ColorWhite forState:UIControlStateNormal];
    self.focusButton.titleLabel.font = MediumBoldFont;
    self.focusButton.clipsToBounds = YES;
    [self.focusButton setImage:[UIImage imageNamed:@"icon_personal_add_little"] forState:UIControlStateNormal];
    [self.focusButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
    [self.focusButton setBackgroundColor:MTColorBtnRedNormal forState:UIControlStateNormal];
    [self.focusButton setBackgroundColor:MTColorBtnRedHighlighted forState:UIControlStateHighlighted];
    self.focusButton.layer.cornerRadius = 2;
    [self.viewBg addSubview:self.focusButton];
    

    self.labelTitle = [[VUILable alloc]init];
    //宽度根据屏幕适配
    self.labelTitle.size = [UIView getSize_width:self.viewBg.width - self.imageVeiwIcon.right - self.focusButton.width - 30
                                          height:40];
    self.labelTitle.origin = [UIView getPoint_x:self.imageVeiwIcon.right+10 y:0];
    self.labelTitle.font = BigBoldFont;
    self.labelTitle.verticalAlignment = VerticalAlignmentBottom;
    self.labelTitle.textColor = ColorWhite;
    [self.viewBg addSubview:self.labelTitle];
    
    self.labelNoodleInfo = [[VUILable alloc]init];
    self.labelNoodleInfo.size = [UIView getSize_width:self.labelTitle.width height:20];
    self.labelNoodleInfo.origin = [UIView getPoint_x:self.labelTitle.left y:self.labelTitle.bottom];
    self.labelNoodleInfo.font = SmallFont;
    self.labelNoodleInfo.textColor = ColorWhiteAlpha80;
    self.labelNoodleInfo.verticalAlignment = VerticalAlignmentMiddle;
    [self.viewBg addSubview:self.labelNoodleInfo];
    
    //test

    self.labelSign = [[VUILable alloc]init];
    self.labelSign.size = [UIView getSize_width:self.labelTitle.width height:30];
    self.labelSign.origin = [UIView getPoint_x:self.labelTitle.left y:self.labelNoodleInfo.bottom];
    self.labelSign.font = SmallFont;
    self.labelSign.textColor = ColorWhiteAlpha80;
    self.labelSign.verticalAlignment = VerticalAlignmentTop;
    [self.viewBg addSubview:self.labelSign];
}
- (void)fillDataWithModel:(GetFuzzyAccountListModel *)listModel withKeyWord:(NSString*)withKeyWord{
    
    self.listModel = listModel;
    [self.imageVeiwIcon sd_setImageWithURL:[NSURL URLWithString:listModel.head] placeholderImage:[UIImage imageNamed:@"img_find_default"]];
    
    NSString *content = [NSString stringWithFormat:@"@%@",listModel.nickname];
    [GlobalFunc setContentLabelColor:content
                        subStr:withKeyWord
                      subColor:[UIColor yellowColor]
                  contentLabel:self.labelTitle];
    
    self.labelNoodleInfo.text = [NSString stringWithFormat:@"面条号:%@ 获赞:%@",listModel.noodleId,listModel.likeTotal];
    
    NSString *signature = listModel.signature.length == 0?@"暂时还没有签名":listModel.signature;
    [GlobalFunc setContentLabelColor:signature
                              subStr:withKeyWord
                            subColor:[UIColor yellowColor]
                        contentLabel:self.labelSign];
}




- (void)btnDelClick:(id)sender{
    
    if ([self.subCellDelegate respondsToSelector:@selector(btnCellClick:)]) {
        [self.subCellDelegate btnCellClick:self.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

@end
