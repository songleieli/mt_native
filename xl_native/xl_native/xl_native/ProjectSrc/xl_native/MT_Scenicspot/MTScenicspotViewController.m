//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "MTScenicspotViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CustomAnnotationView.h"
#import "LBPhotoBrowserManager.h"

@interface MTScenicspotViewController ()<MAMapViewDelegate,MyScrolDelegate>


@end

@implementation MTScenicspotViewController

#pragma mark =========== 懒加载 ===========

//- (MyScrollView *)scrolBanner{
//
//    if (!_scrolBanner) {
//        CGRect rect =  [UIView getFrame_x:0 y:0 width:ScreenWidth height:sizeScale(178)];
//        _scrolBanner = [[MyScrollView alloc] initWithFrame:rect];
//        _scrolBanner.isUrlImg = NO; //加载本地图片
//        _scrolBanner.isDisplayPageDefault = YES; //不显示pageControl
//        _scrolBanner.isAutoScroll = YES;
//        _scrolBanner.scrolDelegate = self;
//    }
//    return  _scrolBanner;
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.tabBar.top = [self getTabbarTop];    //  重新设置tabbar的高度
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden = YES;
    self.navBackGround.height = KStatusBarHeight_New; //状态栏的高度
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
    
    [self initRequest];
    
    //CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(40.106216,116.08518);//纬度，经度
    //
    //    [self addTestPoint:coords];
}

#pragma mark ------ CustomMethod  ------

-(void)setupUI{
    self.view.backgroundColor = ColorThemeBackground;
    [self.view addSubview:self.mainTableView];
    
    
    MAMapView *mapView = [self getHeadImageView];
    UIView *headView = [self getHeadView];
    
    self.mainTableView.contentInset = UIEdgeInsetsMake(mapView.height, 0, 0, 0);
    [self.mainTableView addSubview:mapView];
    
    self.mainTableView.top = 0;
    self.mainTableView.height = ScreenHeight - kTabBarHeight_New;
    self.mainTableView.mj_footer = nil;
    self.mainTableView.mj_header = nil;
    self.mainTableView.tableHeaderView = headView;
    
    [self.view addSubview:self.mainTableView];
    
    //模拟向下拉5像素，解决地图下方有个黑条的bug
    self.mainTableView.contentOffset = CGPointMake(0, -kHEIGHT-5);
}

-(void)refreshScenicInfo{
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([self.scenicModel.latitude floatValue],[self.scenicModel.longitude floatValue]);//纬度，经度
    [self addTestPoint:coords];
    
    UIView *headView = self.mainTableView.tableHeaderView;
    
    
    //景区扩展属性栏目
    UIView *viewArea  = [headView viewWithTag:999];
    UILabel *scenicsNameLib = [viewArea viewWithTag:998]; //景区名称
    UILabel *shotIntroduce = [viewArea viewWithTag:997]; //一句话介绍
    if(scenicsNameLib){
        scenicsNameLib.text = self.scenicModel.scenicName;
    }
    if(shotIntroduce){
        shotIntroduce.text = self.scenicModel.shortIntroduction;
    }
    
    UIView *tagBgView = [viewArea viewWithTag:995]; //tag背景View
    if(tagBgView){
        self.tagsFrame = [[TagsFrame alloc] initWithWidth:tagBgView.width];
        self.tagsFrame.tagsMinPadding = 12;
        self.tagsFrame.tagsMargin = 5;
        self.tagsFrame.tagsLineSpacing = 5;
        self.tagsFrame.tagsArray = self.scenicModel.labels;
        
        tagBgView.height = [self.tagsFrame tagsHeight];
        //   -10 目的：让viewBg向左移动10使第一个相册d左对齐
        //                tagBgView.left = sizeScale(10);
        
        
        [tagBgView removeAllSubviews];
        for (NSInteger i=0; i<self.scenicModel.labels.count; i++) {
            
            UIButton *tagsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tagsBtn setTitle:self.scenicModel.labels[i] forState:UIControlStateNormal];
            if(i%2 == 0){
                tagsBtn.backgroundColor = XLColorTagColor;
            }
            else{
                tagsBtn.backgroundColor = XLColorMainPart;
            }
            [tagsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            tagsBtn.titleLabel.font = TagsTitleFont;
//            tagsBtn.layer.borderWidth = 1;
//            tagsBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            tagsBtn.layer.cornerRadius = 2;
            tagsBtn.layer.masksToBounds = YES;
            tagsBtn.frame = CGRectFromString(self.tagsFrame.tagsFrames[i]);
            
            [tagBgView addSubview:tagsBtn];
        }
    }
    
    
    UIView *viewDynamicAttr = [viewArea viewWithTag:996];
    viewDynamicAttr.top = tagBgView.bottom + sizeScale(10);
    
    //循环添加动态属性
    [viewDynamicAttr removeAllSubviews];//先清空，旧数据
    
    CGFloat dynamicAttrcellHeight = 20.0f;
    CGFloat dynamicAttrcellTop = 0;
    CGFloat dynamicAttrcellSpace = 5.0f;
    
    for(int i=0;i<self.scenicModel.dynamicAttributes.count; i ++){
        ScenicDynamicAttributesModel *model = [self.scenicModel.dynamicAttributes objectAtIndex:i];
        
        VUILable * titleLib = [[VUILable alloc] init];
        titleLib.size = [UIView getSize_width:80 height:dynamicAttrcellHeight];
        titleLib.left = 0;
        titleLib.top = i==0?dynamicAttrcellTop:dynamicAttrcellTop + dynamicAttrcellSpace;
        titleLib.font = [UIFont defaultFontWithSize:13];
        titleLib.clipsToBounds = YES;
        titleLib.textColor = [UIColor blackColor];
        titleLib.textAlignment = NSTextAlignmentLeft;
        titleLib.verticalAlignment = VerticalAlignmentTop;
        titleLib.text = [NSString stringWithFormat:@"%@:",model.title];
        [viewDynamicAttr addSubview:titleLib];
        
        
        UILabel * contentLib = [[UILabel alloc] init];
        contentLib.numberOfLines = 0; // 需要把显示行数设置成无限制
        contentLib.size = [UIView getSize_width:viewDynamicAttr.width -titleLib.width  height:dynamicAttrcellHeight];
        contentLib.left = titleLib.right;
        contentLib.top = titleLib.top;
        contentLib.font = [UIFont defaultFontWithSize:13];
        contentLib.clipsToBounds = YES;
        contentLib.textColor = [UIColor blackColor];
        contentLib.textAlignment = NSTextAlignmentLeft;
        contentLib.text = [NSString stringWithFormat:@"%@:",model.content];
        [viewDynamicAttr addSubview:contentLib];
        
        //自适应高度
        CGSize size = [GlobalFunc sizeWithText:contentLib.text font:contentLib.font size:CGSizeMake(contentLib.width, 8000)];
        contentLib.height = size.height;
        
        if(titleLib.height >= contentLib.height){
            viewDynamicAttr.height = titleLib.bottom;
            dynamicAttrcellTop += titleLib.height+dynamicAttrcellSpace;
        }
        else{
            viewDynamicAttr.height = contentLib.bottom;
            dynamicAttrcellTop += contentLib.height+dynamicAttrcellSpace;
        }
    }
    viewArea.height = viewDynamicAttr.bottom + sizeScale(10);
    
    //票务信息栏
    UIView *ticketView  = [headView viewWithTag:888];
    ticketView.top = viewArea.bottom + sizeScale(10);
    UIView *viewTicketBg = [ticketView viewWithTag:887];
    
    CGFloat ticketInfoCellHeight = 20.0f;
    CGFloat ticketInfoCellTop = 0;
    CGFloat ticketInfoCellSpace = 5.0f;

    for(int i=0;i<self.scenicModel.ticketInfos.count; i ++){
        ScenicTicketInfoModel *model = [self.scenicModel.ticketInfos objectAtIndex:i];
        
        VUILable * titleLib = [[VUILable alloc] init];
        titleLib.size = [UIView getSize_width:80 height:ticketInfoCellHeight];
        titleLib.left = 0;
        titleLib.top = ticketInfoCellTop + ticketInfoCellSpace;
        titleLib.font = [UIFont defaultFontWithSize:13];
        titleLib.clipsToBounds = YES;
        titleLib.textColor = [UIColor blackColor];
        titleLib.textAlignment = NSTextAlignmentLeft;
        titleLib.verticalAlignment = VerticalAlignmentTop;
        titleLib.text = [NSString stringWithFormat:@"%@:",model.title];
        [viewTicketBg addSubview:titleLib];
        
        
        UILabel * contentLib = [[UILabel alloc] init];
        contentLib.numberOfLines = 0; // 需要把显示行数设置成无限制
        contentLib.size = [UIView getSize_width:viewDynamicAttr.width -titleLib.width  height:ticketInfoCellHeight];
        contentLib.left = titleLib.right;
        contentLib.top = titleLib.top;
        contentLib.font = [UIFont defaultFontWithSize:13];
        contentLib.clipsToBounds = YES;
        contentLib.textColor = [UIColor blackColor];
        contentLib.textAlignment = NSTextAlignmentLeft;
        contentLib.text = [NSString stringWithFormat:@"%@:",model.content];
        [viewTicketBg addSubview:contentLib];
        
        //自适应高度
        CGSize size = [GlobalFunc sizeWithText:contentLib.text font:contentLib.font size:CGSizeMake(contentLib.width, 8000)];
        contentLib.height = size.height;
        
        if(titleLib.height >= contentLib.height){
            viewTicketBg.height = titleLib.bottom;
            ticketInfoCellTop += titleLib.height+ticketInfoCellSpace;
        }
        else{
            viewTicketBg.height = contentLib.bottom;
            ticketInfoCellTop += contentLib.height+ticketInfoCellSpace;
        }
    }
    ticketView.height = viewTicketBg.bottom + sizeScale(10);
    
    //景区介绍
    UIView *scenIntroduceView  = [headView viewWithTag:777];
    scenIntroduceView.top = ticketView.bottom + sizeScale(10);
    
    UILabel * lableScenIntroduce = [scenIntroduceView viewWithTag:776];
    if(lableScenIntroduce){
        lableScenIntroduce.text = self.scenicModel.introduction;
        
        //自适应高度
        CGSize size = [GlobalFunc sizeWithText:lableScenIntroduce.text font:lableScenIntroduce.font size:CGSizeMake(lableScenIntroduce.width, 8000)];
        lableScenIntroduce.height = size.height;

    }
    
    if(self.scenicModel.images.count > 0){
        
        self.scrolBanner.top = lableScenIntroduce.bottom + sizeScale(10);
            NSMutableArray *muArrViews = [NSMutableArray array];
            for(NSString *url in self.scenicModel.images){
                NSString *weblUrl = [NSString stringWithFormat:@"%@%@",[WCBaseContext sharedInstance].appInterfaceServer,url];
                
                [muArrViews addObject:weblUrl];
            }
            self.scrolBanner.isUrlImg = YES;
            [self.scrolBanner reloadData:muArrViews];
    }
    scenIntroduceView.height = self.scrolBanner.bottom + sizeScale(10);

    
    //景点列表
    UIView *scenSpotListView   = [headView viewWithTag:666];
    scenSpotListView.top = scenIntroduceView.bottom + sizeScale(10);
    UIView *scenSpotListBg = [scenSpotListView viewWithTag:665];
    CGFloat spotCellHeight = 30.0f;

    
    for(int i=0;i<self.scenicModel.spots.count; i ++){
        ScenicSpotModel *model = [self.scenicModel.spots objectAtIndex:i];
        
        UILabel * titleLib = [[UILabel alloc] init];
        titleLib.size = [UIView getSize_width:80 height:spotCellHeight];
        titleLib.left = 0;
        titleLib.top = i*spotCellHeight;
        titleLib.font = [UIFont defaultFontWithSize:13];
        titleLib.clipsToBounds = YES;
        titleLib.textColor = [UIColor blackColor];
        titleLib.textAlignment = NSTextAlignmentLeft;
        titleLib.text = [NSString stringWithFormat:@"%@:",model.spotsName];
        [scenSpotListBg addSubview:titleLib];
        
        //        titleLib.backgroundColor = [UIColor blueColor];
        
        
        UILabel * contentLib = [[UILabel alloc] init];
        contentLib.size = [UIView getSize_width:viewDynamicAttr.width -titleLib.width  height:spotCellHeight];
        contentLib.left = titleLib.right;
        contentLib.top = i*spotCellHeight;
        contentLib.font = [UIFont defaultFontWithSize:13];
        contentLib.clipsToBounds = YES;
        contentLib.textColor = [UIColor blackColor];
        contentLib.textAlignment = NSTextAlignmentRight;
        contentLib.text = @"距您100米";//[NSString stringWithFormat:@"%@:",model.spotsIntroduce];
        [scenSpotListBg addSubview:contentLib];
        
        scenSpotListBg.height = titleLib.bottom;
    }
    scenSpotListView.height = scenSpotListBg.bottom + sizeScale(10);
    
    
    headView.height = scenSpotListView.bottom + sizeScale(10)+80;
    self.mainTableView.tableHeaderView = headView;
}

-(void)initRequest {
    
    NetWork_mt_scenic_getScenicById *request = [[NetWork_mt_scenic_getScenicById alloc] init];
    request.id = @"3";
    request.nsukey = @"GkcKRDlRgk8DgNW8EWyzIxT5VtfFRIHfJeaBalKhSSB08hTXFhG3Di9TDaQMBXEHiz3fI3bbzeM1dYTJGJ1ABV0uMQ6HL7TdcZf6abuTExe9M%2BuGnXN3m5k64kJaGsWmzvZMabc8NkOgrwPankl1lG3qz7Ist3DMUK8NTereVLVrilomN7teGj%2BrsSp%2BlbdBz9uRi2gHocbY5loywQj8jA%3D%3D";
    [request startGetWithBlock:^(ScenicGetScenicByIdResponse *result, NSString *msg) {
        /*
         缓存暂时先不用考虑
         */
    } finishBlock:^(ScenicGetScenicByIdResponse *result, NSString *msg, BOOL finished) {
        
        
        
        if(finished){
            self.scenicModel = result.obj;
            [self refreshScenicInfo];
        }
        else{
            [UIWindow showTips:msg];
        }
    }];
}

- (MAMapView *)getHeadImageView{
    
    
    MAMapView * mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, -kHEIGHT, [UIScreen mainScreen].bounds.size.width, kHEIGHT)];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    
    
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHEIGHT, [UIScreen mainScreen].bounds.size.width, kHEIGHT)];
    //    imageView.image = [UIImage imageNamed:@"my_head"];
    //    imageView.contentMode = UIViewContentModeScaleAspectFill;
    mapView.tag = 101;
    
    return mapView;
}

- (UIView *)getHeadView{
    
    CGRect frame = CGRectMake(0, 0, self.view.width, 1500);
    
    UIView *headview = [[UIView alloc] initWithFrame:frame];
    headview.backgroundColor = RGBA(245, 245, 245, 1);
    
    UIView *viewArea = [self getviewAreaView:headview];
    UIView *viewTicket = [self getviewTicketView:headview viewArea:viewArea];
    UIView *scenIntroduceView = [self getScenIntroduceView:headview viewArea:viewTicket];
    UIView *scenSpotListView = [self getScenSpotListView:headview viewArea:scenIntroduceView];
    
    [headview addSubview:viewArea];
    [headview addSubview:viewTicket];
    [headview addSubview:scenIntroduceView];
    [headview addSubview:scenSpotListView];
    
    return headview;
}

-(UIView*)getviewAreaView:(UIView*)headview{
    
    //添加名称栏
    UIView *viewArea = [[UIView alloc] init];
    viewArea.tag = 999;
    viewArea.size = [UIView getSize_width:headview.width - sizeScale(10)*2 height:300];
    viewArea.left = sizeScale(10);
    viewArea.top = -sizeScale(25);
    viewArea.backgroundColor = [UIColor whiteColor];
    viewArea.layer.cornerRadius = 15;
    
    UILabel * lableName = [[UILabel alloc] init];
    lableName.tag = 998;
    lableName.size = [UIView getSize_width:viewArea.width - sizeScale(10)*2 height:30];
    lableName.right = viewArea.width - sizeScale(20);
    lableName.left = sizeScale(10);
    lableName.top = sizeScale(10);
    lableName.font = [UIFont defaultBoldFontWithSize:25];
    lableName.clipsToBounds = YES;
    lableName.textColor = [UIColor blackColor];
    lableName.textAlignment = NSTextAlignmentLeft;
    [viewArea addSubview:lableName];
    

    UILabel * shotIntroduce = [[UILabel alloc] init];
    shotIntroduce.tag = 997;
    shotIntroduce.size = [UIView getSize_width:viewArea.width - sizeScale(10)*2 height:30];
    shotIntroduce.right = viewArea.width - sizeScale(20);
    shotIntroduce.left = lableName.left;
    shotIntroduce.top = lableName.bottom + 5;
    shotIntroduce.font = [UIFont defaultFontWithSize:13];
    shotIntroduce.clipsToBounds = YES;
    shotIntroduce.textColor = [UIColor blackColor];
    shotIntroduce.textAlignment = NSTextAlignmentLeft;
    [viewArea addSubview:shotIntroduce];
    
    
    UIView *tagBgView = [[UIView alloc] init];
    tagBgView.tag = 995;
    tagBgView.size = [UIView getSize_width:shotIntroduce.width height:0]; //初始化tag背景标签
    tagBgView.top = shotIntroduce.bottom;
    tagBgView.left = sizeScale(10);
    tagBgView.backgroundColor = [UIColor clearColor];
    
    [viewArea addSubview:tagBgView];

    
    
    UIView *viewDynamicAttr = [[UIView alloc] init];
    viewDynamicAttr.tag = 996;
    viewDynamicAttr.size = [UIView getSize_width:viewArea.width - sizeScale(10)*2 height:300];
    viewDynamicAttr.left = sizeScale(10);
    viewDynamicAttr.top = shotIntroduce.bottom + 5;
    [viewArea addSubview:viewDynamicAttr];
    
    viewArea.height = viewDynamicAttr.bottom + sizeScale(10);
    return viewArea;
    
}

-(UIView*)getviewTicketView:(UIView*)headview viewArea:(UIView*)viewArea{
    
    //添加名称栏
    UIView *viewTicket= [[UIView alloc] init];
    viewTicket.tag = 888;
    viewTicket.size = [UIView getSize_width:headview.width - sizeScale(10)*2 height:300];
    viewTicket.left = sizeScale(10);
    viewTicket.top = viewArea.bottom + sizeScale(10);
    viewTicket.backgroundColor = [UIColor whiteColor];
    viewTicket.layer.cornerRadius = 15;
    
    UILabel * lableName = [[UILabel alloc] init];
    lableName.size = [UIView getSize_width:120 height:30];
    lableName.right = viewArea.width - sizeScale(20);
    lableName.left = sizeScale(10);
    lableName.top = sizeScale(10);
    lableName.font = [UIFont defaultBoldFontWithSize:25];
    lableName.clipsToBounds = YES;
    lableName.textColor = [UIColor blackColor];
    lableName.textAlignment = NSTextAlignmentLeft;
    lableName.text = @"票务信息";
    
    [viewTicket addSubview:lableName];
    
    UIView *viewTicketBg = [[UIView alloc] init];
    viewTicketBg.tag = 887;
    viewTicketBg.size = [UIView getSize_width:viewArea.width - sizeScale(10)*2 height:300];
    viewTicketBg.left = sizeScale(10);
    viewTicketBg.top = lableName.bottom + 5;
    [viewTicket addSubview:viewTicketBg];
    
    viewTicket.height = viewTicketBg.bottom + sizeScale(10);
    
    
    return viewTicket;
    
}

-(UIView*)getScenIntroduceView:(UIView*)headview viewArea:(UIView*)viewTicket{
    
    //添加名称栏
    UIView *scenIntroduceView= [[UIView alloc] init];
    scenIntroduceView.tag = 777;
    scenIntroduceView.size = [UIView getSize_width:headview.width - sizeScale(10)*2 height:300];
    scenIntroduceView.left = sizeScale(10);
    scenIntroduceView.top = viewTicket.bottom + sizeScale(10);
    scenIntroduceView.backgroundColor = [UIColor whiteColor];
    scenIntroduceView.layer.cornerRadius = 15;
    
    UILabel * lableName = [[UILabel alloc] init];
    lableName.size = [UIView getSize_width:120 height:30];
    lableName.right = scenIntroduceView.width - sizeScale(20);
    lableName.left = sizeScale(10);
    lableName.top = sizeScale(10);
    lableName.font = [UIFont defaultBoldFontWithSize:25];
    lableName.clipsToBounds = YES;
    lableName.textColor = [UIColor blackColor];
    lableName.textAlignment = NSTextAlignmentLeft;
    lableName.text = @"景区介绍";
    [scenIntroduceView addSubview:lableName];
    
    UILabel * lableScenIntroduce = [[UILabel alloc] init];
    lableScenIntroduce.tag = 776;
    lableScenIntroduce.numberOfLines = 0; // 需要把显示行数设置成无限制
    lableScenIntroduce.size = [UIView getSize_width:scenIntroduceView.width - sizeScale(10)*2   height:30];
    lableScenIntroduce.left = lableName.left;
    lableScenIntroduce.top = lableName.bottom + sizeScale(10);
    lableScenIntroduce.font = [UIFont defaultFontWithSize:13];
    lableScenIntroduce.clipsToBounds = YES;
    lableScenIntroduce.textColor = [UIColor blackColor];
    lableScenIntroduce.textAlignment = NSTextAlignmentLeft;
    [scenIntroduceView addSubview:lableScenIntroduce];
    
    
    CGRect rect =  [UIView getFrame_x:lableScenIntroduce.left y:lableScenIntroduce.bottom + sizeScale(10)
                                width:lableScenIntroduce.width height:sizeScale(150)];
    
    self.scrolBanner = [[MyScrollView alloc] initWithFrame:rect];
    self.scrolBanner.isUrlImg = YES; //加载本地图片
    self.scrolBanner.isDisplayPageDefault = YES; //是否显示pageControl
    self.scrolBanner.isAutoScroll = YES;
    self.scrolBanner.scrolDelegate = self;
    
    [scenIntroduceView addSubview:self.scrolBanner];
    
    //    UIView *viewTicketBg = [[UIView alloc] init];
    //    viewTicketBg.tag = 887;
    //    viewTicketBg.size = [UIView getSize_width:viewArea.width - sizeScale(10)*2 height:300];
    //    viewTicketBg.left = sizeScale(10);
    //    viewTicketBg.top = lableName.bottom + 5;
    //    [viewTicket addSubview:viewTicketBg];
    //
    //    viewTicket.height = viewTicketBg.bottom + sizeScale(10);
    
    
    return scenIntroduceView;
    
}

-(UIView*)getScenSpotListView:(UIView*)headview viewArea:(UIView*)scenIntroduceView{
    
    //添加名称栏
    UIView *scenSpotListView= [[UIView alloc] init];
    scenSpotListView.tag = 666;
    scenSpotListView.size = [UIView getSize_width:headview.width - sizeScale(10)*2 height:300];
    scenSpotListView.left = sizeScale(10);
    scenSpotListView.top = scenIntroduceView.bottom + sizeScale(10);
    scenSpotListView.backgroundColor = [UIColor whiteColor];
    scenSpotListView.layer.cornerRadius = 15;
    
    UILabel * lableName = [[UILabel alloc] init];
    lableName.size = [UIView getSize_width:120 height:30];
    lableName.right = scenIntroduceView.width - sizeScale(20);
    lableName.left = sizeScale(10);
    lableName.top = sizeScale(10);
    lableName.font = [UIFont defaultBoldFontWithSize:25];
    lableName.clipsToBounds = YES;
    lableName.textColor = [UIColor blackColor];
    lableName.textAlignment = NSTextAlignmentLeft;
    lableName.text = @"景点列表";
    
    [scenSpotListView addSubview:lableName];
    
    UIView *scenSpotListBg = [[UIView alloc] init];
    scenSpotListBg.tag = 665;
    scenSpotListBg.size = [UIView getSize_width:scenSpotListView.width - sizeScale(10)*2 height:300];
    scenSpotListBg.left = sizeScale(10);
    scenSpotListBg.top = lableName.bottom + 5;
    [scenSpotListView addSubview:scenSpotListBg];
    
    scenSpotListView.height = scenSpotListBg.bottom + sizeScale(10);
    
    return scenSpotListView;
}

-(void)addTestPoint:(CLLocationCoordinate2D) coords{
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coords;
    annotation.title    = @"凤凰岭";
    annotation.subtitle = @"北京大自然的空调";
    
    MAMapView *mapView = [self.mainTableView viewWithTag:101];
    if(mapView){
        [mapView addAnnotation:annotation];
        mapView.centerCoordinate = coords;
    }
}

#pragma -mark ------- UIScrollViewDelegate -------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint point = scrollView.contentOffset;
    
    //    NSLog(@"%@",NSStringFromCGPoint(point));
    
    if (point.y < - kHEIGHT) {
        
        MAMapView *imageView = [self.mainTableView viewWithTag:101];
        if(imageView){
            
            CGRect rect = imageView.frame;
            rect.origin.y = point.y;
            rect.size.height = -point.y;
            imageView.frame = rect;
        }
    }
    
    UIView *headview = self.mainTableView.tableHeaderView;
    if(headview){
        [self.mainTableView bringSubviewToFront:headview];
    }
}

#pragma mark -------- MyScrolDelegate -------

- (void)myScrolView:(MyScrollView *)scrol didSelectedImgWithRow:(NSInteger)row{
    
    
    NSMutableArray *items = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < self.scenicModel.images.count; i++) {
//           LBURLModel *urlModel = cellModel.urls[i];
//           UIImageView *imageView = cell.imageViews[i];
        
        NSString *weblUrl = [NSString stringWithFormat:@"%@%@",[WCBaseContext sharedInstance].appInterfaceServer,[self.scenicModel.images objectAtIndex:i]];

            LBPhotoWebItem *item = [[LBPhotoWebItem alloc]initWithURLString:weblUrl frame:scrol.frame];
            [items addObject:item];
        }
     [LBPhotoBrowserManager.defaultManager showImageWithWebItems:items selectedIndex:row fromImageViewSuperView:scrol].lowGifMemory = YES;
     [[LBPhotoBrowserManager defaultManager]addPhotoBrowserWillDismissBlock:^{
       // do something
      }].needPreloading = NO;
    
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        
        annotationView.portrait = [UIImage imageNamed:@"login_icon"];
        annotationView.name     = @"凤凰岭";
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    //点击标注的点
    /* Adjust the map center in order to show the callout view completely. */
    //    if ([view isKindOfClass:[CustomAnnotationView class]]) {
    //        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
    //        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
    //
    //        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
    //
    //        if (!CGRectContainsRect(self.mapView.frame, frame))
    //        {
    //            /* Calculate the offset to make the callout view show up. */
    //            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
    //
    //            CGPoint theCenter = self.mapView.center;
    //            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
    //
    //            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
    //
    //            [self.mapView setCenterCoordinate:coordinate animated:YES];
    //        }
    //    }
}


@end
