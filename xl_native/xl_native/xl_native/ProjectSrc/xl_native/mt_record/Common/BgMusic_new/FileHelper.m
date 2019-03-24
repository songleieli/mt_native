//
//  TCVideoEditBGMHelper.m
//  TXXiaoShiPinDemo
//
//  Created by linkzhzhu on 2017/12/7.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "FileHelper.h"
#import "AFHTTPSessionManager.h"

@interface FileHelper(){
}
@end

@implementation FileHelper


+ (void) downloadFile :(NSString*)localUrl
               playUrl:(NSString*)playUrl
          processBlock:(void(^)(float percent))processBlock
       completionBlock:(void(^)(BOOL result,NSString *msg))completionBlock{
    
    
    NSString *fileDir = [localUrl stringByDeletingLastPathComponent]; //根据文件路径获取文件躲在目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:fileDir]){
        if(![fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil]){
            NSLog(@"创建文件目录失败");
            return;
        }
    }
    
    NSURLRequest *downloadReq = [NSURLRequest requestWithURL:[NSURL URLWithString:playUrl]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:5.0f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //注意这里progress/destination是异步线程 completionHandler是main-thread
    NSURLSessionDownloadTask* task = [manager downloadTaskWithRequest:downloadReq progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (processBlock != nil) {
                processBlock(downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount);
            }
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath_, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:localUrl];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if(completionBlock){
                completionBlock(NO, @"文件下载失败，请稍后再试.");
            }
            return;
        }
        else{
            if(completionBlock){
                completionBlock(YES, localUrl);
            }
        }
    }];
    [task resume];
}

@end

