//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


typedef NS_ENUM(NSInteger, PublishType){
    
    PublishTypeTopic = 0,
    PublishTypeAtFriend
    
};


@interface AtAndTopicModel : IObjcJsonBase

@property(nonatomic,assign) PublishType publishType;
@property (nonatomic,strong) GetFollowsModel * atFriendModel;
@property (nonatomic,strong) GetFuzzyTopicListModel * topicModel;
@property (nonatomic,strong) NSString * rangeStr;

@end
