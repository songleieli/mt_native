//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getFuzzyMusicList.h"


@protocol SearchResultSubMusicDelegate <NSObject>

-(void)btnDeleteClick:(GetFuzzyMusicListModel*)model;

@end


#define SearchResultSubMusicCellHeight 80.0f
#define SearchResultSubMusicCellSpace 6.0f


@interface SearchResultSubMusicCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(GetFuzzyMusicListModel *)listModel;

@property(nonatomic,strong) GetFuzzyMusicListModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property (nonatomic, strong) UILabel *lableuseCount;


@property(nonatomic,weak) id <SearchResultSubMusicDelegate> subUserDelegate;


@end
