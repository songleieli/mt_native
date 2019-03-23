//
//  DeliverArticleViewController.h
//  CMPLjhMobile
//
//  Created by 刘欣 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseViewController.h"
#import "NetWork_mt_search_getMusicList.h"
#import "TCBGMProgressView.h"


@interface PublishViewController : ZJBaseViewController<UITextViewDelegate>


@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UITextView * speakTextView;
@property (nonatomic,strong) UILabel * placeHoldelLebel;
@property (nonatomic, strong) UIImageView  *imageViewCover; //视频封面


@property (nonatomic,strong) UIButton * btnTopic;
@property (nonatomic,strong) UIButton * btnAFriend;
@property (nonatomic,strong) UIView *viewLine;


@property (nonatomic,strong) UIButton * btnLocation; //位置View
@property (nonatomic, strong) UIButton  *btnDraft; //草稿按钮
@property (nonatomic, strong) UIButton  *btnSave; //保存按钮



@property (copy,nonatomic) NSString *videoPath;
@property (copy,nonatomic) NSString *videoOutputCoverPath;

@property (strong,nonatomic) MusicSearchModel  *musicModel;

@property (nonatomic, strong) TCBGMProgressView *progressView;




@end
