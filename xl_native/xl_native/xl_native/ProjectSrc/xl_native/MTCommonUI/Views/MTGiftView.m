//
//  NewProjectView.m
//  JrLoanMobile
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 Junrongdai. All rights reserved.
//

#import "MTGiftView.h"
#import "UIButton+Create.h"


@interface MTGiftView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView *imgIcon;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) NSArray *source;

@end

@implementation MTGiftView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
//            btnSub.layer.borderWidth = 0.5;
            [self addSubview:btnSub];
            
            if(index < self.source.count){
                
                UIImageView *imageView = [[UIImageView alloc]init];
                imageView.size = [UIView getScaleSize_width:20 height:20];
                imageView.origin = [UIView getPoint_x:sizeScale(10)
                                                    y:(btnSub.height - imageView.height)/2];
                imageView.image = [UIImage imageNamed:@"main_ad_gift"];
                [btnSub addSubview:imageView];
                
                UILabel *lableFunctionTitle = [[UILabel alloc] init];
                lableFunctionTitle.size = [UIView getSize_width:btnSub.width - imageView.right - 10  height:btnSub.height];
                lableFunctionTitle.top = 0;
                lableFunctionTitle.left = imageView.right+10;
                
                lableFunctionTitle.textAlignment = NSTextAlignmentCenter;
                lableFunctionTitle.textColor = [UIColor blackColor];
                lableFunctionTitle.font = [UIFont defaultFontWithSize:16];
                lableFunctionTitle.text = [self.source objectAtIndex:index];
                lableFunctionTitle.textAlignment = NSTextAlignmentLeft;
                //test
//                lableFunctionTitle.backgroundColor = [UIColor redColor];
                
                [btnSub addSubview:lableFunctionTitle];
            }
        }
    }
}


@end
