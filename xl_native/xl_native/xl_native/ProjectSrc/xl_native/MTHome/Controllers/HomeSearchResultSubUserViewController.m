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
    [self.mainTableView registerClass:SearchResultSubUserCell.class forCellReuseIdentifier:[SearchResultSubUserCell cellId]];

    [self.mainTableView.mj_header beginRefreshing];
}

#pragma mark - --------- 数据加载代理 ------------
-(void)loadNewData{
    self.currentPageIndex = 0;
    [self initRequest];
}

-(void)loadMoreData{
    [self initRequest];
}

#pragma mark ------- 加载网络请求 -------

-(void)initRequest{
    
//    //过滤Music携带的 “#” 号，接口不需要
//    NSString *userNameTemp = self.keyWord;
//    NSUInteger location = [userNameTemp rangeOfString:@"#"].location;
//    if (location == NSNotFound) {
//    } else {
//        userNameTemp = [userNameTemp substringFromIndex:1];
//    }
    
    NetWork_mt_getFuzzyAccountList *request = [[NetWork_mt_getFuzzyAccountList alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.searchName = self.keyWord;
    request.pageNo = [NSString stringWithFormat:@"%d",self.currentPageIndex=self.currentPageIndex+1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.currentPageSize];
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*暂时不考虑缓存问题*/
    } finishBlock:^(GetFuzzyAccountListResponse *result, NSString *msg, BOOL finished) {
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        if(finished){
            [self loadData:result];
        }
        else{
            [UIWindow showTips:@"数据获取失败，请检查网络"];
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}


-(void)loadData:(GetFuzzyAccountListResponse *)result{
    if (self.currentPageIndex == 1 ) {
        [self.mainDataArr removeAllObjects];
    }
    [self.mainDataArr addObjectsFromArray:result.obj];
    [self.mainTableView reloadData];
    
    if(self.mainDataArr.count < self.currentPageSize || result.obj.count == 0) {//最后一页数据
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
    }
}





#pragma mark --------------- SearchResultSubUserDelegate -----------------
-(void)btnCellClick:(GetFuzzyAccountListModel*)model{
    if ([self.delegate respondsToSelector:@selector(subUserClick:)]) {
        [self.delegate subUserClick:model];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
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
        cell.subCellDelegate = self;
        GetFuzzyAccountListModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
        [cell fillDataWithModel:model withKeyWord:self.keyWord];
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
