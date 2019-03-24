//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

@protocol SubCellDelegate <NSObject>

-(void)subCkeckClick:(NSMutableArray *)selectModelList;

//-(void)subCellClick:(ZjPmsPatrolRecordsModel *)model subType:(NSString*)subType;

@end

@interface HomeSearchResultSubViewController : ZJBaseViewController


@property(nonatomic,strong) NSString *parameter;
@property(nonatomic,strong) NSString *keyWord;
@property (nonatomic, weak) id<SubCellDelegate> delegate;


@end
