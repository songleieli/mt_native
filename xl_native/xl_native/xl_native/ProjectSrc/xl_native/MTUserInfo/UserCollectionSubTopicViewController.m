//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "UserCollectionSubTopicViewController.h"

@interface UserCollectionSubTopicViewController ()

@end

@implementation UserCollectionSubTopicViewController

-(void)dealloc{
    
    NSLog(@"---------------%@ dealloc ",NSStringFromClass([self class]));
}

-(void)initNavTitle{
    self.isNavBackGroundHiden  = YES;


}

- (void)viewDidLoad {
    
    _pageIndex = 1;
    _pageSize = 20;
    
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
    [self.mainTableView registerClass:UserCollectionSubTopicCell.class forCellReuseIdentifier:[UserCollectionSubTopicCell cellId]];

    [self.mainTableView.mj_header beginRefreshing];
}

-(void)loadNewData{
    
    NetWork_mt_getTopicCollections *request = [[NetWork_mt_getTopicCollections alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.pageNo = [NSString stringWithFormat:@"%ld",self.pageIndex];//
    request.pageSize = [NSString stringWithFormat:@"%ld",self.pageSize];
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*暂时先不考虑缓存*/
    } finishBlock:^(GetTopicCollectionsResponse *result, NSString *msg, BOOL finished) {
        
        if(finished){
            self.pageIndex++;
            [self.mainTableView.mj_header endRefreshing];
            [self.mainDataArr addObjectsFromArray:result.obj];
            [self.mainTableView reloadData];
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
        UserCollectionSubTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserCollectionSubTopicCell cellId] forIndexPath:indexPath];
        cell.subTopicDelegate = self;
        GetTopicCollectionModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
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
    return  SearchResultSubTopicCellHeight;
}

#pragma mark --------------- cell代理 -----------------
-(void)btnCellClick:(GetTopicCollectionModel*)model{
    
    if ([self.delegate respondsToSelector:@selector(subCellTopicClick:)]) {
        [self.delegate subCellTopicClick:model];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

@end
