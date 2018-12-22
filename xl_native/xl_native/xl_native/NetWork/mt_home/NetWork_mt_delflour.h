//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface DelFlourContentModel : IObjcJsonBase

@property (copy, nonatomic) NSString *flourId;
@property (copy, nonatomic) NSString *noodleId;

@end

@interface DelFlourModel : IObjcJsonBase

@end



@interface DelFlourResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) LoginModel * obj;

@end

@interface NetWork_mt_delflour : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * content;



@end
