//
//  GlobalFunc.h
//  ChinaDream
//
//  Created by zhangfeng on 12-11-26.
//  Copyright (c) 2012年 eastedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CZActionSheetView.h"

typedef void(^VoidBlock)(void);

typedef void(^IntegerBlock)(NSInteger index);

@protocol ChoosePictureDelegate <NSObject>

@optional

- (void)selectedImages:(NSArray*)images;

@end



@interface GlobalFunc : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

+ (GlobalFunc *)sharedInstance;


@property (nonatomic, strong) WCOnbConfiguration *gWCOnbConfiguration;
@property (nonatomic, strong) WCPlistHelper *plistHelper;

@property (nonatomic,strong) UIImagePickerController *camare;
@property(nonatomic, weak) id <ChoosePictureDelegate> delegate;

@property (nonatomic, strong) MBProgressHUD     *hub;//等待控件

-(void)takePhoto:(id)handel;
-(void)localPhoto:(id)handel;


+ (UIImage*) createImageWithColor: (UIColor*) color;
+ (UIColor*) colorFromImage: (UIImage*) image;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString*)format;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size;

/*
 *等比例缩放图片
 */
+ (UIImage *) scaleToSizeAlpha:(UIImage *)img alpha:(float)alpha;
+ (UIImage *) scaleToSizeAlpha:(UIImage *)img fixedWith:(float)fixedWith;
+ (UIImage *) scaleToSizeAlpha:(UIImage *)img fixedHeight:(float)fixedHeight;

+(NSString*) getCurrentTime;
+(NSString*) getCurrentTimeWithFormatter:(NSString*)formattter;
+(NSString*) getTimeWithFormatter:(NSDate*)date  formattter:(NSString*)formattter;

+(NSDate*) getDateWithTimeStr:(NSString*)timestr;


//随机色
+(UIColor *)randomColor;


/**
 替换lable中subStr的颜色
 @param content 父字符串
 @param subStr 子字符串
 @param subColor 子字符串颜色
 @param contentLabel 要替换的lable
 */
+ (void)setContentLabelColor:(NSString *)content
                      subStr:(NSString *)subStr
                    subColor:(UIColor*)subColor
                contentLabel:(UILabel*)contentLabel;

/**
 查找子字符串在父字符串中的所有位置
 @param content 父字符串
 @param tab 子字符串
 @return 返回位置数组
 */
+ (NSMutableArray*)calculateSubStringCount:(NSString *)content str:(NSString *)tab;

//判断文件是否已经在沙盒中已经存在？
+ (BOOL) isFileExist:(NSString *)fileName;

/*
 *全局等待框
 */
+ (void)showHud:(NSString*)msg;

+ (void)hideHUD;

+ (void)hideHUD:(NSTimeInterval)delay;

#pragma mark 显示信息

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message makeSure:(VoidBlock)sure;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message makeSure:(VoidBlock)sure cancel:(VoidBlock)cancel;

+ (void)showActionSheetWithTitle:(NSArray  *)sheets  Action:(IntegerBlock)actionAt;

@end



