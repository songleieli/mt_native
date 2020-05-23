//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "MTSpotViewController.h"
#import "LBPhotoBrowserManager.h"


@interface MTSpotViewController ()


@end

@implementation MTSpotViewController

#pragma mark =========== 懒加载 ===========

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [self refreshScenicInfo];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden = NO;
    self.navBackGround.height = kNavBarHeight_New; //状态栏的高度
    
    self.navBackGround.backgroundColor = ColorThemeBackground;
    
    self.title = @"景点";
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:20];
    self.lableNavTitle.textColor = [UIColor whiteColor];
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
}

#pragma mark ------ CustomMethod  ------

-(void)setupUI{
    self.view.backgroundColor = ColorThemeBackground;

    self.title = self.model.spotsName;

    MAMapView *mapView = [self getHeadImageView];
    UIView *headView = [self getHeadView];
    
    self.mainTableView.contentInset = UIEdgeInsetsMake(mapView.height, 0, 0, 0);
    [self.mainTableView addSubview:mapView];
    
    self.mainTableView.top = kNavBarHeight_New;
    self.mainTableView.height = ScreenHeight - kNavBarHeight_New;
    self.mainTableView.mj_footer = nil;
    self.mainTableView.mj_header = nil;
    self.mainTableView.tableHeaderView = headView;
    
    [self.view addSubview:self.mainTableView];
    
    //模拟向下拉5像素，解决地图下方有个黑条的bug
    self.mainTableView.contentOffset = CGPointMake(0, -kHEIGHT-5);
}

- (MAMapView *)getHeadImageView{
    
    
    MAMapView * mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, -kHEIGHT, [UIScreen mainScreen].bounds.size.width, kHEIGHT)];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    mapView.tag = 101;
    
    return mapView;
}

- (UIView *)getHeadView{
    
    CGRect frame = CGRectMake(0, 0, self.view.width, 1500);
    
    UIView *headview = [[UIView alloc] initWithFrame:frame];
    headview.backgroundColor = RGBA(245, 245, 245, 1);
    
    UIView *viewSpotIntro = [self getSpotIntroduceView:headview];
//    UIView *viewTicket = [self getviewTicketView:headview viewArea:viewArea];
//    UIView *scenIntroduceView = [self getScenIntroduceView:headview viewArea:viewTicket];
//    UIView *scenSpotListView = [self getScenSpotListView:headview viewArea:scenIntroduceView];
//    
    [headview addSubview:viewSpotIntro];
//    [headview addSubview:viewTicket];
//    [headview addSubview:scenIntroduceView];
//    [headview addSubview:scenSpotListView];
    
    return headview;
}

-(UIView*)getSpotIntroduceView:(UIView*)headview{
    
    //添加名称栏
    UIView *scenIntroduceView= [[UIView alloc] init];
    scenIntroduceView.tag = 999;
    scenIntroduceView.size = [UIView getSize_width:headview.width - sizeScale(10)*2 height:300];
    scenIntroduceView.left = sizeScale(10);
    scenIntroduceView.top = sizeScale(10);
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
    lableName.text = @"景点介绍";
    [scenIntroduceView addSubview:lableName];
    
    UILabel * lableScenIntroduce = [[UILabel alloc] init];
    lableScenIntroduce.tag = 998;
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

-(void)refreshScenicInfo{
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([self.model.latitude floatValue],[self.model.longitude floatValue]);//纬度，经度
    [self addTestPoint:coords];
    
    UIView *headView = self.mainTableView.tableHeaderView;
    
    
    //景区扩展属性栏目
    UIView *viewSpotIntrod  = [headView viewWithTag:999];
    
    UILabel * lableScenIntroduce = [viewSpotIntrod viewWithTag:998];
    if(lableScenIntroduce){
        lableScenIntroduce.text = self.model.spotsIntroduce;
        
        //自适应高度
        CGSize size = [GlobalFunc sizeWithText:lableScenIntroduce.text font:lableScenIntroduce.font size:CGSizeMake(lableScenIntroduce.width, 8000)];
        lableScenIntroduce.height = size.height;

    }
    if(self.model.spotsImages.count > 0){
        
        self.scrolBanner.top = lableScenIntroduce.bottom + sizeScale(10);
            NSMutableArray *muArrViews = [NSMutableArray array];
            for(NSString *url in self.model.spotsImages){
                NSString *weblUrl = [NSString stringWithFormat:@"%@%@",[WCBaseContext sharedInstance].appInterfaceServer,url];
                
                [muArrViews addObject:weblUrl];
            }
            self.scrolBanner.isUrlImg = YES;
            [self.scrolBanner reloadData:muArrViews];
    }
    viewSpotIntrod.height = self.scrolBanner.bottom + sizeScale(10);

    
    
    headView.height = viewSpotIntrod.bottom + sizeScale(10)+80;
    self.mainTableView.tableHeaderView = headView;
}

-(void)addTestPoint:(CLLocationCoordinate2D) coords{
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coords;
    annotation.title    = self.model.spotsName;
    annotation.subtitle = self.model.spotsName;
    
    MAMapView *mapView = [self.mainTableView viewWithTag:101];
    if(mapView){
        [mapView addAnnotation:annotation];
        mapView.centerCoordinate = coords;
    }
}

-(void)changeViewAreaClick{
    
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
    for (int i = 0 ; i < self.model.spotsImages.count; i++) {
//           LBURLModel *urlModel = cellModel.urls[i];
//           UIImageView *imageView = cell.imageViews[i];
        
        NSString *weblUrl = [NSString stringWithFormat:@"%@%@",[WCBaseContext sharedInstance].appInterfaceServer,[self.model.spotsImages objectAtIndex:i]];

            LBPhotoWebItem *item = [[LBPhotoWebItem alloc]initWithURLString:weblUrl frame:scrol.frame];
            [items addObject:item];
        }
     [LBPhotoBrowserManager.defaultManager showImageWithWebItems:items selectedIndex:row fromImageViewSuperView:scrol].lowGifMemory = YES;
     [[LBPhotoBrowserManager defaultManager]addPhotoBrowserWillDismissBlock:^{
       // do something
      }].needPreloading = NO;
    
}

@end
