//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "SearchResultSubMusicCell.h"

static NSString* const ViewTableViewCellId = @"SearchResultSubMusicCellId";


@implementation SearchResultSubMusicCell


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
    self.viewBg.size = [UIView getSize_width:ScreenWidth height:SearchResultSubMusicCellHeight];
    self.viewBg.origin = [UIView getPoint_x:0 y:0];
    [self.viewBg setBackgroundColor:ColorThemeBackground forState:UIControlStateNormal];
    [self.viewBg setBackgroundColor:RGBAlphaColor(29, 32, 42, 1) forState:UIControlStateHighlighted];
    
    [self.viewBg addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.viewBg];

    self.imageVeiwIcon = [[UIImageView alloc]init];
    self.imageVeiwIcon.size = [UIView getSize_width:SearchResultSubMusicCellHeight/5*3
                                             height:SearchResultSubMusicCellHeight/5*3];
    self.imageVeiwIcon.origin = [UIView getPoint_x:10 y:(self.viewBg.height - self.imageVeiwIcon.height)/2];
    
    self.imageVeiwIcon.layer.cornerRadius = 3.0f;
    self.imageVeiwIcon.layer.borderColor = ColorWhiteAlpha80.CGColor;
    self.imageVeiwIcon.layer.borderWidth = 0.0;
    [self.imageVeiwIcon.layer setMasksToBounds:YES];
    self.imageVeiwIcon.userInteractionEnabled = YES;
    
    [self.viewBg addSubview:self.imageVeiwIcon];
    

    self.labelTitle = [[UILabel alloc]init];
    self.labelTitle.size = [UIView getSize_width:200 height:20];
    self.labelTitle.origin = [UIView getPoint_x:self.imageVeiwIcon.right+10 y:18];
    self.labelTitle.font = BigBoldFont;
    self.labelTitle.textColor = ColorWhite;
    [self.viewBg addSubview:self.labelTitle];

    self.labelSign = [[UILabel alloc]init];
    self.labelSign.size = [UIView getSize_width:220 height:20];
    self.labelSign.origin = [UIView getPoint_x:self.labelTitle.left y:self.labelTitle.bottom+5];
    self.labelSign.font = SmallFont;
    self.labelSign.textColor = ColorWhiteAlpha60;
    [self.viewBg addSubview:self.labelSign];
    
    
    self.lableuseCount = [[UILabel alloc] init];
    self.lableuseCount.size = [UIView getSize_width:120 height:30];
    self.lableuseCount.right = ScreenWidth - 10;
    self.lableuseCount.top = (SearchResultSubMusicCellHeight - self.lableuseCount.height)/2;
    self.lableuseCount.font = SmallFont;
    self.lableuseCount.clipsToBounds = YES;
    self.lableuseCount.textColor = ColorWhiteAlpha60;
    self.lableuseCount.textAlignment = NSTextAlignmentRight;
    [self.viewBg addSubview:self.lableuseCount];
    
    //test
//    self.lableuseCount.backgroundColor = [UIColor redColor];
}
- (void)fillDataWithModel:(GetFuzzyMusicListModel *)model withKeyWord:(NSString*)withKeyWord{
    
    self.listModel = model;
    [self.imageVeiwIcon sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"img_find_default"]];
    
    [GlobalFunc setContentLabelColor:model.name.trim
                              subStr:withKeyWord
                            subColor:[UIColor yellowColor]
                        contentLabel:self.labelTitle];
    
    
    [GlobalFunc setContentLabelColor:model.nickname.trim
                              subStr:withKeyWord
                            subColor:[UIColor yellowColor]
                        contentLabel:self.labelSign];
    
    self.lableuseCount.text = [NSString stringWithFormat:@"%@人使用",[NSString formatCount:[model.hotCount integerValue]]];
}


- (void)btnDelClick:(id)sender{
    
    if ([self.subCellDelegate respondsToSelector:@selector(btnCellClick:)]) {
        [self.subCellDelegate btnCellClick:self.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

@end
