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

@interface MTScenicspotViewController ()<MAMapViewDelegate>


@end

@implementation MTScenicspotViewController

#pragma mark =========== 懒加载 ===========

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
    
CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(40.106216,116.08518);//纬度，经度
    
    [self addTestPoint:coords];
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
    
    
    [headview addSubview:viewArea];
    [headview addSubview:viewTicket];

    
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
    lableName.size = [UIView getSize_width:120 height:30];
    lableName.right = viewArea.width - sizeScale(20);
    lableName.left = sizeScale(10);
    lableName.top = sizeScale(10);
    lableName.font = [UIFont defaultBoldFontWithSize:25];
    lableName.clipsToBounds = YES;
    lableName.textColor = [UIColor blackColor];
    lableName.textAlignment = NSTextAlignmentLeft;
    lableName.text = @"凤凰岭";

    [viewArea addSubview:lableName];
    return viewArea;
    
}

-(UIView*)getviewTicketView:(UIView*)headview viewArea:(UIView*)viewArea{
    
    //添加名称栏
    UIView *viewTicket= [[UIView alloc] init];
    viewTicket.tag = 998;
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

    return viewTicket;
    
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
