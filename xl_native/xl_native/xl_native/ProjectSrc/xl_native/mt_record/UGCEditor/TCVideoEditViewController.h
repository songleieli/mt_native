//
//  TCVideoEditViewController.h
//  TCLVBIMDemo
//
//  Created by xiang zhang on 2017/4/10.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWork_mt_getUploadSignature.h"
#import "PublishViewController.h"

#import "MBProgressHUD.h"


@interface TCVideoEditViewController : ZJBaseViewController

@property (copy,nonatomic) NSString *videoPath;

@property (strong,nonatomic) AVAsset  *videoAsset;

//从剪切过来
@property (assign,nonatomic) BOOL     isFromCut;

//从合唱过来
@property (assign,nonatomic) BOOL     isFromChorus;

@property (assign, nonatomic) int     renderRotation;


@property (strong,nonatomic) MusicSearchModel  *musicModel;



@end
