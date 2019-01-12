//
//  ZJMessageViewController.h
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/8.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "SettingViewController.h"
#import "MyViewTableViewCell.h"




@interface MyViewTableViewSelectionModel : NSObject

@property (nonatomic ,copy)NSString* selectTitle;
@property (nonatomic ,strong)NSMutableArray*cellList;

@end


@interface MyViewController : ZJBaseViewController<MyCellDelegate>

/*
 *数据源
 */
@property (nonatomic,strong)NSMutableArray * dataList;





@end
