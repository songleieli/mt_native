//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "NetWork_mt_getFuzzyAccountList.h"
#import "SearchResultSubUserCell.h"


@protocol SubCellDelegate <NSObject>

-(void)subCkeckClick:(NSMutableArray *)selectModelList;

//-(void)subCellClick:(ZjPmsPatrolRecordsModel *)model subType:(NSString*)subType;

@end

@interface HomeSearchResultSubVideoViewController : ZJBaseViewController


@property(nonatomic,strong) NSString *parameter;         // @"待检",@"已检",@"未检"
@property (nonatomic, weak) id<SubCellDelegate> delegate;


@end
