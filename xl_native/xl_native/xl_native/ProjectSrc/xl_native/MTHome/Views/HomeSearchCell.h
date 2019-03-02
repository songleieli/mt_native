//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NetWork_mt_getHotVideoList.h"

#define HomeSearchCellHeight 200.0f


@protocol HomeSearchDelegate <NSObject>

-(void)btnCellIconClick:(GetHotVideoListModel*)model;

-(void)btnCellVideoClick:(NSArray*)videoList selectIndex:(NSInteger)selectIndex;

@end


@interface HomeSearchCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(GetHotVideoListModel *)listModel;

@property(nonatomic,strong) GetHotVideoListModel * listModel;


@property(nonatomic,strong) UIView * viewTitle;
@property(nonatomic,strong) UIView * imageVeiwBg;
@property(nonatomic,strong) UIButton * btnIcon;
@property(nonatomic,strong) UIButton * titleLalbe;
@property(nonatomic,strong) UILabel * descLalbe;
@property(nonatomic,strong) UILabel * playCountLalbe;

@property(nonatomic,strong) UIScrollView * scrollerBody;

@property(nonatomic,weak) id <HomeSearchDelegate> cellDelegate;


@end
