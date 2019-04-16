//
//  ZJMessageViewController.h
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/8.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

//#import "SettingViewController.h"
#import "MyViewTableViewCell.h"
#import "PersonalInformationViewController.h"
#import "SettingAboutViewController.h"


@interface MyViewTableViewSelectionModel : NSObject

@property (nonatomic ,copy)NSString* selectTitle;
@property (nonatomic ,strong)NSMutableArray*cellList;

@end


@interface MySettingViewController : ZJBaseViewController<MyCellDelegate>

/*
 *数据源
 */
@property (nonatomic,strong)NSMutableArray * dataList;

@end
