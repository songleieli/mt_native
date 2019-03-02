//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getFlours.h"


@protocol GetFloursDelegate <NSObject>

-(void)btnCellClick:(GetFloursModel*)model;

@end


#define FlourCellHeight 80.0f
#define FlourCellSpace 6.0f


@interface FlourCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(GetFloursModel *)listModel;

@property(nonatomic,strong) GetFloursModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property(nonatomic,strong) UILabel * labelTImes;

@property(nonatomic,weak) id <GetFloursDelegate> followsDelegate;


@end
