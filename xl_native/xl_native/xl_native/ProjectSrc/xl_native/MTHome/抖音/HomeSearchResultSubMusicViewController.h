//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "NetWork_mt_getFuzzyMusicList.h"
#import "SearchResultSubMusicCell.h"


@protocol SubCellDelegate <NSObject>

-(void)subMusicClick:(GetFuzzyMusicListModel *)model;

@end

@interface HomeSearchResultSubMusicViewController : ZJBaseViewController<SearchResultSubMusicDelegate>


@property(nonatomic,strong) NSString *parameter;
@property(nonatomic,strong) NSString *keyWord;
@property (nonatomic, weak) id<SubCellDelegate> delegate;

@property (nonatomic, assign) NSInteger                        pageIndex;
@property (nonatomic, assign) NSInteger                        pageSize;


@end
