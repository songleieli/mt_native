//
//  ZJBaseViewController.m
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/10.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "ZJBaseViewController.h"

@interface ZJBaseViewController ()

@end

@implementation ZJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
}

-(void)initNavTitle{
    /*
     *重载父类中的方法，初始化NavTitle
     */
    [super initNavTitle];
    
    self.lableNavTitle.textColor = [UIColor blackColor];
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navBackGround.height-1, ScreenWidth, 1)];
    lineView.backgroundColor = RGBFromColor(0xd4d4d4);
    [self.navBackGround addSubview:lineView];
    
    [self.btnLeft setImage:[UIImage imageNamed:@"gray_back"] forState:UIControlStateNormal];
    self.navBackGround.backgroundColor = [UIColor whiteColor];
}




@end
