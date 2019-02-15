//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "SearchResultSubTopicCell.h"


@protocol SubCellDelegate <NSObject>

-(void)subCellTopicClick:(GetFuzzyTopicListModel *)model;

@end

@interface HomeSearchResultSubTopicViewController : ZJBaseViewController<SearchResultSubTopicDelegate>


@property(nonatomic,strong) NSString *parameter;         // @"待检",@"已检",@"未检"
@property (nonatomic, weak) id<SubCellDelegate> delegate;


@end
