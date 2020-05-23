//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "MTChangeViewAreaViewController.h"
#import "STPickerArea.h"


@interface MTChangeViewAreaViewController ()<STPickerAreaDelegate>


@end

@implementation MTChangeViewAreaViewController

#pragma mark =========== 懒加载 ===========

-(NSMutableArray*)arrayhotSpotStrs{
    if(!_arrayhotSpotStrs){
        _arrayhotSpotStrs = [[NSMutableArray alloc] init];
    }
    return _arrayhotSpotStrs;
}

-(NSMutableArray*)arrayhotSpotModel{
    if(!_arrayhotSpotModel){
        _arrayhotSpotModel = [[NSMutableArray alloc] init];
    }
    return _arrayhotSpotModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [UIApplication sharedApplication].statusBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)initNavTitle{
    
    self.isNavBackGroundHiden = NO;
    self.navBackGround.height = kNavBarHeight_New; //状态栏的高度
    self.navBackGround.backgroundColor = ColorThemeBackground;

    self.title = @"切换景区";
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = BigBoldFont; //[UIFont defaultBoldFontWithSize:16];
}

-(void)dealloc{
    /*
     *移除页面中的观察者
     */
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initRequestHotScenic];
}

#pragma mark ------ 网络请求  ------

-(void)initRequestHotScenic{
    
    NetWork_mt_scenic_getHotScenicList *request = [[NetWork_mt_scenic_getHotScenicList alloc] init];
    request.pageNo = @"1";
    request.pageSize = @"5";
    [request startGetWithBlock:^(ScenicGetHotScenicListResponse *result, NSString *msg, BOOL finished) {
        
        NSLog(@"--------");
        
        if(finished){
            [self.arrayhotSpotModel addObjectsFromArray:result.obj];
            for(ScenicModel *model in self.arrayhotSpotModel){
                [self.arrayhotSpotStrs addObject:model.scenicName];
            }
            
            [self refreshScenicInfo];
        }
        else{
            [UIWindow showTips:msg];
        }
        
    }];
}

-(void)refreshScenicInfo{
    
    
    UIView *headView = self.mainTableView.tableHeaderView;
    
    
    //景区扩展属性栏目
    UIView *viewHotSpot  = [headView viewWithTag:999];
    UIView *spotBgView = [viewHotSpot viewWithTag:997]; //tag背景View
    if(spotBgView){
        self.tagsFrame = [[TagsFrame alloc] initWithWidth:spotBgView.width];
        self.tagsFrame.tagsMinPadding = 12;
        self.tagsFrame.tagsMargin = 20;
        self.tagsFrame.tagsLineSpacing = 10;
        self.tagsFrame.tagsArray = self.arrayhotSpotStrs;
        spotBgView.height = [self.tagsFrame tagsHeight];
        [spotBgView removeAllSubviews];
        for (NSInteger i=0; i<self.arrayhotSpotStrs.count; i++) {
            
            UIButton *tagsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagsBtn.tag = i;
            [tagsBtn setTitle:self.arrayhotSpotStrs[i] forState:UIControlStateNormal];
            [tagsBtn setBackgroundColor:MTColorBtnNormal forState:UIControlStateNormal];
            [tagsBtn setBackgroundColor:MTColorBtnHighlighted forState:UIControlStateHighlighted];
            tagsBtn.layer.cornerRadius = 2.0f;
            tagsBtn.layer.masksToBounds = true;//给按钮添加边框效果
            [tagsBtn addTarget:self action:@selector(btnScenicBgClick:) forControlEvents:UIControlEventTouchUpInside];

            [tagsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            tagsBtn.titleLabel.font = TagsTitleFont;
            tagsBtn.layer.cornerRadius = 2;
            tagsBtn.layer.masksToBounds = YES;
            tagsBtn.frame = CGRectFromString(self.tagsFrame.tagsFrames[i]);
            
            [spotBgView addSubview:tagsBtn];
        }
    }
    viewHotSpot.height = spotBgView.bottom;
    
    
    UIView *viewSelectArea  = [headView viewWithTag:888];
    viewSelectArea.top = viewHotSpot.bottom + sizeScale(10);

    headView.height = viewSelectArea.bottom + sizeScale(10);
    self.mainTableView.tableHeaderView = headView;
}

#pragma mark ------ CustomMethod  ------

-(void)setupUI{
    self.view.backgroundColor = ColorThemeBackground;
    
    UIView *headView = [self getHeadView];
    
    self.mainTableView.top = kNavBarHeight_New;
    self.mainTableView.height = ScreenHeight - kNavBarHeight_New;
    self.mainTableView.mj_footer = nil;
    self.mainTableView.mj_header = nil;
    self.mainTableView.tableHeaderView = headView;
    
    [self.view addSubview:self.mainTableView];
}

- (UIView *)getHeadView{
    
    CGRect frame = CGRectMake(0, 0, self.view.width, 500);
    
    UIView *headview = [[UIView alloc] initWithFrame:frame];
    headview.backgroundColor = [UIColor clearColor];
    
    UIView *viewHotSpot = [self getHotSpotView:headview];
    UIView *viewSelectArea= [self getSelectAreaView:headview viewHotSpot:viewHotSpot];
//
    [headview addSubview:viewHotSpot];
    [headview addSubview:viewSelectArea];
    
    return headview;
}

-(UIView*)getHotSpotView:(UIView*)headview{
    
    //添加名称栏
    UIView *viewArea = [[UIView alloc] init];
    viewArea.tag = 999;
    viewArea.size = [UIView getSize_width:headview.width - sizeScale(10)*2 height:300];
    viewArea.left = sizeScale(10);
    viewArea.top = 0;
    viewArea.backgroundColor = ColorThemeBackground;
//    viewArea.layer.cornerRadius = 15;
    
    UILabel * lableName = [[UILabel alloc] init];
    lableName.tag = 998;
    lableName.size = [UIView getSize_width:viewArea.width - sizeScale(10)*2 height:30];
    lableName.right = viewArea.width - sizeScale(20);
    lableName.left = sizeScale(10);
    lableName.top = 0;
    lableName.font = [UIFont defaultBoldFontWithSize:20];
    lableName.clipsToBounds = YES;
    lableName.textColor = [UIColor whiteColor];
    lableName.textAlignment = NSTextAlignmentLeft;
    [viewArea addSubview:lableName];
    lableName.text = @"热门景区";

    
    
    UIView *hotBgView = [[UIView alloc] init];
    hotBgView.tag = 997;
    hotBgView.size = [UIView getSize_width:lableName.width height:0]; //初始化tag背景标签
    hotBgView.top = lableName.bottom;
    hotBgView.left = sizeScale(10);
    hotBgView.backgroundColor = [UIColor clearColor];
//    hotBgView.layer.borderWidth = 1.0f;
//    hotBgView.layer.borderColor = [UIColor blueColor].CGColor;
    [viewArea addSubview:hotBgView];
    
    viewArea.height = hotBgView.bottom + sizeScale(10);
    return viewArea;
    
}

-(UIView*)getSelectAreaView:(UIView*)headview viewHotSpot:(UIView*)viewHotSpot{
    
    //添加名称栏
    UIView *viewSelectArea= [[UIView alloc] init];
    viewSelectArea.tag = 888;
    viewSelectArea.size = [UIView getSize_width:headview.width - sizeScale(10)*2 height:200];
    viewSelectArea.left = sizeScale(10);
    viewSelectArea.top = viewHotSpot.bottom + sizeScale(10);
//    viewSelectArea.backgroundColor = [UIColor whiteColor];
//    viewSelectArea.layer.cornerRadius = 15;
    
    UILabel * lableName = [[UILabel alloc] init];
    lableName.size = [UIView getSize_width:120 height:30];
    lableName.right = viewHotSpot.width - sizeScale(20);
    lableName.left = sizeScale(10);
    lableName.top = 0;
    lableName.font = [UIFont defaultBoldFontWithSize:20];
    lableName.clipsToBounds = YES;
    lableName.textColor = [UIColor whiteColor];
    lableName.textAlignment = NSTextAlignmentLeft;
    lableName.text = @"选择地区";
    
    [viewSelectArea addSubview:lableName];
    
    UIView *viewSelectBg = [[UIView alloc] init];
        viewSelectBg.layer.borderWidth = 1.0f;
        viewSelectBg.layer.borderColor = [UIColor blueColor].CGColor;
    viewSelectBg.tag = 887;
    viewSelectBg.size = [UIView getSize_width:viewHotSpot.width - sizeScale(10)*2 height:200];
    viewSelectBg.left = sizeScale(10);
    viewSelectBg.top = lableName.bottom + 5;
    [viewSelectArea addSubview:viewSelectBg];
    
    
    STPickerArea *pickerArea = [[STPickerArea alloc]initWithFeame:viewSelectBg.bounds];
    [pickerArea setDelegate:self];
    [pickerArea setSaveHistory:YES];
    [pickerArea showWithFrame:viewSelectBg.bounds parentView:viewSelectBg];
    
    
    viewSelectArea.height = viewSelectBg.bottom + sizeScale(10);
    
    
    return viewSelectArea;
    
}


-(void)btnScenicBgClick:(UIButton*)btn{
    
    ScenicModel *model = [self.arrayhotSpotModel objectAtIndex:btn.tag];
    [GlobalData sharedInstance].curScenicModel = model;

    
    
//    NSDictionary *infoDic = @{@"scenicId":model.id};
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationUserChangeScenic object:nil];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
