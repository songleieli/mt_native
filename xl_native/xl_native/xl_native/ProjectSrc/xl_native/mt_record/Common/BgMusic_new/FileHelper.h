//
//  TCVideoEditBGMHelper.h
//  TXXiaoShiPinDemo
//
//  Created by linkzhzhu on 2017/12/7.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileHelper : NSObject

+ (void) downloadFile :(NSString*)localUrl
               playUrl:(NSString*)playUrl
          processBlock:(void(^)(float percent))processBlock
       completionBlock:(void(^)(BOOL result,NSString *msg))completionBlock;


@end
