//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "AddTopicViewController.h"

#import "ScrollPlayerListViewController.h"
#import "TopicInfoController.h"
#import "MusicInfoController.h"

@interface AddTopicViewController ()

@property (nonatomic,strong) NSString * keyWord;


@end

@implementation AddTopicViewController







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
    self.textFieldSearchKey.placeholder = @"明星";
    self.textFieldSearchKey.textColor = [UIColor whiteColor];
    self.textFieldSearchKey.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldSearchKey.clearsOnBeginEditing = YES;
    self.textFieldSearchKey.delegate = self;
    self.textFieldSearchKey.returnKeyType = UIReturnKeySearch;
    self.textFieldSearchKey.font = [UIFont defaultFontWithSize:16.0];
    self.textFieldSearchKey.backgroundColor = [UIColor whiteColor];
    [self.textFieldBgView addSubview:self.textFieldSearchKey];
    self.textFieldSearchKey.backgroundColor = RGBA(58, 58, 67, 1);
    [self.textFieldSearchKey setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.textFieldSearchKey];


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
    [self.mainTableView.mj_header beginRefreshing];
    [self.mainTableView registerClass:SearchResultSubTopicCell.class forCellReuseIdentifier:[SearchResultSubTopicCell cellId]];
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
    
   self.keyWord = self.textFieldSearchKey.text.trim;
    if(self.keyWord.length == 0){
        NetWork_mt_getTopicList *request = [[NetWork_mt_getTopicList alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        [request startGetWithBlock:^(GetTopicListResponse *result, NSString *msg, BOOL finished) {
            NSLog(@"-----");
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
    else{
        NetWork_mt_getFuzzyTopicList *request = [[NetWork_mt_getFuzzyTopicList alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.searchName = self.keyWord;
        request.pageNo = [NSString stringWithFormat:@"%d",self.currentPageIndex=self.currentPageIndex+1];
        request.pageSize = [NSString stringWithFormat:@"%d",self.currentPageSize];
        [request startGetWithBlock:^(id result, NSString *msg) {
            /*暂时不考虑缓存问题*/
        } finishBlock:^(GetFuzzyTopicListResponse *result, NSString *msg, BOOL finished) {
            
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
}

-(void)loadData:(NSArray *)arrayList{
    if (self.currentPageIndex == 1 || self.currentPageIndex == 0) {
        [self.mainDataArr removeAllObjects];
    }
    [self.mainDataArr addObjectsFromArray:arrayList];
    [self.mainTableView reloadData];
    
    //最后一页数据,如果话题榜，就加在一页
    if(self.mainDataArr.count < self.currentPageSize || arrayList.count == 0 || self.keyWord.length == 0) {
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
    [self.textFieldSearchKey resignFirstResponder];
}

#pragma mark --------------- cellDelegate 代理 -----------------
-(void)btnCellIconClick:(GetFuzzyTopicListModel*)model{
    NSLog(@"----------");
    
//    if([model.hotType integerValue] == 1){//话题
////        TopicInfoController *topicInfoController = [[TopicInfoController alloc] init];
////        topicInfoController.topicName = model.topic.topic;
////        [self pushNewVC:topicInfoController animated:YES];
//    }
//    else{//i音乐
////        MusicInfoController *musicInfoController = [[MusicInfoController alloc] init];
////        musicInfoController.musicId = [NSString stringWithFormat:@"%@",model.music.musicId];
////        [self pushNewVC:musicInfoController animated:YES];
//    }
    
}

-(void)btnCellVideoClick:(NSArray*)videoList selectIndex:(NSInteger)selectIndex{
    
//    ScrollPlayerListViewController *controller;
//    controller = [[ScrollPlayerListViewController alloc] initWithVideoData:videoList currentIndex:selectIndex];
//    [self pushNewVC:controller animated:YES];
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
        SearchResultSubTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchResultSubTopicCell cellId] forIndexPath:indexPath];
        cell.subTopicDelegate = self;
        GetFuzzyTopicListModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
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
    return  SearchResultSubTopicCellHeight;
}


#pragma mark -

-(void)textFiledEditChanged:(NSNotification*)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    self.keyWord = textField.text;
    [self loadNewData];
}

-(void)btnCellClick:(GetFuzzyTopicListModel*)model{
    
    if ([self.delegate respondsToSelector:@selector(TopicClick:)]) {
        [self.delegate TopicClick:model];
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
