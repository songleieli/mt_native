//
//  MyScrollView.m
//  中酒批
//
//  Created by ios on 13-12-19.
//  Copyright (c) 2013年 Ios. All rights reserved.
//

#import "MyScrollView.h"
#import "UIImageView+WebCache.h"


@interface MyScrollView () <MyImageDelegate>
{
    NSMutableArray  *muArrImg;
    NSMutableArray  *muArrViews;
    NSInteger       pageCount;
    unsigned long   currentIndex;
    unsigned long   totalPage;
}

@end

@implementation MyScrollView

- (MyScrollView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isUrlImg = YES;    //默认显示Url图片
        self.isAutoScroll = YES;//默认自动滚动
        self.isDisplayPageDefault = YES; //默认显示 pageDefault
    }
    return self;
}

- (void)reloadData:(NSArray*)source{
    
    
    if (source.count == 0) {
        return;
    }
    //停止定时器
    [self invalidateTimer];
    
    muArrImg = [NSMutableArray arrayWithArray:source];
    pageCount = source.count;
    
    if (source.count == 1) { //只有一张  不动
        [self reloadOnlyViewWithPageEnable];
        
    } else {
        //至少3张
        while (muArrImg.count < 3) {
            [muArrImg addObjectsFromArray:source];
        }
        
        if(self.isAutoScroll){ //启动，自动滚动
            //初始化时间
            [self initTime];
        }
        
        [self reloadViews];
    }
}

- (void)initTime
{
    if (muArrImg.count < 2) {
        return;
    }
    
    [self invalidateTimer];
    
    self.scrolTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changeImg) userInfo:nil repeats:YES];
}

- (void)invalidateTimer
{
    [self.scrolTimer invalidate];
    self.scrolTimer = nil;
}

/*只有一张图片*/
- (void)reloadOnlyViewWithPageEnable{
    
    if (![muArrImg isKindOfClass:[NSArray class]] || muArrImg.count == 0) {
        return ;
    }
    
    @autoreleasepool {
        [_scrolDefault removeFromSuperview];
        _scrolDefault = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrolDefault.backgroundColor = [UIColor whiteColor];
        _scrolDefault.showsHorizontalScrollIndicator = NO;
        _scrolDefault.pagingEnabled = YES;
        _scrolDefault.delegate = self;
        [self addSubview:_scrolDefault];
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        NSString *imageUrl = [muArrImg firstObject];
        
        MyImageView *imgViewDefault = [self addImageViewWithFrame:CGRectMake(0, 0, width, height) tag:0];
        
        if(self.isUrlImg){
            [imgViewDefault sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        }
        else{
            imgViewDefault.image = [UIImage imageNamed:imageUrl];
        }
        imgViewDefault.contentMode =  UIViewContentModeScaleAspectFill; //图片不变形，可能会只显示部分
        
        self.clipsToBounds = YES;
    }
}

- (void)reloadViews
{
    muArrViews = [NSMutableArray array];
    @autoreleasepool {
        
        [_scrolDefault removeFromSuperview];
        
        _scrolDefault = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrolDefault.backgroundColor = [UIColor whiteColor];
        _scrolDefault.showsHorizontalScrollIndicator = NO;
        _scrolDefault.pagingEnabled = YES;
        _scrolDefault.delegate = self;
        [self addSubview:_scrolDefault];
        
        
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        if (![muArrImg isKindOfClass:[NSArray class]] || muArrImg.count == 0) {
            return ;
        }
        
        totalPage = 100000/muArrImg.count*muArrImg.count;
        currentIndex = totalPage/2;
        for (int i = 0; i < muArrImg.count; ++i) {
            MyImageView *imgViewDefault = [self addImageViewWithFrame:CGRectMake((currentIndex+i)*width, 0, width, height) tag:(currentIndex+i)];
            [muArrViews addObject:imgViewDefault];
            imgViewDefault = nil;
        }
        
        [_pageDefault removeFromSuperview];
        
        _pageDefault = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - sizeScale(30), width, sizeScale(20))];
        _pageDefault.backgroundColor = [UIColor clearColor];
        _pageDefault.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageDefault.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageDefault.currentPage = 0;
        _pageDefault.numberOfPages = pageCount;
        _pageDefault.userInteractionEnabled = NO;
        
        _pageDefault.hidden = !self.isDisplayPageDefault;
        
        [self addSubview:_pageDefault];
        
        
        self.clipsToBounds = YES;
        
        _scrolDefault.contentSize = CGSizeMake(currentIndex*width*2, height);
        [_scrolDefault setContentOffset:CGPointMake(currentIndex*width, 0) animated:NO];
        
        
        [self loadImgWithIndex:currentIndex];
        [self changeImgWithIndex:currentIndex];
    }
}

- (MyImageView *)addImageViewWithFrame:(CGRect)frame tag:(NSInteger)tag{
    
    MyImageView *imgViewDefault = [[MyImageView alloc] initWithFrame:frame];
    imgViewDefault.index = tag;
    imgViewDefault.imageDelegate = self;
    imgViewDefault.userInteractionEnabled = YES;
    imgViewDefault.backgroundColor = [UIColor clearColor];
    
    
    [self.scrolDefault addSubview:imgViewDefault];
    
    return imgViewDefault;
}

- (void)changeImg
{
    if (self.scrolTimer == nil) {
        return;
    }
    
    currentIndex += 1;
    
    NSInteger endX = 100/pageCount*pageCount+currentIndex%pageCount;//到指定数量(pageCount的整数倍+偏移量)的时候切换到中间偏移量
    if (currentIndex <= endX || currentIndex >= totalPage-endX) {
        currentIndex = totalPage/2;
        [self loadImgWithIndex:currentIndex];
        [_scrolDefault setContentOffset:CGPointMake(self.frame.size.width*currentIndex, 0) animated:NO];
        [self changeImgWithIndex:currentIndex];
    } else {
        [_scrolDefault setContentOffset:CGPointMake(self.frame.size.width*currentIndex, 0) animated:YES];
        [self changeImgWithIndex:currentIndex];
    }
    
    _pageDefault.currentPage = currentIndex%pageCount;
    [self.pageDefault updateCurrentPageDisplay];
}

- (void)changeImgWithIndex:(NSInteger)index 
{
    currentIndex = index;
    if (index > 0) {
        [self loadImgWithIndex:index-1];
    }
    if (index < totalPage) {
        [self loadImgWithIndex:index+1];
    }
}

- (void)loadImgWithIndex:(NSInteger)index{
    
    if (muArrViews.count == 0) {
        return;
    }
    
    NSInteger count = index%muArrViews.count;
    if ((muArrViews.count <= count) || (muArrImg.count <= count)) {
        return;
    }
    
    MyImageView *imgViewDefault = muArrViews[index%muArrViews.count];
    imgViewDefault.index = index;
    
    NSInteger indexTemp = index%muArrViews.count;
    NSString *imgUrl = muArrImg[indexTemp];
    if(self.isUrlImg){
        [imgViewDefault sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }
    else{
        imgViewDefault.image = [UIImage imageNamed:imgUrl];
    }
    
    imgViewDefault.frame = CGRectMake(self.frame.size.width*index, 0, self.frame.size.width, self.frame.size.height);
    
    imgViewDefault.contentMode =  UIViewContentModeScaleAspectFill;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //初始化时间
    [self initTime];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //跟踪滚动视图页面
    CGFloat pageWidth = scrollView.bounds.size.width;
    int currentPage = (scrollView.contentOffset.x - pageWidth/2) / pageWidth + 1;
    if (currentPage != self.pageDefault.currentPage) {
        [self changeImgWithIndex:currentPage];
    }
    
    self.pageDefault.currentPage = currentPage%pageCount;
    [self.pageDefault updateCurrentPageDisplay];
    
}

#pragma mark - 图片点击代理
- (void)didSelectedWithImage:(MyImageView *)image pointFromWindow:(CGPoint)point row:(NSInteger)row
{
    //初始化时间
    [self initTime];
    
    NSInteger index = row%pageCount;
    if ([self.scrolDelegate respondsToSelector:@selector(myScrolView:didSelectedImgWithRow:)]) {
        [self.scrolDelegate myScrolView:self didSelectedImgWithRow:index];
    } else {
        NSLog(@"滚动视图的代理没有响应，过来看看吧");
    }
}

@end
