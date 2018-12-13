//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface SaveflourContentModel : IObjcJsonBase

@property (copy, nonatomic) NSString *flourId;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *flourHead;
@property (copy, nonatomic) NSString *flourNickname;
@property (copy, nonatomic) NSString *flourSignature;
@property (copy, nonatomic) NSString *noodleHead    ;
@property (copy, nonatomic) NSString *noodleNickname;
@property (copy, nonatomic) NSString *noodleSignature;

@end

@interface SaveflourModel : IObjcJsonBase

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *oldNoodleId;

@end



@interface SaveflourResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) LoginModel * obj;

@end

@interface NetWork_mt_saveflour : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * content;



@end
