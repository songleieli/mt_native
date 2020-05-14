//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface ScenicTicketInfoModel : IObjcJsonBase


/*
 "title": "成人票",
 "content": "25人民币 (1月1日-12月31日 周一-周日)"
 */

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;

@end


@interface ScenicSpotModel : IObjcJsonBase


/*
 "spotsId": "32",
 "latitude": "40.106758",
 "spotsImages": [
   "/scenic-image/fhl/lqs/lqs1.jpeg",
   "/scenic-image/fhl/lqs/lqs2.jpg",
   "/scenic-image/fhl/lqs/lqs3.jpg",
   "/scenic-image/fhl/lqs/lqs4.jpg"
 ],
 "spotsIntroduce": "龙泉寺是北京西北部寺庙, 始建于辽代, 距今已有一千多年。 是海淀区建国以来第一所正式开放的三宝具足的佛教寺院寺庙。",
 "spotsName": "龙泉寺",
 "longitude": "116.08694"
 */

@property (copy, nonatomic) NSString *spotsId;
@property (copy, nonatomic) NSString *spotsName;
@property (copy, nonatomic) NSString *spotsIntroduce;
@property (copy, nonatomic) NSString *longitude;
@property (copy, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSArray *spotsImages;

@end


@interface ScenicDynamicAttributesModel : IObjcJsonBase

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;

@end


@interface ScenicModel : IObjcJsonBase


/*
 "id": 3,
 "scenicName": "北京凤凰岭自然风景公园",
 "province": "北京市",
 "city": "北京市",
 "county": "海淀区",
 "addr": "北京市海淀区苏家坨镇凤凰岭路19号",
 "longitude": "116.08694",
 "latitude": "40.106758",
 "scenicOrder": "1",
 "shortIntroduction": "远郊的景，近郊的路，北京大自然的空调",
 "introduction": "远郊的景，近郊的路，北京的自然氧气库，是观光、度假和会议的理想去处。景区峰、石、林、泉等自然景观，与寺庙、刻字、佛塔、香道等人文景观互映成趣、相得益彰。景区有三条线路：北线可观流泉飞瀑，中线为京西名刹龙泉寺，南线是佛、道、儒三教文化荟粹之地。",
 */

@property (strong, nonatomic) NSNumber *id;
@property (copy, nonatomic) NSString *scenicName;
@property (copy, nonatomic) NSString *addr;
@property (copy, nonatomic) NSString *longitude;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *shortIntroduction;
@property (copy, nonatomic) NSString *introduction;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *labels;
@property (strong, nonatomic) NSArray *dynamicAttributes;
@property (strong, nonatomic) NSArray *spots;
@property (strong, nonatomic) NSArray *ticketInfos;

@end



@interface ScenicGetScenicByIdResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) ScenicModel * obj;

@end

@interface NetWork_mt_scenic_getScenicById : WCServiceBase

@property(nonatomic,copy) NSString * id;
@property(nonatomic,copy) NSString * nsukey;

@end
