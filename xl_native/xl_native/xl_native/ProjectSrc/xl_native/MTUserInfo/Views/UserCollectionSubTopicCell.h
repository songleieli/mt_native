//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getTopicCollections.h"


@protocol CollectionSubTopicDelegate <NSObject>

-(void)btnCellClick:(GetTopicCollectionModel*)model;

@end


#define SearchResultSubTopicCellHeight 70.0f
#define SearchResultSubTopicCellSpace 6.0f


@interface UserCollectionSubTopicCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(GetTopicCollectionModel *)listModel;

@property(nonatomic,strong) GetTopicCollectionModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIView * imageVeiwBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * titleLalbe;
@property(nonatomic,strong) UILabel * useCountLalbe;

@property(nonatomic,weak) id <CollectionSubTopicDelegate> subTopicDelegate;

@end
