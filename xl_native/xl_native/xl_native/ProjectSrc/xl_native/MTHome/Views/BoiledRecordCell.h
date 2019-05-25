//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getBoiledRecords.h"   //查看粉丝列表


//@protocol GetFloursDelegate <NSObject>
//
//-(void)btnCellClick:(GetFloursModel*)model;
//
//@end


#define FlourCellHeight 80.0f
#define FlourCellSpace 6.0f


@interface BoiledRecordCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(BoiledRecordModel *)listModel;

@property(nonatomic,strong) BoiledRecordModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property(nonatomic,strong) UILabel * labelTImes;

//@property(nonatomic,weak) id <GetFloursDelegate> followsDelegate;


@end
