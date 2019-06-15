//
//  MYHeaderView.h
//  CMPLjhMobile
//
//  Created by lei song on 16/7/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWork_mt_getHotVideosByTopic.h"

@protocol TopicHeadDelegate <NSObject>

-(void)btnCollectionClick:(GetHotVideosByTopicModel*)model;

@end

@interface MyTopicHeaderView : UICollectionReusableView


@property(nonatomic,strong) UILabel *lableTopicIcon;
@property(nonatomic,strong) UILabel *lableTopicName;
@property(nonatomic,strong) UILabel *lablePlayCount;

@property (nonatomic, strong) UIButton  *btnCollectionBg; //收藏按钮背景
@property (nonatomic, strong) UIImageView    *imageViewCollectionIcon;  //收藏图标
@property (nonatomic, strong) UILabel    *lableCollectionTitle;  //收藏标题

@property(nonatomic,strong) GetHotVideosByTopicModel * topicModel;


/*点击收藏按钮*/
@property(nonatomic,weak) id <TopicHeadDelegate> delegate;

- (void)initData:(GetHotVideosByTopicModel *)topicModel;

@end
