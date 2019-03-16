//
//  TCVideoEditBGMHelper.h
//  TXXiaoShiPinDemo
//
//  Created by linkzhzhu on 2017/12/7.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BGM_DEBUG 1

#define BGMLog(...) {\
if(BGM_DEBUG)NSLog(__VA_ARGS__);\
}

#import "NetWork_mt_getMusicList.h"

//@protocol MusicDownloadListener <NSObject>
//
///**
// 每首BGM的进度回调
// */
//-(void) onBGMDownloading:(MusicModel*)current percent:(float)percent;
//
///**
// 下载结束回调，失败current返回nil
// */
//-(void) onBGMDownloadDone:(MusicModel*)element;
//
//@end


@interface MusicDownloadHelper : NSObject

//-(void) setDelegate:(nonnull id<MusicDownloadListener>) delegate;

+ (instancetype)sharedInstance;
/**
 下载BGM
新任务->新下载
当前正在下载->暂停下载
当前暂停->恢复下载
当前下载完成->重新下载

 @param name BGM名称
 */
-(void) downloadMusicWithBlock:(MusicModel*) musicModel downloadBlock:(void(^)(float percent))downloadBlock;

////更新下载进度，block
//@property(nonatomic,copy) void (^downloadBlock)(MusicModel *current,float percent);


@end
