//
//  TCVideoEditBGMHelper.m
//  TXXiaoShiPinDemo
//
//  Created by linkzhzhu on 2017/12/7.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "TCBGMHelper.h"
#import "AFHTTPSessionManager.h"
#import "pthread.h"
#import "TCLoginModel.h"
#import "TCConstants.h"

@interface TCBGMHelper(){
    NSDictionary* _configs;
    NSUserDefaults* _userDefaults;
    NSString* _userIDKey;
//    NSMutableDictionary* _tasks;
    NSURLSessionDownloadTask* _currentTask;
    TCBGMElement* _currentEle;
    NSString* _bgmPath;
}
//@property(nonatomic, assign)pthread_mutex_t lock;
//@property(nonatomic, assign)pthread_cond_t cond;
//@property(nonatomic, strong)dispatch_queue_t queue;

@property(nonatomic,weak) id <TCBGMHelperListener>delegate;
@end

static TCBGMHelper* _sharedInstance;
static pthread_mutex_t _instanceLock = PTHREAD_MUTEX_INITIALIZER;
@implementation TCBGMHelper

+ (instancetype)sharedInstance {
    if(!_sharedInstance){
        pthread_mutex_lock(&_instanceLock);
        _sharedInstance = [TCBGMHelper new];
        pthread_mutex_unlock(&_instanceLock);
    }
    return _sharedInstance;
}

-(void) setDelegate:(nonnull id<TCBGMHelperListener>) delegate{
    _delegate = delegate;
}

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

-(void) downloadBGM:(TCBGMElement*) current{
    
    
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
    
    NSURLSessionDownloadTask* task = [TCBGMHelper downloadFile:current.netUrl dstUrl:current.localUrl callback:^(float percent, NSString* path){
        
        NSLog(@"-------percent = %f----",percent);
        if(percent == 0){
            [self.delegate onBGMDownloadDone:current];
        }
        else{
            [self.delegate onBGMDownloading:current percent:percent];
        }
    }];
    
    _currentTask = task;
    _currentEle = current;

}


/**
 下载函数回调
 
 @param percent 下载进度 < 0 出错并终止
 @param url 最终文件地址 nil != url则下载完成
 */
typedef void(^DownLoadCallback)(float percent, NSString* url);
+(NSURLSessionDownloadTask*) downloadFile:(NSString*)srcUrl dstUrl:(NSString*)dstUrl callback:(DownLoadCallback)callback{
    //    __weak __typeof(self) weakSelf = self;
    NSURLRequest *downloadReq = [NSURLRequest requestWithURL:[NSURL URLWithString:srcUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300.f];
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
                callback(-1, nil);
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


@implementation TCBGMElement
- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.name = [coder decodeObjectForKey:@"name"];
        self.netUrl = [coder decodeObjectForKey:@"netUrl"];
        self.localUrl = [coder decodeObjectForKey:@"localUrl"];
        self.author = [coder decodeObjectForKey:@"author"];
        self.title = [coder decodeObjectForKey:@"title"];
        self.isValid = [coder decodeObjectForKey:@"isValid"];
        self.duration = [coder decodeObjectForKey:@"duration"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_netUrl forKey:@"netUrl"];
    [coder encodeObject:_localUrl forKey:@"localUrl"];
    [coder encodeObject:_author forKey:@"author"];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_isValid forKey:@"isValid"];
    [coder encodeObject:_duration forKey:@"duration"];
}
@end
