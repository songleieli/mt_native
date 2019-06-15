//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//


#import "NetWork_mt_getFollows.h"


#import "MessageCell.h"

@protocol AtFriendClickDelegate <NSObject>

-(void)AtFriendClick:(GetFollowsModel*)model;

@end

@interface AtFriendViewController : ZJBaseViewController<UIViewControllerTransitioningDelegate,UITextFieldDelegate,MyFollowDelegate>

//title
@property (nonatomic,strong) UIView *textFieldBgView;
@property (nonatomic,strong) UIButton *cancleButton;
@property (nonatomic,strong) UITextField * textFieldSearchKey;
@property (nonatomic,assign) BOOL hasKeyBordShow;

@property(nonatomic,weak) id <AtFriendClickDelegate> delegate;


//返回播放列表Block
@property (nonatomic, copy) void(^backClickBlock)();



@end
