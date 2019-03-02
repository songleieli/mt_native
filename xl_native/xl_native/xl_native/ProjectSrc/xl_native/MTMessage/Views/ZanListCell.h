//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getLikeMeList.h"


@protocol ZanListDelegate <NSObject>

-(void)btnCellClick:(GetLikeMeListModel*)model;

@end


#define ZanListCellHeight 80.0f
#define ZanListCellSpace 6.0f


@interface ZanListCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(GetLikeMeListModel *)listModel;

@property(nonatomic,strong) GetLikeMeListModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property(nonatomic,strong) UILabel * labelTImes;

@property(nonatomic,weak) id <ZanListDelegate> zanListDelegate;


@end
