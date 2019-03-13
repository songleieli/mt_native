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
#import "TCUtil.h"
#import "MBProgressHUD.h"
#import "TCVideoLoadingController.h"


@interface CMPZjLifeMobileRootViewController ()<ZJChangeIndexDelegate,presentViewControllerDelegate,WYPopoverControllerDelegate,QBImagePickerControllerDelegate>{
    MBProgressHUD *          _hub;
}

@end

@implementation CMPZjLifeMobileRootViewController

#pragma mark ------------懒加载-----------

- (GKDouyinHomeViewController *)homeNewViewController{
    if (!_homeNewViewController){
        _homeNewViewController = [[GKDouyinHomeViewController alloc]init];
        _homeNewViewController.selectedIndex = 0;
        _homeNewViewController.changeIndexDelegate = self;
    }
    return _homeNewViewController;
}

- (MTFollowViewController *)followViewController{
    if (!_followViewController){
        _followViewController = [[MTFollowViewController alloc]init];
        _followViewController.selectedIndex = 1;
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
        _messageViewController.selectedIndex = 3;
        _messageViewController.changeIndexDelegate = self;
    }
    return _messageViewController;
}

- (UserInfoViewController *)userInfoViewController{
    if (!_userInfoViewController){
        _userInfoViewController = [[UserInfoViewController alloc]init];
        _userInfoViewController.selectedIndex = 4;
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




- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.view addSubview:self.xlHomeNavViewController.view];
    
}
- (void)selectTabAtIndex:(NSInteger)toIndex{
    
    
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
        //切换完成后需要将 suspensionBtn 提到最上层
//        [self.view bringSubviewToFront:self.suspensionBtn];
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
                self.popVC.preferredContentSize = CGSizeMake(sizeScale(125), sizeScale(160));
                
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
    if (videoPath) {
        TCVideoRecordViewController *vc = [[TCVideoRecordViewController alloc] init];
        vc.videoPath = videoPath;
        vc.savePath = YES;
        
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];

        [self presentViewController:nav animated:YES completion:nil];

//        [[TCBaseAppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
        [_hub hideAnimated:YES];
    }else{
        _hub.label.text = NSLocalizedString(@"TCVodPlay.VideoLoadFailed", nil);
        [_hub hideAnimated:YES afterDelay:1.0];
    }
}

-(void)onloadVideoProcess:(CGFloat)process {
    _hub.label.text = [NSString stringWithFormat:NSLocalizedString(@"TCVodPlay.VideoLoadingFmt", nil),(int)(process * 100)];
}


#pragma -mark presentViewControllerDelegate

-(void)clickRow:(NSInteger)row{
    
    if (self.wy != nil) {
        [self.wy dismissPopoverAnimated:YES];
        self.wy = nil;
    }
    
    if (row == 0) { //点击录制视频
        TCVideoRecordViewController *videoRecord = [[TCVideoRecordViewController alloc] initWithNibName:nil bundle:nil];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:videoRecord];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if(row == 1){//视频合唱
        
        _hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hub.mode = MBProgressHUDModeText;
        _hub.label.text = NSLocalizedString(@"TCVodPlay.VideoLoading", nil);
        
        __weak __typeof(self) weakSelf = self;
        NSString *ducumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *cachePath = [ducumentPath stringByAppendingPathComponent: @"Chorus.mp4"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]){
            [self onloadVideoComplete:cachePath];
        }else{
            [TCUtil downloadVideo:DEFAULT_CHORUS_URL cachePath:cachePath  process:^(CGFloat process) {
                [weakSelf onloadVideoProcess:process];
            } complete:^(NSString *videoPath) {
                [weakSelf onloadVideoComplete:videoPath];
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
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
    else if(row == 3){//选择本地图片
        
        _mediaType = QBImagePickerMediaTypeImage;
        QBImagePickerController *imagePickerController = [QBImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.mediaType = _mediaType;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.showsNumberOfSelectedAssets = YES;
        imagePickerController.minimumNumberOfSelection = 3;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
        
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
        if (_mediaType == QBImagePickerMediaTypeVideo) {
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

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
