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

@protocol ChoosePictureDelegate <NSObject>

@optional

- (void)selectedImages:(NSArray*)images;

@end

@interface GlobalFunc : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

+ (GlobalFunc *)sharedInstance;

/*
 * JRGlobalSingleton 移植过来的代码
 */

@property (nonatomic, strong) WCOnbConfiguration *gWCOnbConfiguration;
@property (nonatomic, strong) WCPlistHelper *plistHelper;

@property (nonatomic,strong) UIImagePickerController *camare;
@property(nonatomic, weak) id <ChoosePictureDelegate> delegate;

@property (nonatomic, strong) MBProgressHUD     *hub;//等待控件




-(void)takePhoto:(id)handel;
-(void)localPhoto:(id)handel;


+ (UIImage*) createImageWithColor: (UIColor*) color;
+ (UIColor*) colorFromImage: (UIImage*) image;
+ (NSString *) changeUIColorToRGB:(UIColor *)color;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString*)format;

//路径
+ (NSString *)pathWithFile:(NSString *)file;
+ (BOOL)existsFile:(NSString *)file; //是否存在文件
+ (BOOL)deleteFile:(NSString *)file; //删除文件
+ (BOOL)writeArrToFile:(NSArray *)arr fileName:(NSString *)file; //把数组写入文件
+ (BOOL)writeDicToFile:(NSDictionary *)dic fileName:(NSString *)file; //把字典写入文件
+ (NSArray *)parseArrFromFile:(NSString *)file; //解析文件得到数组
+ (NSDictionary *)parseDicFromFile:(NSString *)file; //解析文件得到字典
+ (BOOL)writerData:(NSData *)data toFile:(NSString *)file;//存储数据
+ (NSData *)readDataWithFile:(NSString *)file; //读取数据

#pragma mark 获取UUID
+ (NSString*) getUUID;

#pragma mark - 获取指定长度的纯数字随机码
+ (NSString *)getNumbersWithIndex:(NSInteger)index;

#pragma mark - 转化NSDate为字符串
+ (NSString *)encodeDate:(NSDate *)date;

#pragma mark - 转化NSDate为字符串 （自定义格式）
+ (NSString *)encodeDate:(NSDate *)date withFormatterString:(NSString *)fromatter;
+ (NSString *)encodeDate1970:(double)time withFormatterString:(NSString *)formatter;
+ (NSDate *)dateWithStr:(NSString *)dateStr formatterString:(NSString *)fromatter;
+ (NSString *)weekWithDate:(NSDate *)date;
+ (NSString *)weekWithDate1970:(CGFloat)time;

#pragma mark - 检查是否为字符串
+ (BOOL)checkObject:(NSString *)str;

//自定义默认字体
+ (UIFont *)defaultFontWithSize:(CGFloat)size;
+ (UIFont *)defaultBoldFontWithSize:(CGFloat)size;

//16进制字符串 转换为int
+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

+ (UIColor *)transformWithHexString:(NSString *)hexString;

#pragma mark 显示信息
+ (void)showAlertWithMessage:(NSString *)msg;

#pragma mark - 检测网络
+ (NSInteger)checkNetWork;

#pragma mark - 验证价格 double
+ (NSString *)checkPrice:(double)price;
+ (NSString *)standerPrice:(double)price;
+ (NSString *)standerStrPrice:(NSString *)price;
+ (NSString *)unstanderStrPrice:(NSString *)price;
+ (NSString *)standerValue:(NSString *)value;

#pragma mark - 检测URL
+ (NSURL *)urlWithStr:(NSString *)str;

#pragma mark - 检测是否开启推送
+ (BOOL)enabledRemoteNotification;

#pragma mark - 比较版本号大小
+ (BOOL)moreThanVersion:(NSString *)version;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size;

#pragma mark - 倒计时
+ (NSString *)detailTimer:(NSString *)minut byIndex:(NSInteger)index;
+ (NSString *)detailSignTimer:(NSString *)minut byIndex:(NSInteger)index;
+ (NSString *)compareDate:(NSString *)dateStr day:(BOOL)day;

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
 倒计时

 @param time 时间
 @param countDownBlock 倒计时阶段执行
 @param endBlock 结束后执行
 */
+ (void)countDownWithTime:(int)time
           countDownBlock:(void (^)(int timeLeft))countDownBlock
                 endBlock:(void (^)())endBlock;

+ (BOOL)isSimulator;

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

@end



