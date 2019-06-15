//
//  CenterControl.m
//  HeBeiFM
//
//  Created by 经纬中天 on 16/5/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MTControlCenter.h"


@interface MTControlCenter (){
    NSMutableArray *_pathArr;
    NSTimer *_messageUpdateTimer;
}
@end

@implementation MTControlCenter

+(MTControlCenter *)shareControl{
    
    static MTControlCenter *shareControlInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareControlInstance = [[self alloc] init];
    });
    return shareControlInstance;
}



- (BOOL)hasLogin {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs boolForKey:LJH_ACCOUNT_USER_HASLOGIN];
}

- (void)setHasLogin:(BOOL)hasLogin {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:hasLogin forKey:LJH_ACCOUNT_USER_HASLOGIN];
    [prefs synchronize];
}

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}






//{image}/{filename} GET请求
+(void)checkVersion{
    
    /*
     检查版本优先级
     1. 如果 version <= 本地版本 不提示更新。
     2. 如果 version > 本地版本的情况。
     2.2 判断是不是在审核期间，如果在审核期间不提示更新。
     如果不是在审核期间，根据force 判断是强制升级还是常规升级。
     */
    
    NetWork_mt_upgrade *request = [[NetWork_mt_upgrade alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    [request startGetWithBlock:^(UpgradeResponse *result, NSString *msg, BOOL finished) {
        
        if(finished){
            
            NSString *ver = result.obj.version;
            NSString *localVer = [SL_Utils appShortVersion];
            
            //test
            //            localVer = @"0.5";
            //            result.obj.force = YES;
            
            CGFloat fNetVer = [self getFVersonBySVerson:ver];
            CGFloat fLocalVer = [self getFVersonBySVerson:localVer];
            
            
            if(fNetVer > fLocalVer){ //需要更新
                if(!result.obj.isAuditPeriod){ //非审核期间
                    
                    if(result.obj.force){ //强制更新
                        [GlobalFunc showAlertWithTitle:@"温馨提示" message:result.obj.des makeSure:^{
                            NSLog(@"------------");
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/mian-tiao-duan-shi-pin/id1459721021"]];
                            
                        }];
                    }
                    else{ //非强制更新
                        
                        [GlobalFunc showAlertWithTitle:@"温馨提示" message:result.obj.des makeSure:^{
                            NSLog(@"------------");
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/mian-tiao-duan-shi-pin/id1459721021"]];
                            
                        } cancel:nil];
                    }
                }
            }
            
            if(result.obj.isDrawActive){
                
                //test
//                [GlobalData sharedInstance].isLoadedApp = NO;
                
                if(![GlobalData sharedInstance].isLoadedApp){ //第一次启动App
                    [GlobalData sharedInstance].isLoadedApp = YES;
                    /*
                     *加载广告
                     */
                    [self showActiveView];
                }
            }
        }
    }];
}

+(CGFloat)getFVersonBySVerson:(NSString *)sVersion{
    
    NSRange fRange = [sVersion rangeOfString:@"."];
    CGFloat version = 0.00f;
    if(fRange.location != NSNotFound){
        sVersion = [sVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSMutableString *mVersion = [NSMutableString stringWithString:sVersion];
        [mVersion insertString:@"." atIndex:fRange.location];
        version = [mVersion floatValue];
    }else {
        // 版本应该有问题(由于ios 的版本 是7.0.1，没有发现出现过没有小数点的情况)
        version = [sVersion floatValue];
    }
    return version;
}


+(void)showActiveView{
    
    //UIWindow *window = [[UIApplication  sharedApplication] keyWindow];
    
    UIViewController *topRootViewController = [[UIApplication  sharedApplication] keyWindow].rootViewController;
    UIView *rootView = topRootViewController.view;
    
    UIImageView *viewPopAd = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    viewPopAd.image = [UIImage imageNamed:@"main_ad_bg"];
    //UIImageView - 解决Button加到ImageView上后Button 无法响应单击事件的方法
    viewPopAd.userInteractionEnabled = YES;
    
    [rootView addSubview:viewPopAd];
    [rootView bringSubviewToFront:viewPopAd];
    
    
    /*
     *迎新title
     */
    UIImageView *imageViewTitle = [[UIImageView alloc] init];
    imageViewTitle.size = [UIView getScaleSize_width:130 height:25];
    imageViewTitle.centerX = viewPopAd.width/2;
    imageViewTitle.top = sizeScale(30);
    imageViewTitle.image = [UIImage imageNamed:@"main_ad_title"];
    [viewPopAd addSubview:imageViewTitle];
    
    
    UIImageView *imageViewNoolde = [[UIImageView alloc] init];
    imageViewNoolde.tag = 81;
    imageViewNoolde.size = [UIView getSize_width:ScreenWidth height:ScreenWidth];
    imageViewNoolde.centerX = viewPopAd.width/2;
    imageViewNoolde.top = imageViewTitle.bottom;
    [imageViewNoolde setImage:[UIImage imageNamed:@"part_1"]];
    
    [viewPopAd addSubview:imageViewNoolde];
    
    /*
     *加载获奖人员名单
     */
    [self loadWinnersData:imageViewNoolde viewPopAd:viewPopAd];
    
    
    //test
    //    imageViewNoolde.backgroundColor = [UIColor redColor];
    
    //创建一个可变数组
    NSMutableArray *ary=[NSMutableArray new];
    for(int I=1;I<=2;I++){
        //通过for 循环,把我所有的 图片存到数组里面
        NSString *imageName=[NSString stringWithFormat:@"part_%d",I];
        UIImage *image=[UIImage imageNamed:imageName];
        [ary addObject:image];
    }
    
    // 设置图片的序列帧 图片数组
    imageViewNoolde.animationImages=ary;
    //动画重复次数
    imageViewNoolde.animationRepeatCount=1;
    //动画执行时间,多长时间执行完动画
    imageViewNoolde.animationDuration = 1.0;
    
    /*
     *抽奖和跳过按钮
     */
    UIButton *btnLuck = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLuck.tag = 90;
    btnLuck.size = [UIView getScaleSize_width:137 height:43];
    btnLuck.right = viewPopAd.width/2 - sizeScale(7);
    btnLuck.bottom = viewPopAd.height -sizeScale(35);
    [btnLuck setBackgroundImage:[UIImage imageNamed:@"main_ad_btn_luck"] forState:UIControlStateNormal];
    btnLuck.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnLuck setTitle:@"抽奖" forState:UIControlStateNormal];
    [btnLuck addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    btnLuck.titleLabel.font = [UIFont defaultFontWithSize:22];
    [viewPopAd addSubview:btnLuck];
    
    UIButton *btnSkip= [UIButton buttonWithType:UIButtonTypeCustom];
    btnSkip.tag = 91;
    btnSkip.size = [UIView getScaleSize_width:137 height:43];
    btnSkip.left = viewPopAd.width/2 + sizeScale(7);
    btnSkip.bottom = viewPopAd.height -sizeScale(35);
    [btnSkip setBackgroundImage:[UIImage imageNamed:@"main_ad_btn_skip"] forState:UIControlStateNormal];
    btnSkip.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnSkip setTitle:@"跳过" forState:UIControlStateNormal];
    [btnSkip addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    btnSkip.titleLabel.font = [UIFont defaultFontWithSize:22];
    [viewPopAd addSubview:btnSkip];
    
    /*
     *奖品池
     */
    MTGiftView *viewGift = [[MTGiftView alloc] init];
    viewGift.size = [UIView getSize_width:ScreenWidth height:sizeScale(80)];
    viewGift.centerX = viewPopAd.width/2;
    viewGift.top = imageViewNoolde.bottom;
    [viewPopAd addSubview:viewGift];
    
    if(viewGift.bottom > btnLuck.top){
        viewGift.bottom = btnLuck.top;
    }
    
    /*
     *加载奖品数据
     */
    [self loadPriceData:viewGift];
    
    
    UILabel *lableGiftTitle = [[UILabel alloc] init];
    lableGiftTitle.size = [UIView getSize_width:ScreenWidth height:50];
    lableGiftTitle.bottom = viewGift.top;
    lableGiftTitle.left = 10;
    
    lableGiftTitle.textAlignment = NSTextAlignmentCenter;
    lableGiftTitle.textColor = [UIColor blackColor];
    lableGiftTitle.font = [UIFont defaultFontWithSize:25];
    lableGiftTitle.text = @"奖品池";
    lableGiftTitle.textAlignment = NSTextAlignmentLeft;
    //test
    //    lableGiftTitle.backgroundColor = [UIColor redColor];
    
    [viewPopAd addSubview:lableGiftTitle];
}


+ (void)loadPriceData:(MTGiftView*)viewGift{
    NetWork_mt_getPrizeList *request = [[NetWork_mt_getPrizeList alloc] init];
    [request startGetWithBlock:^(GetPrizeListResponse *result, NSString *msg, BOOL finished) {
        if(finished){
            NSLog(@"--------");
            [viewGift reloadWithSource:result.obj rowCount:2];
        }
    }];
}

+ (void)loadWinnersData:(UIView*)imageViewNoolde viewPopAd:(UIImageView *)viewPopAd{
    
    
    NetWork_mt_getWinners *request = [[NetWork_mt_getWinners alloc] init];
    [request startGetWithBlock:^(GetWinnersResponse *result, NSString *msg, BOOL finished) {
        if(finished){
            //[self loadWinnersUI:result.obj];
            
            
            
            /*
             *中奖人员，跑马灯
             */
            
            NSMutableArray *tempArr = @[].mutableCopy;
            
            for(GetWinnerModel *model in result.obj){
                UILabel *labelOne = [UILabel new];
                labelOne.font = [UIFont systemFontOfSize:13];
                labelOne.text = [NSString stringWithFormat:@"%@ 获得 [%@]   %@",model.nickname,model.jiangpinName,model.wTime];
                labelOne.textColor = [UIColor blackColor];
                labelOne.textAlignment = NSTextAlignmentCenter;
                
                [tempArr addObject:labelOne];
            }
            
            LSMarqueeView *marqueeView = [[LSMarqueeView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 60) andLableArr:tempArr];
            marqueeView.top = sizeScale(30) + 25;
            [viewPopAd addSubview:marqueeView];
            [marqueeView  startCountdown];
            
            imageViewNoolde.top = marqueeView.bottom - 50;
            
        }
    }];
}



+ (void)adClick:(UIButton*)btn{
    if(btn.tag == 90){ //抽奖
        
        UIView *viewPopAd = [btn superview];
        UIImageView *imageViewNoolde = [viewPopAd viewWithTag:81];
        if(imageViewNoolde){
            [imageViewNoolde startAnimating];
        }
        
        
        NetWork_mt_luckdraw *request = [[NetWork_mt_luckdraw alloc] init];
        [request startGetWithBlock:^(LuckdrawResponse *result, NSString *msg, BOOL finished) {
            if(finished){
                //[UIWindow showTips:result.obj];
                
                [GlobalFunc showAlertWithTitle:@"温馨提示" message:result.obj makeSure:^{
                    if(viewPopAd){
                        [viewPopAd removeFromSuperview];
                    }
                }];
                
                //[self performSelector:@selector(loadTableBar) withObject:nil/*可传任意类型参数*/ afterDelay:4.0];
            }
        }];
        
        
        
        //开始动画
        //        [self.imageViewNoolde startAnimating];
        //        [self luckDrawRequest];
        
    }
    else if(btn.tag == 91){//跳过
        
        UIView *viewPopAd = [btn superview];
        if(viewPopAd){
            [viewPopAd removeFromSuperview];
            viewPopAd = nil;
        }
    }
}


@end
