//
//  SharePopView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MTShareType){
    
    MTShareTypeFriendCircle = 0,
    MTShareTypeWechat,
    MTShareTypeQQZone,
    MTShareTypeQQ,
    MTShareTypeWechatVideo
};



@interface SharePopViewDownload:UIView

@property (nonatomic, strong) UIView           *container;
@property (nonatomic, strong) UIButton         *cancel;

- (void)show;
- (void)dismiss;

@end


@interface ShareItemDown:UIView

@property (nonatomic, strong) UIImageView      *icon;
@property (nonatomic, strong) UILabel          *label;



-(void)startAnimation:(NSTimeInterval)delayTime;

@end


