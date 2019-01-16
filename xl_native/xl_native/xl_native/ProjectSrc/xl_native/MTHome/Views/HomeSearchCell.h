//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getHotVideoList.h"


//@protocol GetFollowsDelegate <NSObject>
//
//-(void)btnDeleteClick:(GetHotVideoListModel*)model;
//
//@end


#define HomeSearchCellHeight 200.0f


@interface HomeSearchCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(GetHotVideoListModel *)listModel;

@property(nonatomic,strong) GetHotVideoListModel * listModel;


//head
@property(nonatomic,strong) UIView * viewTitle;
@property(nonatomic,strong) UIView * imageVeiwBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;
@property(nonatomic,strong) UILabel * titleLalbe;
@property(nonatomic,strong) UILabel * descLalbe;
@property(nonatomic,strong) UILabel * playCountLalbe;


@property(nonatomic,strong) UIScrollView * scrollerBody;


//@property(nonatomic,weak) id <GetFollowsDelegate> getFollowsDelegate;


@end
