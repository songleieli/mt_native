//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getFollows.h"


@protocol GetFollowsDelegate <NSObject>


-(void)btnDeleteClick:(GetFollowsModel*)model;

@end


#define ZJMessageCellHeight 80.0f
#define ZJMessageCellSpace 6.0f


@interface MessageCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(GetFollowsModel *)listModel;

@property(nonatomic,strong) GetFollowsModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property(nonatomic,strong) UILabel * labelTImes;

@property(nonatomic,weak) id <GetFollowsDelegate> getFollowsDelegate;


@end
