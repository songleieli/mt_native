//
//  PersonalInformationViewController.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/24.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_personal_homePage.h"

@interface UserSettingViewController : ZJBaseViewController <UIActionSheetDelegate>


/*
 *是否第三方绑定
 */
@property(nonatomic,assign) BOOL isWxBind;
@property(nonatomic,assign) BOOL isSinaBind;

@property(nonatomic,strong) UILabel * wechatLabe;
@property(nonatomic,strong) UILabel * weiboLabe;

@property (nonatomic, strong) PersonalModel    *user;



@end
