//
//  SharePopView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "SharePopViewDownload.h"

//引入分享微信
#import "WXApi.h"
//引入qq 互联
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "NetWork_mt_forwardAppCount.h"


@implementation SharePopViewDownload

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *topIconsName = @[
                                 @"icon_profile_share_wxTimeline",
                                 @"icon_profile_share_wechat",
                                 @"icon_profile_share_qqZone",
                                 @"icon_profile_share_qq"
                                 ];
        NSArray *topTexts = @[
                             @"朋友圈",
                             @"微信好友",
                             @"QQ空间",
                             @"QQ好友",
                             ];
        
        self.frame = ScreenFrame;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 180 + SafeAreaBottomHeight)];
        _container.backgroundColor = ColorBlackAlpha60;
        [self addSubview:_container];
        
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _container.layer.mask = shape;
        
        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualEffectView.frame = self.bounds;
        visualEffectView.alpha = 1.0f;
        [_container addSubview:visualEffectView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = @"分享到";
        label.textColor = ColorGray;
        label.font = MediumFont;
        [_container addSubview:label];
        
        
        CGFloat itemWidth = 68;
        
        UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth, 90)];
        topScrollView.contentSize = CGSizeMake(itemWidth * topIconsName.count, 80);
        topScrollView.showsHorizontalScrollIndicator = NO;
        topScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
        [_container addSubview:topScrollView];
        
        for (NSInteger i = 0; i < topIconsName.count; i++) {
            
            ShareItemDown *item = [[ShareItemDown alloc] initWithFrame:CGRectMake(20 + itemWidth*i, 0, 48, 90)];
            item.icon.image = [UIImage imageNamed:topIconsName[i]];
            item.label.text = topTexts[i];
            item.tag = (MTShareType)i;
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShareItemTap:)]];
            [item startAnimation:i*0.03f];
            [topScrollView addSubview:item];
        }
        
        _cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 130, ScreenWidth, 50 + SafeAreaBottomHeight)];
        [_cancel setTitleEdgeInsets:UIEdgeInsetsMake(-SafeAreaBottomHeight, 0, 0, 0)];
        
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_cancel setTitleColor:ColorWhite forState:UIControlStateNormal];
        _cancel.titleLabel.font = BigFont;

        _cancel.backgroundColor = ColorGrayLight;
        [_container addSubview:_cancel];
        
        UIBezierPath* rounded2 = [UIBezierPath bezierPathWithRoundedRect:_cancel.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
        CAShapeLayer* shape2 = [[CAShapeLayer alloc] init];
        [shape2 setPath:rounded2.CGPath];
        _cancel.layer.mask = shape2;
        [_cancel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
    }
    return self;
}

- (void)onShareItemTap:(UITapGestureRecognizer *)sender {
    
    NSString *shareTitle = @"面条短视频";
    NSString *shareDescription = @"上面有很多有趣的视频,你也来看一下吧！";
    NSString *apiBaseUrl = [WCBaseContext sharedInstance].appInterfaceServer;
    NSString *shareUrl = [NSString stringWithFormat:@"%@/miantiao/home/shareApp",apiBaseUrl];
    UIImage * shareImage =  [UIImage imageNamed:@"login_icon"];

     NSString *shareType = @"";//分享类型1.微信好友2.微信朋友圈3.QQ好友4.QQ空间

    
    if(sender.view.tag == 0){ //分享到微信朋友圈
        
        
        if (![WXApi isWXAppInstalled]) {
            //判断是否有微信
            NSLog(@"没有微信");
            [[[iToast makeText:@"您的手机没有安装微信"] setGravity:iToastGravityCenter] show];
        }
        else{
            shareType = @"2"; //朋友圈
            //分享朋友圈只显示title，所以将title和描述合在一起。
//            shareTitle = [NSString stringWithFormat:@"@%@ %@",self.homeListModel.nickname,shareDescription];

            
            //创建发送对象实例
            SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
            sendReq.bText = NO;//不使用文本信息
            sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
            //创建分享内容对象
            WXMediaMessage *urlMessage = [WXMediaMessage message];
            urlMessage.title = [NSString stringWithFormat:@"%@,%@",shareTitle,shareDescription];
            
            [urlMessage setThumbImage:shareImage];//分享图片,使用SDK的setThumbImage方法可压缩图片大小

            //创建多媒体对象
            WXWebpageObject *webObj = [WXWebpageObject object];
            webObj.webpageUrl = shareUrl;
            //完成发送对象实例
            urlMessage.mediaObject = webObj;
            sendReq.message = urlMessage;
            //发送分享信息
            [WXApi sendReq:sendReq];
        }
    }
    else if (sender.view.tag == 1){//分享到微信好友
        if (![WXApi isWXAppInstalled]) {
            //判断是否有微信
            NSLog(@"没有微信");
            [[[iToast makeText:@"您的手机没有安装微信"] setGravity:iToastGravityCenter] show];
        }
        else{
            shareType = @"1"; //微信好友
            //创建发送对象实例
            SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
            sendReq.bText = NO;//不使用文本信息
            sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
            //创建分享内容对象
            WXMediaMessage *urlMessage = [WXMediaMessage message];
            urlMessage.title = shareTitle;
            if (shareDescription.length > 19) {
                NSString *str=[shareDescription substringToIndex:19];
                urlMessage.description = [NSString stringWithFormat:@"%@...",str];//分享描述
            }else{
                urlMessage.description = shareDescription;
            }
            [urlMessage setThumbImage:shareImage];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
            WXWebpageObject *webObj = [WXWebpageObject object];
            webObj.webpageUrl = shareUrl;
            //完成发送对象实例
            urlMessage.mediaObject = webObj;
            sendReq.message = urlMessage;
            //发送分享信息
            [WXApi sendReq:sendReq];
        }
    }
    else if (sender.view.tag == 2){//分享到qq空间
        
        if (![TencentOAuth iphoneQQInstalled]) {
            [[[iToast makeText:@"您的手机没有安装QQ"] setGravity:iToastGravityCenter] show];
        }
        else{
            shareType = @"4"; //qq空间
            NSData *imageData = UIImagePNGRepresentation(shareImage);

            QQApiNewsObject  * newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:shareTitle description:shareDescription previewImageData:imageData];
            //这个貌似是直接拉起QQ空间分享的值，0为NO，1为YES.文档上没有。
            uint64_t cflag = 1;
            [newsObj  setCflag:cflag];
            SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:newsObj];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            [self handleSendResult:sent];
        }
    }
    else if (sender.view.tag == 3){//分享给qq好友
        if (![TencentOAuth iphoneQQInstalled]) {
            [[[iToast makeText:@"您的手机没有安装QQ"] setGravity:iToastGravityCenter] show];
        }
        else{
            shareType = @"3"; //qq好友
            
            NSData *imageData = UIImagePNGRepresentation(shareImage);

            
            QQApiNewsObject  * newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:shareTitle description:shareDescription previewImageData:imageData];
            SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:newsObj];
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [self handleSendResult:sent];
        }
    }
    
    /*
     上报分享结果
     */
    [self reportShareResult:shareType];
    
    [self dismiss];
    
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"手Q API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiTextObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiImageObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case ETIMAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前TIM版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPITIMNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装TIM" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPITIMNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"TIM API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISHAREDESTUNKNOWN:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未指定分享到QQ或TIM" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
        }
            break;
        default:
        {
            break;
        }
    }
}

- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
    point = [sender locationInView:_cancel];
    if([_cancel.layer containsPoint:point]) {
        [self dismiss];
    }
}

- (void)reportShareResult:(NSString *)shareType{
    NetWork_mt_forwardAppCount *request = [[NetWork_mt_forwardAppCount alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.forwardType = shareType;
    [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
        if(finished){
            NSLog(@"分享接口调用成功。");
        }
    }];
}

- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y - frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end



#pragma Item view

@implementation ShareItemDown

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"iconHomeAllshareCopylink"];
        _icon.contentMode = UIViewContentModeScaleToFill;
        _icon.userInteractionEnabled = YES;
        [self addSubview:_icon];
        
        _label = [[UILabel alloc] init];
        _label.text = @"TEXT";
        _label.textColor = ColorWhiteAlpha60;
        _label.font = MediumFont;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}
-(void)startAnimation:(NSTimeInterval)delayTime {
    CGRect originalFrame = self.frame;
    self.frame = CGRectMake(CGRectGetMinX(originalFrame), 35, originalFrame.size.width, originalFrame.size.height);
    [UIView animateWithDuration:0.9f
                          delay:delayTime
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = originalFrame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(48);
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(10);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.icon.mas_bottom).offset(10);
    }];
}

@end
