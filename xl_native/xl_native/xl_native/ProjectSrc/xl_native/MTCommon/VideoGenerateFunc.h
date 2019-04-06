//
//  GlobalFunc.h
//  ChinaDream
//
//  Created by zhangfeng on 12-11-26.
//  Copyright (c) 2012年 eastedge. All rights reserved.
//

#import "SharePopView.h"
#import "WebCacheHelpler.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoGenerateFunc : NSObject<TXVideoGenerateListener>

+ (VideoGenerateFunc *)sharedInstance;


//视频合成，用于保存后发到微信好友
@property (strong,nonatomic) AVAsset  *videoAsset;
@property (strong,nonatomic)  TXVideoEditer*  ugcEdit;    //sdk编辑器
@property (nonatomic, assign) MTShareType shareType;

-(void)globalFuncGenerateVideo:(NSString*)videoPath shareType:(MTShareType)shareType;

@end



