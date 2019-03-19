//
//  TCVideoEditBGMHelper.m
//  TXXiaoShiPinDemo
//
//  Created by linkzhzhu on 2017/12/7.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "MusicDownloadHelper.h"
#import "AFHTTPSessionManager.h"
#import "pthread.h"
#import "TCConstants.h"

@interface MusicDownloadHelper(){
    NSDictionary* _configs;
    NSUserDefaults* _userDefaults;
    NSString* _userIDKey;
//    NSMutableDictionary* _tasks;
    NSURLSessionDownloadTask* _currentTask;
//    MusicModel* _currentEle;
    NSString* _bgmPath;
}
//@property(nonatomic, assign)pthread_mutex_t lock;
//@property(nonatomic, assign)pthread_cond_t cond;
//@property(nonatomic, strong)dispatch_queue_t queue;

//@property(nonatomic,weak) id <MusicDownloadListener>delegate;
@end

static MusicDownloadHelper* _sharedInstance;
static pthread_mutex_t _instanceLock = PTHREAD_MUTEX_INITIALIZER;
@implementation MusicDownloadHelper

+ (instancetype)sharedInstance {
    if(!_sharedInstance){
        pthread_mutex_lock(&_instanceLock);
        _sharedInstance = [MusicDownloadHelper new];
        pthread_mutex_unlock(&_instanceLock);
    }
    return _sharedInstance;
}

//-(void) setDelegate:(nonnull id<MusicDownloadListener>) delegate{
//    _delegate = delegate;
//}

-(id) init{
    if(self = [super init]){
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        _bgmPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/bgm"];
        if(![fileManager fileExistsAtPath:_bgmPath]){
            if(![fileManager createDirectoryAtPath:_bgmPath withIntermediateDirectories:YES attributes:nil error:nil]){
                BGMLog(@"创建BGM目录失败");
                return nil;
            }
        }
//        pthread_mutex_init(&_lock, NULL);
//        pthread_cond_init(&_cond, NULL);
//        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:BGM_GROUP];
//        if (_userDefaults == nil) {
//            _userDefaults = [NSUserDefaults standardUserDefaults];
//        }
//        _tasks = [[NSMutableDictionary alloc] init];
        //_userIDKey = [[TCLoginParam shareInstance].identifier stringByAppendingString:@"_bgm"];
//        _userIDKey = @"Songleilei_bgm"; //modify by songleilei
//        _queue = dispatch_queue_create("com.tencent.txcloud.videoedit.bgm.download", NULL);
//        dispatch_async(_queue, ^{[self loadLocalData];});
    }
    return self;
}

- (void)dealloc {
//    pthread_mutex_destroy(&_lock);
//    pthread_cond_destroy(&_cond);
}

-(void) downloadMusicWithBlock:(MusicSearchModel*) musicModel downloadBlock:(void(^)(float percent,NSString *msg))downloadBlock{
    
    
    /*
    if([[_currentEle netUrl] isEqualToString:[current netUrl]]){
        
        
        if([_currentTask state] == NSURLSessionTaskStateRunning){
            BGMLog(@"暂停：%@", [current name]);
            [_currentTask suspend];
            return;
        }
        else if([_currentTask state] == NSURLSessionTaskStateSuspended){
            BGMLog(@"恢复：%@", [current name]);
            [_currentTask resume];
            return;
        }

    }
    */

    
    NSURLSessionDownloadTask* task = [MusicDownloadHelper downloadFile:musicModel.playUrl dstUrl:musicModel.localUrl callback:^(float percent, NSString* path){
        
//        NSLog(@"-------percent = %f----",percent);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            //更新下载进度
            if(downloadBlock){
                downloadBlock(percent,path);
            }
        });
        
//        if(percent == 0){
//            [self.delegate onBGMDownloadDone:current];
//        }
//        else{
//            [self.delegate onBGMDownloading:current percent:percent];
//        }
    }];
    
    _currentTask = task;
//    _currentEle = musicModel;
}

/**
 下载函数回调
 
 @param percent 下载进度 < 0 出错并终止
 @param url 最终文件地址 nil != url则下载完成
 */
typedef void(^DownLoadCallback)(float percent, NSString* url);



+(NSURLSessionDownloadTask*) downloadFile:(NSString*)srcUrl dstUrl:(NSString*)dstUrl callback:(DownLoadCallback)callback{
    
    
    NSURLRequest *downloadReq = [NSURLRequest requestWithURL:[NSURL URLWithString:srcUrl]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:5.0f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //注意这里progress/destination是异步线程 completionHandler是main-thread
    NSURLSessionDownloadTask* task = [manager downloadTaskWithRequest:downloadReq progress:^(NSProgress * _Nonnull downloadProgress) {
        if (callback != nil) {
            callback(downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount, nil);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath_, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:dstUrl];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if(callback){
                callback(-1, @"音乐加载失败，请稍后再试.");
            }
            return;
        }
        else{
            if(callback){
                callback(0, dstUrl);
            }
        }
    }];
    [task resume];
    return task;
}
@end

