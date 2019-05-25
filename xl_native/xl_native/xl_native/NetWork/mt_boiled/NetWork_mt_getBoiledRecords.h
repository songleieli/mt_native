//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"

@interface BoiledRecordModel : IObjcJsonBase

/*
"endTime": "2019-05-16 16:00:01",   //煮面完成时间
"money": 4.88                      //煮面获得的钱
*/

//下载本地音乐到本地的路径
@property (copy, nonatomic) NSString* endTime;
@property (copy, nonatomic) NSString *money;


@end



@interface GetBoiledRecordsResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getBoiledRecords : WCServiceBase

@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;
@property (nonatomic,strong) NSString * currentNoodleId;

@end
