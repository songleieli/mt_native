//
//  GlobalFunc.m
//  ChinaDream
//
//  Created by zhangfeng on 12-11-26.
//  Copyright (c) 2012年 eastedge. All rights reserved.
//

#import "VideoGenerateFunc.h"
#import "sys/utsname.h"
#import "Reachability.h"
#import "GlobalData.h"

static VideoGenerateFunc *sharedInstance;

@implementation VideoGenerateFunc

+ (VideoGenerateFunc *)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



-(void)globalFuncGenerateVideo:(NSString*)videoPath shareType:(MTShareType)shareType{
    
    
    self.shareType = shareType;
    
    [GlobalFunc hideHUD:1.0f];
    
    //开始合成视频
    NSURL *avUrl = [NSURL fileURLWithPath:videoPath];
    self.videoAsset = [AVAsset assetWithURL:avUrl];
    
    
    TXPreviewParam *param = [[TXPreviewParam alloc] init];
    //    param.videoView = _videoPreview.renderView;
    param.renderMode = PREVIEW_RENDER_MODE_FILL_EDGE;
    
    self.ugcEdit = [[TXVideoEditer alloc] initWithPreview:param];
    ///生成视频回调的委托对象, 可以获取生成进度与完成时间等
    self.ugcEdit.generateDelegate = self;
    //设置视频 AVAsset
    [self.ugcEdit setVideoAsset:self.videoAsset];
    
    TXVideoInfo *videoMsg = [TXVideoInfoReader getVideoInfoWithAsset:self.videoAsset];
    UIImage *tailWaterimage = [UIImage imageNamed:@"watermark"];
    [self.ugcEdit setWaterMark:tailWaterimage normalizationFrame:CGRectMake(0.01, 0.01, 0.3 , 0)]; //全局水印
    
    float w = 0.35;
    float x = (1.0 - w) / 2.0;
    float width = w * videoMsg.width;
    float height = width * tailWaterimage.size.height / tailWaterimage.size.width;
    float y = (videoMsg.height - height) / 2 / videoMsg.height;
    [self.ugcEdit setTailWaterMark:tailWaterimage normalizationFrame:CGRectMake(x,y,w,0) duration:1];//片尾水印
    
    NSString *videoOutputPath = [[WebCacheHelpler sharedWebCache].diskCachePath stringByAppendingPathComponent:@"outputCut_temp.mp4"];
    //[self.ugcEdit generateVideo:VIDEO_COMPRESSED_720P videoOutputPath:videoOutputPath];
    [self.ugcEdit generateVideo:[GlobalData sharedInstance].videoQuality videoOutputPath:videoOutputPath];
    
}


#pragma -mark  ----------- TXVideoGenerateListener ---------

/**
 * 短视频生成完成
 * @param progress 生成视频进度百分比
 */
-(void) onGenerateProgress:(float)progress{
    [GlobalFunc showHud:[NSString stringWithFormat:@"正在加载视频%d %%",(int)(progress * 100)]];
}

/**
 * 短视频生成完成
 * @param result 生成结果
 * @see TXGenerateResult
 */
-(void) onGenerateComplete:(TXGenerateResult *)result{
    
    [GlobalFunc hideHUD];
    
    NSString *videoOutputPath = [[WebCacheHelpler sharedWebCache].diskCachePath stringByAppendingPathComponent:@"outputCut_temp.mp4"];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoOutputPath] completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error != nil) {
            [GlobalFunc showAlertWithMessage:@"视频保存失败！"];
        }else{
            //            [GlobalFunc showAlertWithMessage:@"视频保存成功！"];
            
            if(self.shareType == MTShareTypeWechatVideo){
                
                NSURL * url = [NSURL URLWithString:@"weixin://"];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                //先判断是否能打开该url
                if (canOpen)
                {   //打开微信
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [GlobalFunc showAlertWithMessage:@"没有安装微信"];
                }
            }
            
            else if (self.shareType == MTShareTypeRegQQVideo){
                NSURL * url = [NSURL URLWithString:@"mqq://"];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                //先判断是否能打开该url
                if (canOpen)
                {   //打开微信
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [GlobalFunc showAlertWithMessage:@"没有安装qq"];
                }
            }
            
        }
    }];
}



@end

