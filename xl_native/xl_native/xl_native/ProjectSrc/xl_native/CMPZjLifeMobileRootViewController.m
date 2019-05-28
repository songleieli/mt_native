//
//  CMPLjhMobileRootViewController.m
//  CMPLjhMobile
//
//  Created by sl on 16/5/11.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.

#import "CMPZjLifeMobileRootViewController.h"

#import "BaseNavigationController.h"

#import "GKDouyinHomeViewController.h"
#import "MTFollowViewController.h"
#import "MTMessageViewController.h"
#import "UserInfoViewController.h"

#import "TCVideoRecordViewController.h"

//#import "MBProgressHUD.h"
#import "TCVideoLoadingController.h"

#import "SharePopViewVideo.h"

@interface CMPZjLifeMobileRootViewController ()<ZJChangeIndexDelegate,presentViewControllerDelegate,WYPopoverControllerDelegate,QBImagePickerControllerDelegate,VideoSahreDelegate>{
//    MBProgressHUD *          _hub;
}

@end

@implementation CMPZjLifeMobileRootViewController

#pragma mark ------------懒加载-----------

- (GKDouyinHomeViewController *)homeNewViewController{
    if (!_homeNewViewController){
        _homeNewViewController = [[GKDouyinHomeViewController alloc]init];
        _homeNewViewController.pageIndex = 0;
        _homeNewViewController.changeIndexDelegate = self;
    }
    return _homeNewViewController;
}

- (MTFollowViewController *)followViewController{
    if (!_followViewController){
        _followViewController = [[MTFollowViewController alloc]init];
        _followViewController.pageIndex = 1;
        _followViewController.changeIndexDelegate = self;
        
    }
    return _followViewController;
}

- (UIViewController *)topicViewController{
    if (!_topicViewController){
        _topicViewController = [[UIViewController alloc]init];
//        _gchangViewController.selectedIndex = 2;
//        _gchangViewController.changeIndexDelegate = self;
    }
    return _topicViewController;
}


- (MTMessageViewController *)messageViewController{
    if (!_messageViewController){
        _messageViewController = [[MTMessageViewController alloc]init];
        _messageViewController.pageIndex = 3;
        _messageViewController.changeIndexDelegate = self;
    }
    return _messageViewController;
}

- (UserInfoViewController *)userInfoViewController{
    if (!_userInfoViewController){
        _userInfoViewController = [[UserInfoViewController alloc]init];
        _userInfoViewController.pageIndex = 4;
        _userInfoViewController.changeIndexDelegate = self;
        _userInfoViewController.fromType = FromTypeMy; //我的页面，需要隐藏返回按钮，显示TabBar
    }
    return _userInfoViewController;
}



#pragma -mark NavController

- (BaseNavigationController *)xlHomeNavViewController{
    if (!_xlHomeNavViewController){
        _xlHomeNavViewController = [BaseNavigationController navigationWithRootViewController:self.homeNewViewController];
        _xlHomeNavViewController.gk_openScrollLeftPush = YES;
    }
    return _xlHomeNavViewController;
}

- (BaseNavigationController *)followNavViewController{
    if (!_followNavViewController){
        _followNavViewController = [BaseNavigationController navigationWithRootViewController:self.followViewController];
    }
    return _followNavViewController;
}

- (BaseNavigationController *)topicNavViewController{
    if (!_topicNavViewController){
        _topicNavViewController = [BaseNavigationController navigationWithRootViewController:self.topicViewController];
    }
    return _topicNavViewController;
}

- (BaseNavigationController *) messageNavViewController{
    if (!_messageNavViewController){
        _messageNavViewController = [BaseNavigationController navigationWithRootViewController:self.messageViewController];
    }
    return _messageNavViewController;
}

-(BaseNavigationController *)userInfoNavViewController{
    if (!_userInfoNavViewController) {
        _userInfoNavViewController = [BaseNavigationController navigationWithRootViewController:self.userInfoViewController];
    }
    return _userInfoNavViewController;
}

#pragma -mark ------------- 煮面  ----------------



#pragma -mark advertisingPopSource

- (NSMutableArray *)advertisingPopSource{
    
    if (!_advertisingPopSource) {
        _advertisingPopSource = [[NSMutableArray alloc] init];
    }
    return _advertisingPopSource;
}

- (NSMutableArray *)prizeWinerSource{
    
    if (!_prizeWinerSource) {
        _prizeWinerSource = [[NSMutableArray alloc] init];
    }
    return _prizeWinerSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //test
    [GlobalData sharedInstance].isLoadedApp = NO;
    
    if(![GlobalData sharedInstance].isLoadedApp){ //第一次启动App
        [GlobalData sharedInstance].isLoadedApp = YES;
        /*
         *加载广告
         */
        [self dealPopAdverist];
        [self loadAdRequest];
        [self loadWinnersRequest];
    }
    else{
        [self loadTableBar];
    }
}

#pragma -mark ----- CustomMethod ------------

-(void)dealPopAdverist{
    
    if(self.viewPopAd){
        [self.viewPopAd removeAllSubviews];
        [self.viewPopAd removeFromSuperview];
        self.viewPopAd = nil;
    }
    
    self.viewPopAd = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.viewPopAd.image = [UIImage imageNamed:@"main_ad_bg"];
    //UIImageView - 解决Button加到ImageView上后Button 无法响应单击事件的方法
    self.viewPopAd.userInteractionEnabled = YES;
    
    [self.view addSubview:self.viewPopAd];
    [self.view bringSubviewToFront:self.viewPopAd];
    
    
    /*
     *迎新title
     */
    UIImageView *imageViewTitle = [[UIImageView alloc] init];
    imageViewTitle.size = [UIView getScaleSize_width:130 height:25];
    imageViewTitle.centerX = self.viewPopAd.width/2;
    imageViewTitle.top = sizeScale(30);
    imageViewTitle.image = [UIImage imageNamed:@"main_ad_title"];
    [self.viewPopAd addSubview:imageViewTitle];
    
    
    self.imageViewNoolde = [[UIImageView alloc] init];
    self.imageViewNoolde.size = [UIView getSize_width:ScreenWidth height:ScreenWidth];
    self.imageViewNoolde.centerX = self.viewPopAd.width/2;
    self.imageViewNoolde.top = imageViewTitle.bottom;
    [self.imageViewNoolde setImage:[UIImage imageNamed:@"part_1"]];

    [self.viewPopAd addSubview:self.imageViewNoolde];
    
    //test
//    imageViewNoolde.backgroundColor = [UIColor redColor];
    
    //创建一个可变数组
    NSMutableArray *ary=[NSMutableArray new];
    for(int I=1;I<=2;I++){
        //通过for 循环,把我所有的 图片存到数组里面
        NSString *imageName=[NSString stringWithFormat:@"part_%d",I];
        UIImage *image=[UIImage imageNamed:imageName];
        [ary addObject:image];
    }
    
    // 设置图片的序列帧 图片数组
    self.imageViewNoolde.animationImages=ary;
    //动画重复次数
    self.imageViewNoolde.animationRepeatCount=1;
    //动画执行时间,多长时间执行完动画
    self.imageViewNoolde.animationDuration = 1.0;

    /*
     *抽奖和跳过按钮
     */
    UIButton *btnLuck = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLuck.tag = 90;
    btnLuck.size = [UIView getScaleSize_width:137 height:43];
    btnLuck.right = self.viewPopAd.width/2 - sizeScale(7);
    btnLuck.bottom = self.viewPopAd.height -sizeScale(35);
    [btnLuck setBackgroundImage:[UIImage imageNamed:@"main_ad_btn_luck"] forState:UIControlStateNormal];
    btnLuck.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnLuck setTitle:@"抽奖" forState:UIControlStateNormal];
    [btnLuck addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    btnLuck.titleLabel.font = [UIFont defaultFontWithSize:22];
    [self.viewPopAd addSubview:btnLuck];
    
    UIButton *btnSkip= [UIButton buttonWithType:UIButtonTypeCustom];
    btnSkip.tag = 91;
    btnSkip.size = [UIView getScaleSize_width:137 height:43];
    btnSkip.left = self.viewPopAd.width/2 + sizeScale(7);
    btnSkip.bottom = self.viewPopAd.height -sizeScale(35);
    [btnSkip setBackgroundImage:[UIImage imageNamed:@"main_ad_btn_skip"] forState:UIControlStateNormal];
    btnSkip.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnSkip setTitle:@"跳过" forState:UIControlStateNormal];
    [btnSkip addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    btnSkip.titleLabel.font = [UIFont defaultFontWithSize:22];
    [self.viewPopAd addSubview:btnSkip];
    
    /*
     *奖品池
     */
    self.viewGift = [[MTGiftView alloc] init];
    self.viewGift.size = [UIView getSize_width:ScreenWidth height:sizeScale(80)];
    self.viewGift.centerX = self.viewPopAd.width/2;
    self.viewGift.top = self.imageViewNoolde.bottom;
    [self.viewPopAd addSubview:self.viewGift];
    
    if(self.viewGift.bottom > btnLuck.top){
        self.viewGift.bottom = btnLuck.top;
    }
    
    
    UILabel *lableGiftTitle = [[UILabel alloc] init];
    lableGiftTitle.size = [UIView getSize_width:ScreenWidth height:50];
    lableGiftTitle.bottom = self.viewGift.top;
    lableGiftTitle.left = 10;
    
    lableGiftTitle.textAlignment = NSTextAlignmentCenter;
    lableGiftTitle.textColor = [UIColor blackColor];
    lableGiftTitle.font = [UIFont defaultFontWithSize:25];
    lableGiftTitle.text = @"奖品池";
    lableGiftTitle.textAlignment = NSTextAlignmentLeft;
    //test
//    lableGiftTitle.backgroundColor = [UIColor redColor];
    
    [self.viewPopAd addSubview:lableGiftTitle];

    //test
//    self.viewGift.backgroundColor = [UIColor redColor];
}

-(void)loadAdRequest{
    NetWork_mt_getPrizeList *request = [[NetWork_mt_getPrizeList alloc] init];
    [request startGetWithBlock:^(GetPrizeListResponse *result, NSString *msg, BOOL finished) {
        if(finished){
            NSLog(@"--------");
            [self.viewGift reloadWithSource:result.obj rowCount:2];
        }
    }];
}

-(void)luckDrawRequest{ //点击抽奖
    NetWork_mt_luckdraw *request = [[NetWork_mt_luckdraw alloc] init];
    [request startGetWithBlock:^(LuckdrawResponse *result, NSString *msg, BOOL finished) {
        if(finished){
            [UIWindow showTips:result.obj];
            [self performSelector:@selector(loadTableBar) withObject:nil/*可传任意类型参数*/ afterDelay:4.0];
        }
    }];
}

-(void)loadWinnersRequest{
    NetWork_mt_getWinners *request = [[NetWork_mt_getWinners alloc] init];
    [request startGetWithBlock:^(GetWinnersResponse *result, NSString *msg, BOOL finished) {
        if(finished){
            [self loadWinnersUI:result.obj];
        }
    }];
}

-(void)loadWinnersUI:(NSArray *)array{
    
        /*
         *中奖人员，跑马灯
         */
    
        NSMutableArray *tempArr = @[].mutableCopy;
    
    for(GetWinnerModel *model in array){
        
        UILabel *labelOne = [UILabel new];
        labelOne.font = [UIFont systemFontOfSize:13];
        labelOne.text = [NSString stringWithFormat:@"%@ 获得 [%@]   %@",model.nickname,model.jiangpinName,model.wTime];
        labelOne.textColor = [UIColor blackColor];
        labelOne.textAlignment = NSTextAlignmentCenter;
        
        [tempArr addObject:labelOne];
    }

    self.marqueeView = [[LSMarqueeView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 60) andLableArr:tempArr];
    self.marqueeView.top = sizeScale(30) + 25;
    [self.view addSubview:self.marqueeView];
    [self.marqueeView  startCountdown];
    
    self.imageViewNoolde.top = self.marqueeView.bottom - 50;
}

-(void)adClick:(UIButton*)btn{
    if(btn.tag == 90){ //抽奖
        //开始动画
        [self.imageViewNoolde startAnimating];
        [self luckDrawRequest];

    }
    else if(btn.tag == 91){//跳过
        [self loadTableBar];
    }
}



-(void)loadTableBar{
    
    if(self.viewGift){
        [self.viewGift removeFromSuperview];
    }
    
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:self.xlHomeNavViewController];
    [self addChildViewController:self.followNavViewController];
    [self addChildViewController:self.topicNavViewController];
    [self addChildViewController:self.messageNavViewController];
    [self addChildViewController:self.userInfoNavViewController];
    
    //[[UINavigationBar appearance] setBarTintColor:defaultZjBlueColor];
    //（这里就很费解，按照系统文档上解释的话，默认应该是YES才对，可是事实证明系统默认是NO）
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    //    [[UINavigationBar appearance] setTranslucent:NO];//这句话是控制导航栏颜色是否透明。//导航栏颜色透明
    
    self.currentViewController = self.xlHomeNavViewController;
    self.currentSelectIndex = 0; //默认选择第一个tab
    [self.view addSubview:self.xlHomeNavViewController.view];
}


- (void)selectTabAtIndex:(NSInteger)toIndex{
    
    self.currentSelectIndex = toIndex;
    BaseNavigationController *toViewController = [self.childViewControllers objectAtIndex:toIndex];
    [toViewController popToRootViewControllerAnimated:NO];
    
    if(toViewController.topViewController == self.currentViewController.topViewController){
        return;
    }
    [UIView setAnimationsEnabled:NO];
    [self transitionFromViewController:self.currentViewController toViewController:toViewController duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
        // do nothing
    } completion:^(BOOL finished) {
        // do nothing
        [UIView setAnimationsEnabled:YES];
        self.currentViewController = toViewController;
    }];
}



#pragma -mark ChangeIndexDelegate

- (BOOL)customTabBar:(ZJCustomTabBarLjhTableViewController *)tabBar shouldSelectIndex:(NSInteger)index{
    
//    //test ,暂时先屏蔽我的页面，登录判断，为UI仿抖音用户信息页面
//    if(index == 4){
//        return YES;
//    }
    
    
    if(index == 1 || index == 3 || index == 4){
        
        if([GlobalData sharedInstance].hasLogin){
             return YES;
        }
        else{
            [[ZJLoginService sharedInstance] authenticateWithCompletion:^(BOOL success) {
                //如果登录成功，选择index
                [self selectTabAtIndex:index];
            } cancelBlock:nil isAnimat:YES];
            return NO;
        }
    }
    
    
    
    if(index == 2){//拍视频需要验证登录
        
        [[ZJLoginService sharedInstance] authenticateWithCompletion:^(BOOL success) {
            
            UIButton *imgBtn = [[[tabBar.tabBar.buttons objectAtIndex:index] subviews] objectAtIndex:0];
            if (self.wy == nil){
                
                self.popVC = [[PopViewController alloc] init];
                self.popVC.delegate = self;
                self.popVC.preferredContentSize = CGSizeMake(sizeScale(100), sizeScale(160));
                
                WYPopoverController * popover = [[WYPopoverController alloc] initWithContentViewController:self.popVC];
                popover.delegate = self;
                popover.wantsDefaultContentAppearance = NO;
                popover.passthroughViews = @[imgBtn,popover];
                popover.theme.arrowHeight = sizeScale(10);
                popover.theme.arrowBase = sizeScale(15);
                popover.theme.outerCornerRadius = 2;
                popover.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
                
                
                CGRect  rect = CGRectMake(0, -10, sizeScale(25),sizeScale(25));
                [popover presentPopoverFromRect:rect inView:imgBtn permittedArrowDirections:WYPopoverArrowDirectionDown animated:YES options:WYPopoverAnimationOptionScale];
                self.wy = popover;
                
            }
            else{
                if (self.wy != nil) {
                    [self.wy dismissPopoverAnimated:YES];
                    self.wy = nil;
                }
            }
        } cancelBlock:nil isAnimat:YES];

        
        return NO;
    }
    return YES;
}

- (void)customTabBar:(ZJCustomTabBarLjhTableViewController *)tabBar didSelectIndex:(NSInteger)index{
    [self selectTabAtIndex:index];
}


-(void)onloadVideoComplete:(NSString *)videoPath {
    
    [GlobalFunc hideHUD];
    if (videoPath) {
        HomeListModel *homeListModel= self.homeNewViewController.playerVC.currentCell.listModel;

        MusicSearchModel *musicSearchModel = [[MusicSearchModel alloc] init];
        musicSearchModel.musicId = homeListModel.musicId;
        musicSearchModel.musicName = homeListModel.musicName;
        musicSearchModel.coverUrl = homeListModel.coverUrl;
        musicSearchModel.playUrl = homeListModel.musicUrl;
        
        
        TCVideoRecordViewController *vc = [[TCVideoRecordViewController alloc] init];
        vc.videoPath = videoPath;
        vc.savePath = YES;
        vc.selectMusicModel = musicSearchModel;
        
        musicSearchModel = nil;
        
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{
            /*
             *发送弹出模态窗口通知
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationPresentViewController
                                                                object:nil];
            
        }];
    }
}

-(void)onloadVideoProcess:(CGFloat)process {
    
    //_hub.label.text = [NSString stringWithFormat:NSLocalizedString(@"TCVodPlay.VideoLoadingFmt", nil),(int)(process * 100)];
    
    [GlobalFunc showHud:[NSString stringWithFormat:NSLocalizedString(@"TCVodPlay.VideoLoadingFmt", nil),(int)(process * 100)]];
}


#pragma -mark presentViewControllerDelegate

-(void)clickRow:(NSInteger)row{
    
    //test  测试发布视频页面
    
//    PublishViewController *publishViewController = [[PublishViewController alloc] init];
//
//    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:publishViewController];
//    [self presentViewController:nav animated:YES completion:nil];
//
//    return ;
    
    if (self.wy != nil) {
        [self.wy dismissPopoverAnimated:YES];
        self.wy = nil;
    }
    
    if (row == 0) { //点击录制视频
        TCVideoRecordViewController *videoRecord = [[TCVideoRecordViewController alloc] initWithNibName:nil bundle:nil];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:videoRecord];
        [self presentViewController:nav animated:YES completion:^{
            
            /*
             *发送弹出模态窗口通知
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationPresentViewController
                                                                object:nil];
            
        }];
    }
    else if(row == 1){//视频合唱
        
        //获取本地磁盘缓存文件夹路径，同视频缓存同一个目录，缓存一天后删除
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path = [paths lastObject];
        NSString *diskCachePath = [NSString stringWithFormat:@"%@%@",path,@"/webCache"];
        
        //当前视频播放Model
        HomeListModel *homeListModel= self.homeNewViewController.playerVC.currentCell.listModel;
        NSString *name = [NSString stringWithFormat:@"/chorus_%@.mp4",homeListModel.noodleVideoId];
        NSString *chorusFileName = [NSString stringWithFormat:@"%@%@",diskCachePath,name];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:chorusFileName]){
            [self onloadVideoComplete:chorusFileName];
        }else{
            NSString *videoUrl = self.homeNewViewController.playerVC.currentCell.listModel.storagePath;
            
            [FileHelper downloadFile:chorusFileName playUrl:videoUrl processBlock:^(float percent) {
                [self onloadVideoProcess:percent];
            } completionBlock:^(BOOL result, NSString *msg) {
                if(result){
                    [self onloadVideoComplete:chorusFileName];
                }
                else{
                    [UIWindow showTips:msg];
                }
            }];
            
        }
        
    }
    else if(row == 2){//选择本地视频
        
        
        _mediaType = QBImagePickerMediaTypeVideo;
        QBImagePickerController *imagePickerController = [QBImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.mediaType = QBImagePickerMediaTypeVideo;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.showsNumberOfSelectedAssets = YES;
        //    imagePickerController.maximumNumberOfSelection = 5;
        [self presentViewController:imagePickerController animated:YES completion:^{
            NSLog(@"发送通知");
            
            /*
             *发送弹出模态窗口通知
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationPresentViewController
                                                                object:nil];
            
        }];
    }
    else if(row == 3){//选择本地图片
        
        _mediaType = QBImagePickerMediaTypeImage;
        QBImagePickerController *imagePickerController = [QBImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.mediaType = _mediaType;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.showsNumberOfSelectedAssets = YES;
        imagePickerController.minimumNumberOfSelection = 3;
        [self presentViewController:imagePickerController animated:YES completion:^{
            NSLog(@"发送通知");
            
            /*
             *发送弹出模态窗口通知
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationPresentViewController
                                                                object:nil];
            
        }];
        
    }
}

#pragma mark - WYPopoverControllerDelegate

- (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller{
    NSLog(@"popoverControllerDidPresentPopover");
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller{
    return YES;
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller{
    
//    self.btnAttention.enabled = YES;
    if (controller == self.wy ) {
//        self.btnAttention.enabled = YES;
        self.wy.delegate = nil;
        self.wy = nil;
    }
    
}

- (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value{
    
    // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
    *value = 0; // set value to 0 if you want to avoid the popover to be moved
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"Selected assets:");
    NSLog(@"%@", assets);
    
    [self dismissViewControllerAnimated:YES completion:^ {
        TCVideoLoadingController *loadvc = [[TCVideoLoadingController alloc] init];
        if (self.mediaType == QBImagePickerMediaTypeVideo) {
            loadvc.composeMode = (assets.count > 1);
            [loadvc exportAssetList:assets assetType:AssetType_Video];
        }else{
            loadvc.composeMode = ComposeMode_Edit;
            [loadvc exportAssetList:assets assetType:AssetType_Image];
        }
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loadvc];
        [self presentViewController:nav animated:YES completion:nil];
    }];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    NSLog(@"Canceled.");
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
