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
            UIView *subView = [[UIView alloc] init];//[UIButton buttonWithType:UIButtonTypeCustom];
            subView.tag = index;
            subView.size = [UIView getSize_width:width height:height];
            subView.origin = [UIView getPoint_x:j*width y:i*height];
            subView.layer.borderWidth = 0.25;
            subView.layer.borderWidth = 1.0;
            subView.layer.borderColor = ColorThemeBackground.CGColor;
            [self addSubview:subView];
            
            if(index < self.source.count){
                GetHotSearchSixModel *model = [self.source objectAtIndex:index];
                
                UIImageView *imageView = [[UIImageView alloc]init];
                imageView.size = [UIView getSize_width:subView.width height:subView.height];
                imageView.origin = [UIView getPoint_x:0 y:0];
                imageView.contentMode =  UIViewContentModeScaleAspectFill;
                
                NSRange range = [model.noodleVideoCover rangeOfString:@"f_webp"];
                if(range.location != NSNotFound){
                    model.noodleVideoCover =  [model.noodleVideoCover stringByReplacingCharactersInRange:range withString:@"f_png"];
                }
                
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.noodleVideoCover]
                             placeholderImage:[UIImage imageNamed:@"actitvtiyDefout"]];
                
//                [imageView sd_setImageWithURL:[NSURL URLWithString:model.noodleVideoCover.trim] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    NSLog(@"-----");
//                }];
                
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = 4.0f;
                imageView.userInteractionEnabled = YES;
                [subView addSubview:imageView];
                
                UIButton *btnMask = [UIButton buttonWithType:UIButtonTypeCustom];
                btnMask.tag = index;
                btnMask.size = [UIView getSize_width:subView.width height:subView.height];
                btnMask.origin = [UIView getPoint_x:0 y:0];
                [btnMask setBackgroundColor:RGBA(0, 0, 0, 0.5) forState:UIControlStateNormal];
                [btnMask setBackgroundColor:RGBA(46, 45, 51, 0.8) forState:UIControlStateHighlighted];
                [btnMask addTarget:self action:@selector(btnTopicClick:) forControlEvents:UIControlEventTouchUpInside];
                [subView addSubview:btnMask];
                
                
                UILabel *lableHotTag = [[UILabel alloc]init];
                lableHotTag.height = 50;
                lableHotTag.width  = subView.width;
                lableHotTag.textColor = ColorWhite;
                lableHotTag.centerY = btnMask.centerY;
                lableHotTag.centerX = lableHotTag.centerX;
                lableHotTag.font = BigBoldFont;
                lableHotTag.text = model.topic;
                lableHotTag.numberOfLines = 2;
                lableHotTag.textAlignment = NSTextAlignmentCenter;
                lableHotTag.lineBreakMode = NSLineBreakByCharWrapping;

                [subView addSubview:lableHotTag];
            }
        }
    }
    
    if(dataLoadFinishBlock){
        dataLoadFinishBlock();
    }
}

-(void)btnTopicClick:(UIButton*)btn{
    GetHotSearchSixModel *item = [self.source objectAtIndex:btn.tag];
    if(self.topicClickBlock){
        self.topicClickBlock(item);
    }
}


@end
