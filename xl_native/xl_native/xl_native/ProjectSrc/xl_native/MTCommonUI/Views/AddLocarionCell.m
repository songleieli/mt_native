//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "AddLocarionCell.h"

@implementation LocaltionModel

@end

static NSString* const ViewTableViewCellId = @"AddLocarionCellId";


@implementation AddLocarionCell


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
    self.viewBg.size = [UIView getSize_width:ScreenWidth height:AddLocarionCellHeight];
    self.viewBg.origin = [UIView getPoint_x:0 y:0];
    [self.viewBg setBackgroundColor:ColorThemeBackground forState:UIControlStateNormal];
    [self.viewBg setBackgroundColor:RGBAlphaColor(29, 32, 42, 1) forState:UIControlStateHighlighted];
    
    [self.viewBg addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.viewBg];
    
        self.labelTitle = [[VUILable alloc]init];
    //宽度根据屏幕适配
    self.labelTitle.size = [UIView getSize_width:self.viewBg.width  - 30
                                          height:40];
    self.labelTitle.left = 20;
    self.labelTitle.bottom = self.viewBg.height/2 - 5;
    self.labelTitle.font = BigBoldFont;
    self.labelTitle.verticalAlignment = VerticalAlignmentBottom;
    self.labelTitle.textColor = ColorWhite;
    [self.viewBg addSubview:self.labelTitle];
    
    //test
    self.labelSign = [[VUILable alloc]init];
    self.labelSign.size = [UIView getSize_width:self.labelTitle.width height:30];
    self.labelSign.origin = [UIView getPoint_x:self.labelTitle.left y:self.viewBg.height/2 + 5];
    self.labelSign.font = SmallFont;
    self.labelSign.textColor = ColorWhiteAlpha80;
    self.labelSign.verticalAlignment = VerticalAlignmentTop;
    [self.viewBg addSubview:self.labelSign];
}
- (void)fillDataWithModel:(LocaltionModel *)listModel withKeyWord:(NSString*)withKeyWord{
    
    self.listModel = listModel;
    
    if(withKeyWord.length > 0){
        NSString *content = listModel.name;
        [GlobalFunc setContentLabelColor:content
                                  subStr:withKeyWord
                                subColor:[UIColor yellowColor]
                            contentLabel:self.labelTitle];
        
        NSString *signature = listModel.adress.length == 0?@"暂时还没有签名":listModel.adress;
        [GlobalFunc setContentLabelColor:signature
                                  subStr:withKeyWord
                                subColor:[UIColor yellowColor]
                            contentLabel:self.labelSign];
    }
    else{
        self.labelTitle.text = listModel.name;
        
        self.labelSign.text = listModel.adress;
    }
}




- (void)btnDelClick:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(btnClicked:cell:)]) {
        [self.delegate btnClicked:sender cell:self];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}


-(void)btnCollectionClick{
    

    
    
    
    
    
}


@end
