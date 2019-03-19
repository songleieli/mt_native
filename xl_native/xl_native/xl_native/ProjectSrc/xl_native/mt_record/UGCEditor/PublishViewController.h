//
//  DeliverArticleViewController.h
//  CMPLjhMobile
//
//  Created by 刘欣 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseViewController.h"
#import "NetWork_mt_search_getMusicList.h"


@interface PublishViewController : ZJBaseViewController<UITextViewDelegate>


@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UITextView * speakTextView;
@property (nonatomic,strong) UILabel * placeHoldelLebel;


@property (copy,nonatomic) NSString *videoPath;
@property (copy,nonatomic) NSString *videoOutputCoverPath;

@property (strong,nonatomic) MusicSearchModel  *musicModel;

@property (copy,nonatomic) UIProgressView* _generateProgressView;


@end
