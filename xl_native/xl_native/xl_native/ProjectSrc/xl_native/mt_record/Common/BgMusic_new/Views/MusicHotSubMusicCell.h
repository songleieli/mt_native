//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getMusicList.h"


@protocol MusicHotSubDelegate <NSObject>

-(void)btnCellClick:(MusicModel*)model;

@end


#define MusicHotSubMusicCellHeight 80.0f
#define MusicHotSubMusicCellSpace 6.0f


@interface MusicHotSubMusicCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(MusicModel *)listModel;

@property(nonatomic,strong) MusicModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property (nonatomic, strong) UILabel *lableuseCount;


@property(nonatomic,weak) id <MusicHotSubDelegate> subCellDelegate;


@end
