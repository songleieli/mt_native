//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getMusicCollections.h"


@protocol SearchResultSubMusicDelegate <NSObject>

-(void)btnCellClick:(MusicSearchModel*)model;

@end


#define SearchResultSubMusicCellHeight 80.0f
#define SearchResultSubMusicCellSpace 6.0f


@interface UserCollectionSubMusicCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(MusicSearchModel *)listModel;

@property(nonatomic,strong) MusicSearchModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property (nonatomic, strong) UILabel *lableuseCount;


@property(nonatomic,weak) id <SearchResultSubMusicDelegate> subCellDelegate;


@end
