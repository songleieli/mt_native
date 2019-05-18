//
//  NewProjectView.m
//  JrLoanMobile
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 Junrongdai. All rights reserved.
//

#import "CTProdectView.h"
#import "UIButton+Create.h"


@implementation CTProdectItemModel

@end


@interface CTProdectView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView *imgIcon;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) NSArray *source;

@end

@implementation CTProdectView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


-(void)reloadWithSource:(NSArray*)source rowCount:(NSInteger) rowCount{
    if (source.count == 0) {
        return;
    }
    
    self.source = source;
    [self removeAllSubviews];
    
//    NSInteger rowCount = rowCount;
    NSInteger modular = self.source.count%rowCount;
    NSInteger row = self.source.count/rowCount;

    if(modular > 0){
        row = row+1;
    }
    //计算当前页的高度
    CGFloat cellWidth = self.width/rowCount; //正方形，高等于宽
    CGFloat cellHeight = self.height/row; //正方形，高等于宽

    self.height = cellHeight*row;

    for(int i=0; i<row;i++){
        for(int j=0;j<rowCount;j++){
            
            NSInteger index = i*rowCount+j;
            UIButton *btnSub = [UIButton buttonWithType:UIButtonTypeCustom];
            btnSub.tag = i*rowCount+j;
            btnSub.size = [UIView getSize_width:cellWidth height:cellHeight];
            btnSub.origin = [UIView getPoint_x:j*cellWidth y:i*cellHeight];
//            btnSub.layer.borderWidth = 0.25;
            btnSub.layer.borderWidth = 0.0;
//            btnSub.layer.borderColor = defaultLineColor.CGColor;
            [self addSubview:btnSub];
            
            if(index < self.source.count){
                
                [btnSub setBackgroundColor:RGBAlphaColor(239, 239, 243, 1) forState:UIControlStateHighlighted];
                [btnSub addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                CTProdectItemModel *model = [self.source objectAtIndex:index];
                UIImageView *imageView = [[UIImageView alloc]init];
                imageView.size = [UIView getScaleSize_width:40 height:40];
                imageView.origin = [UIView getPoint_x:(btnSub.width - imageView.width)/2
                                                    y:(btnSub.height - imageView.height)/2-10];
                imageView.image = [UIImage imageNamed:model.itemIcon];
                [btnSub addSubview:imageView];
                
                UILabel *lableFunctionTitle = [[UILabel alloc] init];
                lableFunctionTitle.size = [UIView getSize_width:btnSub.width height:sizeScale(20)];
                lableFunctionTitle.origin = [UIView getPoint_x:0 y:imageView.bottom + 5];
                lableFunctionTitle.textAlignment = NSTextAlignmentCenter;
                lableFunctionTitle.textColor = RGBFromColor(0x494949); //RGBAlphaColor(70, 73, 81, 1);
                lableFunctionTitle.font = [UIFont defaultFontWithSize:14];
                lableFunctionTitle.text = model.itemTitle;
                
                [btnSub addSubview:lableFunctionTitle];
            }
        }
    }
}

-(void)btnClick:(UIButton*)btn{
    //self.userInteractionEnabled = NO;
    CTProdectItemModel *item = [self.source objectAtIndex:btn.tag];
    if(self.blockClcik){
        self.blockClcik(item);
    }
}


@end
