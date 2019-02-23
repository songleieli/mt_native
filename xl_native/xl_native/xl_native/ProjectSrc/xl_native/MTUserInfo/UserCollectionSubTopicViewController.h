//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "UserCollectionSubTopicCell.h"


@protocol SubTopicCellDelegate <NSObject>

-(void)subCellTopicClick:(GetTopicCollectionModel *)model;

@end

@interface UserCollectionSubTopicViewController : ZJBaseViewController<SearchResultSubTopicDelegate>




@property(nonatomic,strong) NSString *parameter;
@property (nonatomic, weak) id<SubTopicCellDelegate> delegate;

@property (nonatomic, assign) NSInteger                        pageIndex;
@property (nonatomic, assign) NSInteger                        pageSize;


@end
