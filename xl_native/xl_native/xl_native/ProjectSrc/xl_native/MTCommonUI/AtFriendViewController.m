//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "AtFriendViewController.h"

#import "ScrollPlayerListViewController.h"
#import "TopicInfoController.h"
#import "MusicInfoController.h"

@interface AtFriendViewController ()

@end

@implementation AtFriendViewController







-(void)dealloc{
    
}


-(void)initNavTitle{
    self.isNavBackGroundHiden  = NO;
    self.btnLeft.hidden = YES;
    
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = BigBoldFont; //[UIFont defaultBoldFontWithSize:16];
    self.title = @"我的好友";
    
    
    //取消按钮
    self.cancleButton = [[UIButton alloc]init];
    self.cancleButton.size = [UIView getSize_width:35 height:36];
    self.cancleButton.right = ScreenWidth - 15;
    self.cancleButton.bottom = self.navBackGround.height - 5;
    [self.cancleButton setTitleColor:MTColorBtnRedNormal forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:MTColorBtnRedHighlighted forState:UIControlStateHighlighted];
    
    self.cancleButton.titleLabel.font = MediumBoldFont;
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackGround addSubview:self.cancleButton];

    UIView *viewLine = [[UIView alloc] init];
    viewLine.left = 0;
    viewLine.size = [UIView getSize_width:ScreenWidth - viewLine.left height:0.6];
    viewLine.bottom = self.navBackGround.height - viewLine.height;
    viewLine.backgroundColor = MTColorLine;
    [self.navBackGround addSubview:viewLine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

-(void)setUpUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    
    [self.view addSubview:self.mainTableView];
    
    NSInteger tableViewHeight = ScreenHeight - kNavBarHeight_New;
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:tableViewHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:kNavBarHeight_New];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor]; //RGBFromColor(0xecedf1);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTableView.mj_header beginRefreshing];
    [self.mainTableView registerClass:MessageCell.class forCellReuseIdentifier:[MessageCell cellId]];
    [self.mainTableView.mj_header beginRefreshing];
}


#pragma -mark ---------- CustomMethod ----------

- (void) setBackgroundImage:(NSString *)imageName {
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.clipsToBounds = YES;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.image = [UIImage imageNamed:imageName];
    //[self.view addSubview:background];
    [self.view insertSubview:background atIndex:0];
}

-(void)initRequest{
    
    NetWork_mt_getFollows *request = [[NetWork_mt_getFollows alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.pageNo = [NSString stringWithFormat:@"%d",self.currentPageIndex=self.currentPageIndex+1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.currentPageSize];
    [request startGetWithBlock:^(GetFollowsResponse *result, NSString *msg) {
        /*
         *暂不考虑缓存问题
         */
    } finishBlock:^(GetFollowsResponse *result, NSString *msg, BOOL finished) {
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        if(finished){
            [self loadData:result.obj];
        }
        else{
            [UIWindow showTips:@"数据获取失败，请检查网络"];
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
-(void)loadData:(NSArray *)arrayList{
    if (self.currentPageIndex == 1 || self.currentPageIndex == 0) {
        [self.mainDataArr removeAllObjects];
    }
    [self.mainDataArr addObjectsFromArray:arrayList];
    [self.mainTableView reloadData];
    
    //最后一页数据,如果话题榜，就加在一页
    if(self.mainDataArr.count < self.currentPageSize || arrayList.count == 0) {
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
    }
}


-(void)backBtnClick:(UIButton*)btn{
    if(self.backClickBlock){
        self.backClickBlock();
    }
}

#pragma mark -------------- 加载更多 --------------

-(void)loadNewData{
    self.currentPageIndex = 0;
    [self initRequest];
}
-(void)loadMoreData{
    [self initRequest];
}


#pragma mark ---------- 点击搜索按钮 --------

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *topicName = textField.text.trim;
    if(topicName.length == 0){
        topicName = textField.placeholder;
    }
    
    
    //过滤携带的 “#” 号，接口不需要
    NSUInteger location = [topicName rangeOfString:@"#"].location;
    if (location == NSNotFound) {
    } else {
        topicName = [topicName substringFromIndex:1];
    }
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 取消按钮点击事件

-(void)btnCancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[MessageCell cellId] forIndexPath:indexPath];
        cell.isHideTime = YES;
        cell.getFollowsDelegate = self;
        GetFollowsModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
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


-(void)btnCellClick:(GetFollowsModel*)model{
    
    if ([self.delegate respondsToSelector:@selector(AtFriendClick:)]) {
        [self.delegate AtFriendClick:model];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - 键盘 show 与 hide

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{

    if(!self.hasKeyBordShow){
        /*
         在调试过过程中发现，keyboardWillShow会多次调用弹起，通过 hasKeyBordShow 判断只有第一次调用才响应以下代码块
         */
        self.cancleButton.left = self.cancleButton.left - 50;
        
        [UIView animateWithDuration:1.0f animations:^{
            self.btnRight.hidden = YES;
        }];
    }
    self.hasKeyBordShow = YES;
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification{
    
    self.hasKeyBordShow = NO;
    self.cancleButton.left = self.cancleButton.left + 50;
    [UIView animateWithDuration:1.0f animations:^{
        self.btnRight.hidden = NO;
    }];
}


@end
