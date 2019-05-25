//
//  GlobalFunc.h
//  ChinaDream
//
//  Created by zhangfeng on 12-11-26.
//  Copyright (c) 2012年 eastedge. All rights reserved.
//

#import "SharePopViewVideo.h"
#import "WebCacheHelpler.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoGenerateFunc : NSObject<TXVideoGenerateListener>

+ (VideoGenerateFunc *)sharedInstance;


//视频合成，用于保存后发到微信好友
@property (strong,nonatomic) AVAsset  *videoAsset;
@property (strong,nonatomic)  TXVideoEditer*  ugcEdit;    //sdk编辑器
@property (nonatomic, assign) MTShareType shareType; //分享类型
@property (nonatomic, assign) MTShareActionType actionType; //按钮点击类型类型

-(void)globalFuncGenerateVideo:(NSString*)videoPath shareType:(MTShareType)shareType; //视频保存本地后，打开微信或者qq

-(void)globalFuncGenerateVideo:(NSString*)videoPath; //生成视频后保存至相册

@end



