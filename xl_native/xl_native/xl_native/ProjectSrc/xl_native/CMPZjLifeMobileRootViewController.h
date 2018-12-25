//
//  CMPLjhMobileRootViewController.h
//  CMPLjhMobile
//
//  Created by sl on 16/5/11.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"
#import "WYPopoverController.h"
#import "QBImagePickerController.h"


@class BaseNavigationController;

@class GKDouyinHomeViewController;
@class HuinongViewController;
@class MTMessageViewController;
@class UserInfoViewController;

@interface CMPZjLifeMobileRootViewController : UIViewController

//viewController
@property (nonatomic, strong) GKDouyinHomeViewController* homeNewViewController;
@property (nonatomic, strong) HuinongViewController* huinongViewController;
@property (nonatomic, strong) UIViewController* topicViewController;
@property (nonatomic, strong) MTMessageViewController *messageViewController;
@property (nonatomic, strong) UserInfoViewController* userInfoViewController; 

//NavViewController
@property (nonatomic, strong) BaseNavigationController *xlHomeNavViewController;
@property (nonatomic, strong) BaseNavigationController *huinongNavController;
@property (nonatomic,strong)   BaseNavigationController * topicNavViewController;
@property (nonatomic, strong) BaseNavigationController *messageNavViewController;
@property (nonatomic,strong)   BaseNavigationController * userInfoNavViewController;


@property (nonatomic, strong) BaseNavigationController *currentViewController;

/*
 *popview
 */
@property (nonatomic,strong)PopViewController * popVC;
@property (nonatomic,strong)WYPopoverController * wy;

/*
 *QBImagePickerMediaType
 */
@property (nonatomic) QBImagePickerMediaType mediaType;




- (void)selectTabAtIndex:(NSInteger)toIndex;

@end
