//
//  DeliverArticleViewController.h
//  CMPLjhMobile
//
//  Created by 刘欣 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseViewController.h"
#import "TCBGMProgressView.h"
#import "AddTopicViewController.h"
#import "AtFriendViewController.h"
#import "AddLocationViewController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "mt_common_model_atFriend_topic.h"
#import "NetWork_mt_search_getMusicList.h"


@interface PublishViewController : ZJBaseViewController<UITextViewDelegate,TopicClickDelegate,AtFriendClickDelegate,LocationClickDelegate,CLLocationManagerDelegate>


@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UITextView * speakTextView;
@property (nonatomic,strong) UILabel * placeHoldelLebel;
@property (nonatomic, strong) UIImageView  *imageViewCover; //视频封面


@property (nonatomic,strong) UIButton * btnTopic;
@property (nonatomic,strong) UIButton * btnAFriend;
@property (nonatomic,strong) UIView *viewLine;
@property(nonatomic,strong) UIScrollView * scrollerLocation; //地址滚动条


@property (nonatomic,strong) UIButton * btnLocation; //位置View
@property (nonatomic, strong) UIButton  *btnDraft; //草稿按钮
@property (nonatomic, strong) UIButton  *btnSave; //保存按钮

/*
 *话题数组和@数组
 */
@property (strong, nonatomic) NSMutableArray *topicArray;
@property (strong, nonatomic) NSMutableArray *atArray;
@property (strong, nonatomic) NSMutableArray *atAndTopicArray;
/// 光标位置
@property (assign, nonatomic) NSInteger cursorLocation;
/// 改变Range
@property (assign, nonatomic) NSRange changeRanges;
/// 是否改变
@property (assign, nonatomic) BOOL isChanged;

//用户当前GPS坐标
@property(assign, nonatomic) CLLocationCoordinate2D coordinate;

@property (copy,nonatomic) NSString *videoPath;
@property (copy,nonatomic) NSString *videoOutputCoverPath;

@property (strong,nonatomic) MusicSearchModel  *musicModel;
@property (strong,nonatomic) LocaltionModel  *localtionModel;

@property (nonatomic, strong) TCBGMProgressView *progressView;


@end
