//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

NSString * const kSearchResultSubVideoCollectionCell  = @"kSearchResultSubVideoCollectionCell";


#import "NetWork_mt_getFuzzyVideoList.h"
#import "SearchResultSubVideoCollectionCell.h"
#import "LoadMoreControl.h" //加载更多控件


@protocol SubCellDelegate <NSObject>

-(void)subCkeckClick:(NSMutableArray *)selectModelList;

//-(void)subCellClick:(ZjPmsPatrolRecordsModel *)model subType:(NSString*)subType;

@end

@interface HomeSearchResultSubVideoViewController : ZJBaseViewController<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIViewControllerTransitioningDelegate
>


@property(nonatomic,strong) NSString *parameter;         // @"待检",@"已检",@"未检"
@property (nonatomic, weak) id<SubCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray   *favoriteAwemes;//当前视频数组
@property (nonatomic, strong) LoadMoreControl                  *loadMore;

@end
