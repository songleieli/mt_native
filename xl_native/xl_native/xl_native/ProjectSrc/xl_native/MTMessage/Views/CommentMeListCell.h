//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getCommentMeList.h"


@protocol CommentMeListDelegate <NSObject>

-(void)btnCellClick:(GetCommentMeListModel*)model;

@end


#define CommentMeListCellHeight 80.0f
#define CommentMeListCellSpace 6.0f


@interface CommentMeListCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(GetCommentMeListModel *)listModel;

@property(nonatomic,strong) GetCommentMeListModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property(nonatomic,strong) UILabel * labelTImes;

@property(nonatomic,weak) id <CommentMeListDelegate> commentMeListDelegate;


@end
