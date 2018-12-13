//
//  NetWork_ZJ_get_message_list.h
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/14.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZjCreateApplicationModel : IObjcJsonBase

@property(nonatomic,copy) NSString * material_name;
@property(nonatomic,copy) NSString * material_number;
@property(nonatomic,copy) NSString * sh_name;
@property(nonatomic,copy) NSString * sh_number;
@property(nonatomic,copy) NSString * material_price;
@property(nonatomic,copy) NSNumber * material_count;

@end


@interface ZjCreateApplicationTempModel : IObjcJsonBase

@property(nonatomic,copy) NSArray * material;


@end



@interface ZjCreateApplicationRespone : IObjcJsonBase

@property(nonatomic,copy) NSString *status_code;
@property(nonatomic,strong) ZjCreateApplicationTempModel * result;
@property(nonatomic,copy) NSString *errmsg;

@end

@interface NetWork_ZJ_wm_materials_create_application : WCServiceBase_Zjsh

@property(nonatomic,copy) NSString *request_number;
@property(nonatomic,copy) NSString *application_form;



@end
