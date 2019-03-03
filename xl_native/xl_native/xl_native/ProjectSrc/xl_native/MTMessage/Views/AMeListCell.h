//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_aMeList.h"


@protocol AMeListDelegate <NSObject>

-(void)btnCellClick:(AMeListModel*)model;

@end


#define AMeListCellHeight 80.0f
#define AMeListCellSpace 6.0f


@interface AMeListCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(AMeListModel *)listModel;

@property(nonatomic,strong) AMeListModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property(nonatomic,strong) UILabel * labelTImes;

@property(nonatomic,weak) id <AMeListDelegate> aMeListDelegate;


@end
