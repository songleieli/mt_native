//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "NetWork_mt_getFuzzyAccountList.h"
#import "SearchResultSubUserCell.h"


@protocol SubCellUserDelegate <NSObject>

-(void)subUserClick:(GetFuzzyAccountListModel *)model;

@end

@interface HomeSearchResultSubUserViewController : ZJBaseViewController<SearchResultSubUserDelegate>


@property(nonatomic,strong) NSString *parameter;
@property(nonatomic,strong) NSString *keyWord;
@property (nonatomic, weak) id<SubCellUserDelegate> delegate;


@end
