//
//  NewProjectView.m
//  JrLoanMobile
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 Junrongdai. All rights reserved.
//

#import "MTSearchHeadFunctionView.h"
#import "UIButton+Create.h"


//@implementation XLFunctionItemModel
//
//@end


@interface MTSearchHeadFunctionView () <UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *source;

@end

@implementation MTSearchHeadFunctionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor whiteColor];
        
        //初始化代码，写这里
    }
    
    return self;
}


-(void)reloadWithSource:(NSArray*)source dataLoadFinishBlock:(void(^)())dataLoadFinishBlock{
    if (source.count == 0) {
        return;
    }
    
    self.source = source;
    [self removeAllSubviews];
    
    NSInteger rowCount = 3;
    NSInteger modular = self.source.count%rowCount;
    NSInteger row = self.source.count/rowCount;
    
    if(modular > 0){
        row = row+1;
    }
    
    //计算当前页的高度
//    CGFloat scalwh = (CGFloat)171.5/273;//宽高比
    CGFloat width = (CGFloat)self.width/rowCount; //正方形，高等于宽
    CGFloat height = width; //正方形，高等于宽
    
    self.height = height*row;
    
    for(int i=0; i<row;i++){
        for(int j=0;j<rowCount;j++){
            
            NSInteger index = i*rowCount+j;
            UIView *btnSub = [[UIView alloc] init];//[UIButton buttonWithType:UIButtonTypeCustom];
            btnSub.tag = index;
            btnSub.size = [UIView getSize_width:width height:height];
            btnSub.origin = [UIView getPoint_x:j*width y:i*height];
            btnSub.layer.borderWidth = 0.25;
            btnSub.layer.borderWidth = 1.0;
            btnSub.layer.borderColor = ColorThemeBackground.CGColor;
            [self addSubview:btnSub];
            
            if(index < self.source.count){
                GetHotSearchSixModel *model = [self.source objectAtIndex:index];
                
                UIImageView *imageView = [[UIImageView alloc]init];
                imageView.size = [UIView getSize_width:btnSub.width height:btnSub.height];
                imageView.origin = [UIView getPoint_x:0 y:0];
                imageView.contentMode =  UIViewContentModeScaleAspectFill;
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.noodleVideoCover]
                             placeholderImage:[UIImage imageNamed:@"actitvtiyDefout"]];
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = 4.0f;
                imageView.userInteractionEnabled = YES;
                [btnSub addSubview:imageView];
                
                UIView *maskView = [[UIView alloc]init];
                maskView.size = [UIView getSize_width:btnSub.width height:btnSub.height];
                maskView.origin = [UIView getPoint_x:0 y:0];
                maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
                [btnSub addSubview:maskView];
                
                
                UILabel *lableHotTag = [[UILabel alloc]init];
                lableHotTag.height = 50;
                lableHotTag.width  = btnSub.width;
                lableHotTag.textColor = ColorWhite;
                lableHotTag.centerY = maskView.centerY;
                lableHotTag.centerX = lableHotTag.centerX;
                lableHotTag.font = BigBoldFont;
                lableHotTag.text = model.topic;
                lableHotTag.numberOfLines = 2;
                lableHotTag.textAlignment = NSTextAlignmentCenter;
                lableHotTag.lineBreakMode = NSLineBreakByCharWrapping;

                [btnSub addSubview:lableHotTag];
                
                
                
            }
        }
    }
    
    if(dataLoadFinishBlock){
        dataLoadFinishBlock();
    }
}

-(void)btnPlayClick:(UIButton*)btn{
//    ListLoginModel *item = [self.source objectAtIndex:btn.tag];
//    if(self.playVideoClcik){
//        self.playVideoClcik(item);
//    }
}

-(void)btnZanClick:(UIButton*)btn{
    
//    UIView *btnSub = [self viewWithTag:btn.tag];
//    UIView *viewSubBg = [btnSub viewWithTag:btn.tag];
//    UILabel *labelZan = [viewSubBg viewWithTag:9000+btn.tag];
//
//
//    ListLoginModel *item = [self.source objectAtIndex:btn.tag];
//    if(self.zanClcik){
//        self.zanClcik(item,btn,labelZan);
//    }
}

@end
