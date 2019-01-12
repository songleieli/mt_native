//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

@interface UpdateNoodleAccountContentModel : IObjcJsonBase

@property(nonatomic,copy) NSString * noodleId;
@property(nonatomic,copy) NSString * nickname;
@property(nonatomic,copy) NSString * sex;
@property(nonatomic,copy) NSString * birthday;
@property(nonatomic,copy) NSString * school;
@property(nonatomic,copy) NSString * department;
@property(nonatomic,copy) NSString * enrolmentTime;
@property(nonatomic,copy) NSString * company;
@property(nonatomic,copy) NSString * signature;
@property(nonatomic,copy) NSString * city;
@property(nonatomic,copy) NSString * addr;
@property(nonatomic,copy) NSString * country;

@end

@interface UpdateNoodleAccountResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSString * obj;

@end

@interface NetWork_mt_updateNoodleAccount : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * content;

@end
