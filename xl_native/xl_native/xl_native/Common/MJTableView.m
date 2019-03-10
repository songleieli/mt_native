//
//  SRTableView.m
//  SlimeRefresh
//
//  Created by zhaoweibing on 14-4-23.
//  Copyright (c) 2014年 zrz. All rights reserved.
//

#import "MJTableView.h"

@interface MJTableView ()

@property (nonatomic, assign) BOOL isForbid;//上拉是否禁止
@property (nonatomic, assign) BOOL isFrensh;//是否正在刷新
@property (nonatomic, assign) BOOL isLoadMore;//是否正在加载更多

@end

@implementation MJTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)tableViewStyle{
    
    self = [super initWithFrame:frame style:tableViewStyle];
    if (self) {
        // Initialization code
        
        MJRefreshGifHeader *mJefreshGifHeader = [[MJRefreshGifHeader alloc]init];
        [mJefreshGifHeader prepare];
        //[mJefreshGifHeader setRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        // 设置普通状态的动画图片Loading0%02lu
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=16; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", i]];
            [idleImages addObject:image];
        }
        [mJefreshGifHeader setImages:idleImages forState:MJRefreshStateIdle];
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=16; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", i]];
            [refreshingImages addObject:image];
        }
        [mJefreshGifHeader setImages:refreshingImages forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [mJefreshGifHeader setImages:refreshingImages forState:MJRefreshStateRefreshing];
        // 隐藏时间
        mJefreshGifHeader.lastUpdatedTimeLabel.hidden = YES;
        // 隐藏状态
        mJefreshGifHeader.stateLabel.hidden = YES;
        
        self.mj_header = mJefreshGifHeader;
        
        
        MJRefreshAutoGifFooter *footer = [[MJRefreshAutoGifFooter alloc]init];
        [footer prepare];
        //[footer setRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        // 设置正在刷新状态的动画图片
        NSMutableArray *refreshingFooterImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=16; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", i]];
            [refreshingFooterImages addObject:image];
        }
        
        [footer setImages:refreshingFooterImages forState:MJRefreshStateRefreshing];
        footer.refreshingTitleHidden = NO;
        self.mj_footer = footer;
    }
    return self;
}




@end
