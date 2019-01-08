//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getFollowsVideoList.h"


//@protocol GetFollowsDelegate <NSObject>
//
//
//-(void)btnDeleteClick:(HomeListModel*)model;
//
//@end


#define FollowsVideoListCellHeight 580.0f


@interface FollowsVideoListCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(HomeListModel *)listModel;

@property(nonatomic,strong) HomeListModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UILabel * labelLine;

@property(nonatomic,strong) UIImageView * imageVeiwIcon;
@property(nonatomic,strong) UILabel * labelUserName;
@property(nonatomic,strong) UILabel * labelTitle;


//@property(nonatomic,strong) UILabel * labelReadStatus;
//@property(nonatomic,strong) UILabel * labelSign;
//@property(nonatomic,strong) UILabel * labelTImes;

//@property(nonatomic,weak) id <GetFollowsDelegate> getFollowsDelegate;


@end
