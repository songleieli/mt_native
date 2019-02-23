//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "UserCollectionSubMusicViewController.h"

@interface UserCollectionSubMusicViewController ()

@end

@implementation UserCollectionSubMusicViewController

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
    CGFloat hyPageHeight = 44.0f;
    
    NSInteger tableViewHeight = ScreenHeight - kNavBarHeight_New - hyPageHeight;
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:tableViewHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:0];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor]; //RGBFromColor(0xecedf1);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.mj_footer = nil;
    [self.mainTableView registerClass:SearchResultSubMusicCell.class forCellReuseIdentifier:[SearchResultSubMusicCell cellId]];
    [self.mainTableView.mj_header beginRefreshing];
}

-(void)loadNewData{
    
    NetWork_mt_getFuzzyMusicList *request = [[NetWork_mt_getFuzzyMusicList alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
//    request.searchName = self.keyWord;
    request.pageNo = @"1";
    request.pageSize = @"20";
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*暂时不考虑缓存问题*/
    } finishBlock:^(GetFuzzyMusicListResponse *result, NSString *msg, BOOL finished) {
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
        SearchResultSubMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchResultSubMusicCell cellId] forIndexPath:indexPath];
        cell.subCellDelegate = self;
        GetFuzzyMusicListModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
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
    return  SearchResultSubMusicCellHeight;
}

#pragma mark --------------- cell代理 -----------------
-(void)btnCellClick:(GetFuzzyMusicListModel*)model{
    
    if ([self.delegate respondsToSelector:@selector(subMusicClick:)]) {
        [self.delegate subMusicClick:model];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

@end
