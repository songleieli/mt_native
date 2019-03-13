//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getMusicCollections.h"


@protocol MusicCollectionSubMusicDelegate <NSObject>

-(void)btnCellClick:(GetMusicCollectionModel*)model;

@end


#define MusicCollectionSubMusicCellHeight 80.0f
#define MusicCollectionSubMusicCellSpace 6.0f


@interface MusicCollectionSubMusicCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(GetMusicCollectionModel *)listModel;

@property(nonatomic,strong) GetMusicCollectionModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property (nonatomic, strong) UILabel *lableuseCount;


@property(nonatomic,weak) id <MusicCollectionSubMusicDelegate> subCellDelegate;


@end
