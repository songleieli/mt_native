//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "HomeSearchResultSubUserViewController.h"

@interface HomeSearchResultSubUserViewController ()

@end

@implementation HomeSearchResultSubUserViewController

-(void)dealloc{
    
    NSLog(@"---------------%@ dealloc ",NSStringFromClass([self class]));
}

-(void)initNavTitle{
    self.isNavBackGroundHiden  = YES;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

-(void)setUpUI{
    self.view.backgroundColor = ColorThemeBackground;
    
    
    [self.view addSubview:self.mainTableView];
    
//#define TOP_SCROLLERTAB_HEIGHT 44
    
    CGFloat hyPageHeight = 44.0f;

    
    NSInteger tableViewHeight = ScreenHeight - kNavBarHeight_New - hyPageHeight;
    
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:tableViewHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:0];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor]; //RGBFromColor(0xecedf1);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.mainTableView.mj_header = nil;
    self.mainTableView.mj_footer = nil;
    [self.mainTableView registerClass:SearchResultSubUserCell.class forCellReuseIdentifier:[SearchResultSubUserCell cellId]];

    [self.mainTableView.mj_header beginRefreshing];
}

-(void)loadNewData{
    
    NetWork_mt_getFuzzyAccountList *request = [[NetWork_mt_getFuzzyAccountList alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.searchName = self.keyWord;
    request.pageNo = @"1";
    request.pageSize = @"20";
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*暂时不考虑缓存问题*/
    } finishBlock:^(GetFuzzyAccountListResponse *result, NSString *msg, BOOL finished) {
        NSLog(@"-------");
        [self.mainTableView.mj_header endRefreshing];
//        [self loadBodyDataList]; //加载cell Data
        
        
        [self.mainDataArr addObjectsFromArray:result.obj];
        [self.mainTableView reloadData];
        
        if(finished){
//            [self refreshVideoList:result.obj];
        }
        else{
            [UIWindow showTips:msg];
        }
    }];
}


#pragma mark --------------- tabbleView代理 -----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.mainDataArr.count;
}
//设置cell的样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.mainDataArr.count > 0){
        SearchResultSubUserCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchResultSubUserCell cellId] forIndexPath:indexPath];
        GetFuzzyAccountListModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
        [cell fillDataWithModel:model];
        return cell;
    }
    else{
        /*
         有时会出现，self.mainDataArr count为0 cellForRowAtIndexPath，却响应的bug。
         */
        UITableViewCell * celltemp =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        return celltemp;
    }
}

//设置每一组的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  SearchResultSubUserCellHeight;
}

@end
