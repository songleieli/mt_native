//
//  YCCustomViewController.m
//  YCBuddy
//
//  Created by bita on 15/5/26.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Hierarchy.h"
#import "UIButton+Create.h"
#import "GlobalFunc.h"
//#import "CMPLjhMobileAppDelegate.h"

#import "BaseNavigationController.h"

/*
 *有与升级Xcode9.0 后，发现第一次加载不显示 leftBarButtonItem 的问题，需要重写Navigatio
 */
#define isIOS9 ([[UIDevice currentDevice].systemVersion intValue]>=9?YES:NO)
#define isIOS10 ([[UIDevice currentDevice].systemVersion intValue]>=10?YES:NO)


@interface BaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray    *muArrRequest;//网络请求数组，这是需要开启控件的数组
@property (nonatomic, strong) MBProgressHUD     *progressHUD;//等待控件
@property (nonatomic, assign) NSInteger         topvalue;

@property (nonatomic, strong) NSMutableArray *arrayShowNotice;

@end

@implementation BaseViewController

+ (instancetype)classViewController {
    
    return [[[self class] alloc] init];
}

- (UIView *)navBackGround{
    
    if (!_navBackGround) {
        _navBackGround = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavBarHeight_New)];
        [self.view addSubview:_navBackGround];
    }
    return _navBackGround;
}

- (UILabel *)lableNavTitle{
    
    if (!_lableNavTitle) {
        _lableNavTitle = [[UILabel alloc] init];
        _lableNavTitle.width = self.navBackGround.width*0.64;
        _lableNavTitle.height = 50;
        _lableNavTitle.left = (self.navBackGround.width-_lableNavTitle.width)/2; //title水平居中
        _lableNavTitle.bottom = self.navBackGround.height;
        _lableNavTitle.font = [UIFont defaultFontWithSize:17];
        _lableNavTitle.textAlignment = NSTextAlignmentCenter;
        _lableNavTitle.textColor = [UIColor whiteColor];
        [self.navBackGround addSubview:_lableNavTitle];
        
    }
    return _lableNavTitle;
}

- (void)setTitle:(NSString *)title {
    self.lableNavTitle.text = title;
}

- (void)setTitleNavView:(UIView *)titleNavView{
    
    if(titleNavView){
        [_titleNavView removeFromSuperview];
        _titleNavView = nil;
        _titleNavView = titleNavView;
        
        titleNavView.bottom = self.navBackGround.height;
        titleNavView.left = (self.navBackGround.width - titleNavView.width)/2;
        
        [self.navBackGround addSubview:titleNavView];
    }
}

-(void)setIsNavBackGroundHiden:(BOOL)isNavBackGroundHiden{
    _isNavBackGroundHiden = isNavBackGroundHiden;
    self.navBackGround.hidden = isNavBackGroundHiden;
}


-(void)setBtnRight:(UIButton *)btnRight{
    if(_btnRight){
        [_btnRight removeFromSuperview];
        _btnRight = nil;
    }
    
    if(btnRight){
        [self.navBackGround addSubview:btnRight];
        _btnRight = btnRight;
    }
}

-(void)setBtnLeft:(UIButton *)btnLeft{
    
    if(_btnLeft){
        [_btnLeft removeFromSuperview];
        _btnLeft = nil;
    }
    if(btnLeft){
        [self.navBackGround addSubview:btnLeft];
        _btnLeft = btnLeft;
    }
}


#pragma mark - 进入下一页面
- (void)pushNewVC:(UIViewController *)newViewController
         animated:(BOOL)animated{
    //默认显示
    [self pushNewVC:newViewController animated:animated hideNav:NO];
}

- (void)pushNewVC:(UIViewController *)newViewController
         animated:(BOOL)animated
          hideNav:(BOOL)hideNav{
    [self pushNewVC:newViewController enableVC:nil animated:animated hideNav:hideNav];
}

#pragma mark - 到指定页面处理
- (void)pushNewVC:(UIViewController *)newViewController
         enableVC:(NSString *)enableViewControllerName
         animated:(BOOL)animated{
    //默认显示
    [self pushNewVC:newViewController enableVC:enableViewControllerName animated:animated hideNav:NO];
}

- (void)pushNewVC:(UIViewController *)newViewController
         enableVC:(NSString *)enableViewControllerName
         animated:(BOOL)animated
          hideNav:(BOOL)hideNav{
    
    if (newViewController == nil) {
        return;
    }
    
    NSMutableArray *muArrVC = [self.navigationController.viewControllers mutableCopy];
    if (enableViewControllerName) {
        for (int i = 0; i < muArrVC.count; ++i) {
            UIViewController *tempVC = (UIViewController *)muArrVC[i];
            if ([tempVC isKindOfClass:NSClassFromString(enableViewControllerName)]) {
                /*
                 如果需要删除的长度为0，那么不需要删除，直接返回。 add by songlei , IOS 7 上点击返回没有反应。
                 */
                
                NSInteger count = muArrVC.count-i-1;
                if(count > 0){
                    NSRange range = NSMakeRange(i+1, muArrVC.count-i-1);
                    [muArrVC removeObjectsInRange:range];
                    break;
                }
            }
        }
    }
    
    if (muArrVC.count == self.navigationController.viewControllers.count) {
        newViewController.fd_prefersNavigationBarHidden = hideNav;
        [self.navigationController pushViewController:newViewController animated:animated];
    } else {
        [muArrVC addObject:newViewController];
        newViewController.fd_prefersNavigationBarHidden = hideNav;
        [self.navigationController setViewControllers:muArrVC animated:animated];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.muArrRequest = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];

    //返回按钮
    if ([self.navigationController.viewControllers firstObject] != self){
        [self addLeftBtn];
    }
    [self initNavTitle];
}

- (void)initNavTitle{
    //do nothing 在子类中重载该方法。
}

- (void)addLeftBtn{
    
    _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLeft.size = CGSizeMake(50, 50 );
    _btnLeft.left = 0;
    _btnLeft.top = self.navBackGround.height -self.btnLeft.height;
   _btnLeft.backgroundColor = [UIColor clearColor];
    [_btnLeft setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
    [_btnLeft addTarget:self action:@selector(LeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackGround addSubview:_btnLeft];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]init];
}

-(void)setExclusiveTouchForButtons:(UIView *)myView{
    
    for (UIView * v in [myView subviews]) {
        if([v isKindOfClass:[UIButton class]])
            [((UIButton *)v) setExclusiveTouch:YES];
        else if ([v isKindOfClass:[UIView class]]){
            [self setExclusiveTouchForButtons:v];
        }
    }
}

- (void)LeftBtnClicked:(UIButton *)sender{
    
    [self.view endEditing:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    if (self.presentingViewController) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma -mark WCServiceJrLoanDelegate

- (void)startWithCursor:(NSString*)msg{
    
    NSString *selfName = NSStringFromClass([self class]);
    
    [self startWithCursor:msg interfaceName:selfName];
    
}

- (void)stopWatiCursor{
    
    NSString *selfName = NSStringFromClass([self class]);
    
    [self stopWatiCursor:selfName];
}

- (void)startWithCursor:(NSString*)msg interfaceName:(NSString *)interfaceName{
    if(![msg isKindOfClass:[NSString class]] || msg.trim.length == 0 || [msg.trim isEqualToString:@""]){
        return;
    }
    
    if(self.arrayShowNotice == nil){
        self.arrayShowNotice = [[NSMutableArray alloc]init];
    }
    [self.arrayShowNotice addObject:interfaceName];
    
    
    if([msg isKindOfClass:[NSString class]] && msg.trim.length > 0 && self.showNotice == nil){
        self.showNotice = [ShowNotice showView:self.view frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) msg:msg];
    }
    [self.showNotice setNoticeMsg:msg];
}
- (void)stopWatiCursor:(NSString*)interfaceName{
    [self.arrayShowNotice removeObject:interfaceName];
    if(self.arrayShowNotice.count == 0 && self.showNotice != nil){
        [self.showNotice hideNoticeAnimated:YES];
        self.showNotice = nil;
    }
}

- (void)handleTokenOverdue:(NSString *)msg{
    /*
     *处理token 过期，清空账号信息，弹出登录页面。
     */
    [GlobalData cleanAccountInfo];
//    [[ZJLoginService sharedInstance] authenticateWithCompletion:nil cancelBlock:nil isAnimat:YES];
}

#pragma mark - 等待控件

- (BOOL)createHUD{  //alloc一个等待控件出来
    
    if (_progressHUD){
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:_progressHUD];
    return YES;
}

- (void)showFaliureHUD:(NSString *)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(message != nil && message.trim.length > 0){
            [self createHUD];
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.detailsLabelText = message;
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.5];
        }
    });
}

- (void)hideHUDWaitView:(BOOL)animation{
    [_progressHUD hide:animation];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - touches delegeate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg{
    [self showAlertWithTitle:title msg:msg cancelBtn:@"取消" otherBtn:@"确定" delegate:self tag:0];
}

- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg cancelBtn:(NSString *)cacel otherBtn:(NSString *)other delegate:(id<UIAlertViewDelegate>)del tag:(NSInteger)tag{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:cacel otherButtonTitles:other, nil];
    [alert setTag:tag];
    [alert show];
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

//iOS 6.0以下
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}





#pragma mark -  main UITableView

/**
 *  懒加载mainDataArr
 *
 *  @return UITableView
 */
- (NSMutableArray *)mainDataArr {
    if (!_mainDataArr) {
        _mainDataArr = [[NSMutableArray alloc] init];
    }
    return _mainDataArr;
}

/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (MJTableView *)mainTableView{
    
    if (_mainTableView == nil) {
        
        _mainTableView = [[MJTableView alloc] initWithFrame:self.view.bounds style:self.isGroup];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
        _mainTableView.backgroundView = nil;
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.scrollsToTop = YES;
        
        /*
         iOS 11中如果不实现-tableView: viewForFooterInSection: 和 -tableView: viewForHeaderInSection:，那么-tableView: heightForHeaderInSection:和- tableView: heightForFooterInSection:不会被调用。
         
         这是因为estimatedRowHeight estimatedSectionHeaderHeight estimatedSectionFooterHeight三个高度估算属性由默认的0变成了UITableViewAutomaticDimension，导致高度计算不对，解决方法是实现对应方法或吧这三个属性设为0。
         */
        self.mainTableView.estimatedRowHeight = 0; //估算高度，如果我们要回到iOS11之前的效果，我们可以让estimatedRowHeight=0，关闭这个预估高度的效果。
        self.mainTableView.estimatedSectionFooterHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        
        [_mainTableView.mj_header setRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [_mainTableView.mj_footer setRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        if (@available(iOS 11.0, *)) {
            self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            // Fallback on earlier versions
        }

    }
    return _mainTableView;
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mainDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 下拉刷新和上拉加载更多，需要OverWrite

- (void)loadNewData{
    //overwrite me
    NSLog(@"please overwrite loadNewData");
}

- (void)loadMoreData{
    //overwrite me
    NSLog(@"please overwrite loadMoreData");
}

#pragma mark no data display

-(void)refreshNoDataViewWithListCount:(NSInteger)listCount{
    //添加空数据页面
    if(listCount == 0){
        [self addImageViewNoData];
    }
    else{
        [self removeImageViewNoData];
    }
}


- (void) addImageViewNoData{
    
    UIView *viewNoData = [self.mainTableView viewWithTag:99999];
    if(viewNoData == nil){
        viewNoData = [[UIView alloc] init];
        viewNoData.tag = 99999;
        viewNoData.size = [UIView getSize_width:145 height:92 + 30];
        
        viewNoData.origin = [UIView getPoint_x:(self.mainTableView.width - viewNoData.width)/2 y:sizeScale(150)];
        [self.mainTableView addSubview:viewNoData];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.size = [UIView getSize_width:145 height:92];
        imageView.origin = [UIView getPoint_x:0 y:0];
        imageView.image = [UIImage imageNamed:@"tablaview_nodata"];
        [viewNoData addSubview:imageView];
        
        UILabel *labelTitle = [[UILabel alloc]init];
        labelTitle.size = [UIView getSize_width:viewNoData.width height:30];
        labelTitle.origin = [UIView getPoint_x:0 y:imageView.bottom+10];
        labelTitle.textColor = defaultZJGrayColor;
        labelTitle.font = [UIFont defaultFontWithSize:14];
        labelTitle.textAlignment =  NSTextAlignmentCenter;
        labelTitle.text = @"抱歉，暂无内容";
        [viewNoData addSubview:labelTitle];
    }
}

-(void)removeImageViewNoData{
    UIView *viewNoData = [self.mainTableView viewWithTag:99999];
    if(viewNoData){
        [viewNoData removeAllSubviews];
        [viewNoData removeFromSuperview];
        viewNoData = nil;
    }
}

@end
