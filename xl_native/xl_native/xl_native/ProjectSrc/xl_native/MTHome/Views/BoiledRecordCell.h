//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NetWork_mt_getBoiledRecords.h"

#define BoiledRecordCellHeight 80.0f
#define BoiledRecordCellSpace 6.0f


@interface BoiledRecordCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(BoiledRecordModel *)listModel;

@property(nonatomic,strong) BoiledRecordModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;

@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;


@end
