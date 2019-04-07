//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//


#import "AddLocarionCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol LocationClickDelegate <NSObject>

-(void)localCellClick:(LocaltionModel*)model;

-(void)localDeleteClick;

@end

@interface AddLocationViewController : ZJBaseViewController<UIViewControllerTransitioningDelegate,UITextFieldDelegate>

//title
@property (nonatomic,strong) UIButton *headButton;
@property (nonatomic,strong) UIView *textFieldBgView;
@property (nonatomic,strong) UIButton *cancleButton;
@property (nonatomic,strong) UITextField * textFieldSearchKey;

@property(nonatomic,assign) CGRect keyBoardFrame; //键盘的frame

@property(nonatomic,weak) id <LocationClickDelegate> delegate;

//返回播放列表Block
@property (nonatomic, copy) void(^backClickBlock)();



@end
