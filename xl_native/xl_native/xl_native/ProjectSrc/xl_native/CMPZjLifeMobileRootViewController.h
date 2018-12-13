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

@class XlHomeViewController_Temp;
@class HuinongViewController;
@class XLGchangNewViewController;
//@class TopicViewController;
@class UserInfoViewController;

@interface CMPZjLifeMobileRootViewController : UIViewController

//viewController
@property (nonatomic, strong) XlHomeViewController_Temp* homeNewViewController;
@property (nonatomic, strong) HuinongViewController* huinongViewController;
@property (nonatomic, strong) XLGchangNewViewController* gchangViewController;
@property (nonatomic, strong) UIViewController *topicViewController;
@property (nonatomic, strong) UserInfoViewController* userInfoViewController; 

//NavViewController
@property (nonatomic, strong) BaseNavigationController *xlHomeNavViewController;
@property (nonatomic, strong) BaseNavigationController *huinongNavController;
@property (nonatomic, strong) BaseNavigationController *gchangNavViewController;
@property (nonatomic,strong)   BaseNavigationController * topicNavViewController;
@property (nonatomic,strong)   BaseNavigationController * settingNavViewController;


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
