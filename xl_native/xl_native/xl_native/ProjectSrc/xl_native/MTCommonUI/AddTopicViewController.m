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
    

    self.textFieldBgView = [[UIView alloc] init];
    self.textFieldBgView.size = [UIView getSize_width:self.navBackGround.width - 15*2 - self.cancleButton.width -15
                                               height:self.navBackGround.height];
    self.textFieldBgView.origin = [UIView getPoint_x:15 y:0];
    self.textFieldBgView.layer.borderWidth = 0.0;
    self.textFieldBgView.layer.cornerRadius = 5.0;
    self.textFieldBgView.layer.borderColor = defaultLineColor.CGColor;
    [self.navBackGround addSubview:self.textFieldBgView];
    
    
    self.textFieldSearchKey = [[UITextField alloc] init];
    self.textFieldSearchKey.size = [UIView getSize_width:self.textFieldBgView.width height:36];
    self.textFieldSearchKey.origin = [UIView getPoint_x:0 y:self.textFieldBgView.height - self.textFieldSearchKey.height-5];
    self.textFieldSearchKey.layer.cornerRadius = 4.0f;
    self.textFieldSearchKey.placeholder = @"# 请输入或选择话题";
    self.textFieldSearchKey.textColor = [UIColor whiteColor];
    self.textFieldSearchKey.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldSearchKey.clearsOnBeginEditing = YES;
    self.textFieldSearchKey.delegate = self;
    self.textFieldSearchKey.returnKeyType = UIReturnKeyDone;
    self.textFieldSearchKey.font = MediumFont;
    self.textFieldSearchKey.backgroundColor = MTColorBtnNormal;
    [self.textFieldSearchKey setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textFieldBgView addSubview:self.textFieldSearchKey];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.textFieldSearchKey];
    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.left = 0;
    viewLine.size = [UIView getSize_width:ScreenWidth - viewLine.left height:0.6];
    viewLine.bottom = self.navBackGround.height - viewLine.height;
    viewLine.backgroundColor = MTColorLine;
    [self.navBackGround addSubview:viewLine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForRemoteNotification];
    [self setUpUI];
}

-(void)setUpUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    
    [self.view addSubview:self.mainTableView];
    
    [self.textFieldSearchKey becomeFirstResponder]; //获得焦点
    
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


#pragma mark - -------- UITextFieldDelegate -------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *topicName = textField.text.trim;
    if(topicName.length == 0){
        topicName = textField.placeholder;
        return NO;
    }
    
    GetFuzzyTopicListModel *model = [[GetFuzzyTopicListModel alloc] init];
    model.id = @"";
    model.topic = [NSString stringWithFormat:@"#%@",topicName];
    model.hotCount = @"0";
    
    if ([self.delegate respondsToSelector:@selector(TopicClick:)]) {
        [self.delegate TopicClick:model];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
    
    return YES;
}

-(void)textFiledEditChanged:(NSNotification*)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    self.keyWord = textField.text;
    [self loadNewData];
}

#pragma mark - -------- SearchResultSubTopicDelegate -------------


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
    
    self.keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.mainTableView.height = ScreenHeight - self.keyBoardFrame.size.height -kNavBarHeight_New;
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification{
/*
 *暂时保留
 */
}


@end
