//
//  NetWork_ZJ_get_message_list.m
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/14.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_ZJ_incident_requests_status.h"


@implementation ZjIncidentRequestsStatusRespone


@end

@implementation NetWork_ZJ_incident_requests_status

-(Class)responseType{
    return [ZjIncidentRequestsStatusRespone class];
}

-(NSString*)responseCategory{
    return @"/api/v1/incident_requests/status";
}

@end
