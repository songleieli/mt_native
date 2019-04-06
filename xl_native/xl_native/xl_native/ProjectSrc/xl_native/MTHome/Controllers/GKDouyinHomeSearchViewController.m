//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "GKDouyinHomeSearchViewController.h"

#import "ScrollPlayerListViewController.h"
#import "TopicInfoController.h"
#import "MusicInfoController.h"

@interface GKDouyinHomeSearchViewController ()

@end

@implementation GKDouyinHomeSearchViewController

- (MTSearchHeadFunctionView *)functionView{
    
    if (!_functionView) {
        
        __weak typeof(self) weakSelf = self;
        CGRect rect =  [UIView getFrame_x:15 y:50 width:ScreenWidth-15*2 height:165];
        _functionView = [[MTSearchHeadFunctionView alloc] initWithFrame:rect];
        _functionView.topicClickBlock = ^(GetHotSearchSixModel *model) {
            NSLog(@"-------");
            
                NSString *keyWord = model.topic;
                NSUInteger location = [keyWord rangeOfString:@"#"].location;
                if (location == NSNotFound) {
                } else {
                    keyWord = [keyWord substringFromIndex:1];
                }
            
            HomeSearchResultViewController *homeSearchResultViewController = [[HomeSearchResultViewController alloc] initWithKeyWord:keyWord];
            [weakSelf pushNewVC:homeSearchResultViewController animated:YES];
            
        };
    }
    return  _functionView;
}

- (UIView *)viewHeadBg{
    
    if (!_viewHeadBg) {
        CGRect rect =  [UIView getFrame_x:0 y:0 width:ScreenWidth height:165];
        _viewHeadBg = [[UIView alloc] initWithFrame:rect];
        [_viewHeadBg addSubview:self.lableHeadTitle];
        [_viewHeadBg addSubview:self.functionView];
        [_viewHeadBg addSubview:self.lableHeadBottomTitle];
    }
    return  _viewHeadBg;
}

- (UILabel *) lableHeadTitle{
    if (_lableHeadTitle == nil){ //
        _lableHeadTitle = [[UILabel alloc]init];
        _lableHeadTitle.textColor = ColorWhite;
        _lableHeadTitle.font = BigBoldFont;
        _lableHeadTitle.top = 0;
        _lableHeadTitle.left = 15;
        _lableHeadTitle.height = 50;
        _lableHeadTitle.width = self.functionView.width;
        _lableHeadTitle.text = @"面条热搜";
    }
    return _lableHeadTitle;
}

- (UILabel *) lableHeadBottomTitle{
    if (_lableHeadBottomTitle == nil){ //
        _lableHeadBottomTitle = [[UILabel alloc]init];
        _lableHeadBottomTitle.textColor = ColorWhite;
        _lableHeadBottomTitle.font = BigBoldFont;
        _lableHeadBottomTitle.top = self.functionView.bottom;
        _lableHeadBottomTitle.left = 15;
        _lableHeadBottomTitle.height = 50;
        _lableHeadBottomTitle.width = self.functionView.width;
        _lableHeadBottomTitle.text = @"查看更多热搜榜";
    }
    return _lableHeadBottomTitle;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)registerForRemoteNotification{
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden  = NO;
    self.btnLeft.hidden = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.size = [UIView getSize_width:15 height:26];
    rightButton.origin = [UIView getPoint_x:self.navBackGround.width - rightButton.width-20
                                          y:self.navBackGround.height - rightButton.height-9];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_m_s_right"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnRight = rightButton;
    
    self.textFieldBgView = [[UIView alloc] init];
    self.textFieldBgView.size = [UIView getSize_width:self.navBackGround.width - 15*2 - rightButton.width - 25
                                               height:self.navBackGround.height];
    self.textFieldBgView.origin = [UIView getPoint_x:15 y:0];
    self.textFieldBgView.layer.borderWidth = 0.0;
    self.textFieldBgView.layer.cornerRadius = 5.0;
    self.textFieldBgView.layer.borderColor = defaultLineColor.CGColor;
    [self.navBackGround addSubview:self.textFieldBgView];
    
    //取消按钮
    self.cancleButton = [[UIButton alloc]init];
    self.cancleButton.size = [UIView getSize_width:35 height:36];
    self.cancleButton.origin = [UIView getPoint_x:ScreenWidth y:self.textFieldBgView.height - self.cancleButton.height - 5];
    [self.cancleButton setTitleColor:RGBA(252, 48, 88, 1) forState:UIControlStateNormal];
//    [self.cancleButton setTitleColor:RGBFromColor(0xecedf1) forState:UIControlStateHighlighted];
    self.cancleButton.titleLabel.font = [UIFont defaultFontWithSize:16];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackGround addSubview:self.cancleButton];
    
    
    UIView * leftView = [[UIView alloc]init];
    leftView.size = [UIView getSize_width:36 height:36];
    leftView.origin = [UIView getPoint_x:0 y:self.textFieldBgView.height - leftView.height-5];
    leftView.backgroundColor = RGBA(58, 58, 67, 1);
    
    UIImageView * iamgeViewPassWorld = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 18, 18)];
    iamgeViewPassWorld.image = [UIImage imageNamed:@"main_chaobiao_seach_left"];
    [leftView addSubview:iamgeViewPassWorld];
    [self.textFieldBgView addSubview:leftView];
    
    self.textFieldSearchKey = [[UITextField alloc] init];
    self.textFieldSearchKey.size = [UIView getSize_width:self.textFieldBgView.width - leftView.width height:leftView.height];
    self.textFieldSearchKey.origin = [UIView getPoint_x:leftView.right y:self.textFieldBgView.height - self.textFieldSearchKey.height-5];
//    self.textFieldSearchKey.placeholder = @"明星";
    self.textFieldSearchKey.layer.cornerRadius = 4.0f;
    self.textFieldSearchKey.textColor = [UIColor whiteColor];
    self.textFieldSearchKey.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldSearchKey.clearsOnBeginEditing = YES;
    self.textFieldSearchKey.delegate = self;
    self.textFieldSearchKey.returnKeyType = UIReturnKeySearch;
    self.textFieldSearchKey.font = [UIFont defaultFontWithSize:16.0];
    self.textFieldSearchKey.backgroundColor = [UIColor whiteColor];
    [self.textFieldBgView addSubview:self.textFieldSearchKey];
    self.textFieldSearchKey.backgroundColor = MTColorBtnNormal;
    [self.textFieldSearchKey setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForRemoteNotification];
    
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
    [self.mainTableView registerClass:HomeSearchCell.class forCellReuseIdentifier:[HomeSearchCell cellId]];
}

- (void)didScrollToSearchView{
    NSLog(@"------didScrollToSearchView---");
    
    /*
     *如果没有加载数据加载，如果已经加载数据，忽略
     */
    if(self.mainDataArr.count == 0){
        [self.mainTableView.mj_header beginRefreshing];
    }
}


#pragma -mark ---------- CustomMethod ----------

-(void)refreshVideoList:(NSArray*)searchSixModelList{
    
    __weak __typeof(self) weakSelf = self;
    [self.functionView reloadWithSource:searchSixModelList dataLoadFinishBlock:^() {
        weakSelf.viewHeadBg.height = weakSelf.functionView.height+100;
        weakSelf.lableHeadBottomTitle.top = weakSelf.functionView.bottom;
        weakSelf.mainTableView.tableHeaderView = weakSelf.viewHeadBg;
        
        /*
         随机去除一个model
         */
        int x = arc4random() % searchSixModelList.count;
        GetHotSearchSixModel *model = [searchSixModelList objectAtIndex:x];
        //过滤topic携带的 “#” 号，接口不需要
        NSString *topicNameTemp = model.topic;
        NSUInteger location = [topicNameTemp rangeOfString:@"#"].location;
        if (location == NSNotFound) {
        } else {
            topicNameTemp = [topicNameTemp substringFromIndex:1];
        }
        
        
        weakSelf.textFieldSearchKey.placeholder = topicNameTemp;
        [weakSelf.textFieldSearchKey setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    }];
    
}

-(void)backBtnClick:(UIButton*)btn{
    
    if(self.backClickBlock){
        self.backClickBlock();
    }
}

#pragma mark -------------- 加载更多 --------------

-(void)requestHeadData{

    NetWork_mt_getHotSearchSix *request = [[NetWork_mt_getHotSearchSix alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*暂时不考虑缓存问题*/
    } finishBlock:^(GetHotSearchSixResponse *result, NSString *msg, BOOL finished) {
        if(finished){
            [self refreshVideoList:result.obj];
        }
        else{
            [UIWindow showTips:msg];
        }
    }];
}

-(void)loadNewData{
    self.currentPageIndex = 0;
    self.currentPageSize = 5; //默认20，当前页面不适合 20条，5条
    [self initRequest]; //加载列表数据
    [self requestHeadData];//加载head热搜数据
}

-(void)loadMoreData{
    [self initRequest];
}



-(void)initRequest{
    
    NetWork_mt_getHotVideoList *request = [[NetWork_mt_getHotVideoList alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.pageNo = [NSString stringWithFormat:@"%d",self.currentPageIndex=self.currentPageIndex+1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.currentPageSize];
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*暂时不考虑缓存问题*/
    } finishBlock:^(GetHotSearchSixResponse *result, NSString *msg, BOOL finished) {
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        if(finished){
            [self loadData:result];
        }
        else{
            [UIWindow showTips:msg];
        }
    }];
}

-(void)loadData:(GetHotSearchSixResponse *)result{
    if (self.currentPageIndex == 1 ) {
        [self.mainDataArr removeAllObjects];
    }
    [self.mainDataArr addObjectsFromArray:result.obj];
    [self.mainTableView reloadData];
    
    if(self.mainDataArr.count < self.currentPageSize || result.obj.count == 0) {//最后一页数据
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
    }
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
    HomeSearchResultViewController *homeSearchResultViewController = [[HomeSearchResultViewController alloc] initWithKeyWord:topicName];
    [self pushNewVC:homeSearchResultViewController animated:YES];
    return YES;
}


#pragma mark - 取消按钮点击事件

-(void)btnCancelClick{
    [self.textFieldSearchKey resignFirstResponder];
}

#pragma mark --------------- cellDelegate 代理 -----------------
-(void)btnCellIconClick:(GetHotVideoListModel*)model{
    NSLog(@"----------");
    
    if([model.hotType integerValue] == 1){//话题
        TopicInfoController *topicInfoController = [[TopicInfoController alloc] init];
        topicInfoController.topicName = model.topic.topic;
        [self pushNewVC:topicInfoController animated:YES];
    }
    else{//i音乐
        MusicInfoController *musicInfoController = [[MusicInfoController alloc] init];
        musicInfoController.musicId = [NSString stringWithFormat:@"%@",model.music.musicId];
        [self pushNewVC:musicInfoController animated:YES];
    }
    
}

-(void)btnCellVideoClick:(NSArray*)videoList selectIndex:(NSInteger)selectIndex{
    
    ScrollPlayerListViewController *controller;
    controller = [[ScrollPlayerListViewController alloc] initWithVideoData:videoList currentIndex:selectIndex];
    [self pushNewVC:controller animated:YES];
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
        HomeSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeSearchCell cellId] forIndexPath:indexPath];
        cell.cellDelegate = self;
        GetHotVideoListModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
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
    return  HomeSearchCellHeight;
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
