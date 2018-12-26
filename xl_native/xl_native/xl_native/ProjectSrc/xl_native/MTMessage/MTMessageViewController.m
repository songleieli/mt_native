//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "MTMessageViewController.h"
#import "NetWork_uploadApi.h"

@interface MTMessageViewController ()

@property (copy, nonatomic) NSString *myCallBack;

@end

@implementation MTMessageViewController

#pragma mark =========== 懒加载 ===========

#pragma mark --- header ---

//- (MyScrollView *)scrolBanner{
//
//    if (!_scrolBanner) {
//        CGRect rect =  [UIView getFrame_x:0 y:0 width:ScreenWidth height:sizeScale(137)];
//        _scrolBanner = [[MyScrollView alloc] initWithFrame:rect];
//        _scrolBanner.scrolDelegate = self;
//    }
//    return  _scrolBanner;
//}

//- (XLGCBodyView *)bodyView{
//    
//    if (!_bodyView) {
//        CGRect rect =  [UIView getFrame_x:0 y:0 width:ScreenWidth height:sizeScale(137)];
//        _bodyView = [[XLGCBodyView alloc] initWithFrame:rect];
////        _bodyView.scrolDelegate = self;
//    }
//    return  _bodyView;
//}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.tabBar.top = [self getTabbarTop];    //  重新设置tabbar的高度
    
    [self.mainDataArr removeAllObjects]; //加载页面内容时，先清除老数据
    [self initRequest];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden = NO;
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
    
    self.title = @"消息";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark ------ CustomMethod  ------

-(void)setupUI{
    self.view.backgroundColor = ColorThemeBackground;
    [self.view addSubview:self.mainTableView];
    
    
    NSInteger tableViewHeight = ScreenHeight -kTabBarHeight_New - kNavBarHeight_New;
    
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:tableViewHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:kNavBarHeight_New];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor]; //RGBFromColor(0xecedf1);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.mj_header = nil;
    self.mainTableView.mj_footer = nil;
    [self.mainTableView registerClass:MessageCell.class forCellReuseIdentifier:[MessageCell cellId]];

    
    self.mainTableView.tableHeaderView = [self getHeadView];
}

-(UIView*)getHeadView{
    
    self.viewHeadBg = [[UIView alloc] init];
    self.viewHeadBg.size = [UIView getSize_width:ScreenWidth height:sizeScale(80)];
    self.viewHeadBg.origin = [UIView getPoint_x:0 y:0];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.size = [UIView getSize_width:ScreenWidth height:0.3];
    lineLabel.top = self.viewHeadBg.height - lineLabel.height;
    lineLabel.left = 0;
    lineLabel.backgroundColor = [UIColor grayColor]; //RGBAlphaColor(222, 222, 222, 0.8);
    [self.viewHeadBg addSubview:lineLabel];
    
    
    NSArray *titleArray = @[@"面粉",@"赞",@"@我的",@"评论"];
    
//    NSInteger count = titleArray;
    CGFloat width = (CGFloat)self.viewHeadBg.width/titleArray.count;
    CGFloat offX = 0;

    
    for (int i = 0; i < titleArray.count; i++){
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(offX, 0, width, self.viewHeadBg.height);
//        bgView.backgroundColor = [GlobalFunc randomColor];
        [self.viewHeadBg addSubview:bgView];
        
        
        
        
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn.size = [UIView getSize_width:bgView.height/2 height:bgView.height/2];
        imgBtn.top = bgView.height/9;
        imgBtn.left = (bgView.width - imgBtn.width)/2;
        
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"icon_m_%d",i]];
        [imgBtn setImage:img forState:UIControlStateNormal];
        [bgView addSubview:imgBtn];
        
//
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.tag = i;
        titleBtn.size = [UIView getSize_width:bgView.width height:25];
        titleBtn.origin = [UIView getPoint_x:0 y:imgBtn.bottom];
        titleBtn.titleLabel.font = [UIFont defaultBoldFontWithSize: 13.0];
        [titleBtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
//        [titleBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:titleBtn];
//
//        //test
//        //            titleBtn.backgroundColor = [UIColor redColor];
//
//
//
//
//        imgBtn.tag = i;
//
//        if(i == 2){
//            imgBtn.frame = CGRectMake(0, 5, 50, 32);
//            UIImage *img = [BundleUtil getCurrentBundleImageByName:@"mt_publish"];
//            [imgBtn setImage:img  forState:UIControlStateNormal];
//        }
//        imgBtn.left = (btn.width - imgBtn.width)/2;
//        [btn addSubview:imgBtn];
//        [imgBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self.buttons addObject:btn];
//        [self addSubview:btn];
        
        
        offX += width;

    }
    
    
    
    //for()
    
    
    return self.viewHeadBg;
}

#pragma mark ------ initRequest  ------

-(void)initRequest{
    
    NetWork_mt_getFollows *request = [[NetWork_mt_getFollows alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.pageNo = @"1";
    request.pageSize = @"20";
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*
         *暂不考虑缓存问题
         */
    } finishBlock:^(GetFollowsResponse *result, NSString *msg, BOOL finished) {
        NSLog(@"");
        
        [self.mainDataArr addObjectsFromArray:result.obj];
        [self.mainTableView reloadData];
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
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[MessageCell cellId] forIndexPath:indexPath];
        GetFollowsModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
//        cell.homeDelegate = self;
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
    
    return ZJMessageCellHeight;
}


@end
