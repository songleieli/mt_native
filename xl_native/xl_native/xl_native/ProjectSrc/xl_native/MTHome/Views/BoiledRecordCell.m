//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BoiledRecordCell.h"

static NSString* const BoiledRecordCellId = @"BoiledRecordCellId";


@implementation BoiledRecordCell


#pragma mark - 类方法
+ (NSString*) cellId{
    return BoiledRecordCellId;
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
    self.viewBg.size = [UIView getSize_width:ScreenWidth height:BoiledRecordCellHeight];
    self.viewBg.origin = [UIView getPoint_x:0 y:0];
    [self.viewBg setBackgroundColor:ColorThemeBackground forState:UIControlStateNormal];
    [self.viewBg setBackgroundColor:RGBAlphaColor(29, 32, 42, 1) forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.viewBg];

    
    self.labelTitle = [[UILabel alloc]init];
    self.labelTitle.size = [UIView getSize_width:200 height:20];
    self.labelTitle.left = sizeScale(15);
    self.labelTitle.centerY = BoiledRecordCellHeight/2;
    self.labelTitle.font = [UIFont defaultBoldFontWithSize:15];
    self.labelTitle.textColor = MTColorTitle;
    [self.viewBg addSubview:self.labelTitle];

    self.labelSign = [[UILabel alloc]init];
    self.labelSign.size = [UIView getSize_width:100 height:20];
    self.labelSign.centerY = self.labelTitle.centerY;
    self.labelSign.right = self.viewBg.width - 15;
    self.labelSign.textAlignment = NSTextAlignmentRight;
    
    self.labelSign.font = [UIFont defaultFontWithSize:14];
    self.labelSign.textColor = MTColorDesc;
    [self.viewBg addSubview:self.labelSign];

}
- (void)fillDataWithModel:(BoiledRecordModel *)model{
    
    self.listModel = model;
    self.labelTitle.text = [NSString stringWithFormat:@"%@",model.money];
    NSDate *date = [GlobalFunc getDateWithTimeStr:model.endTime];
    self.labelSign.text = [GlobalFunc getTimeWithFormatter:date formattter:@"yy-MM-dd"];
}

@end
