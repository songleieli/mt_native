//
//  GlobalFunc.m
//  ChinaDream
//
//  Created by zhangfeng on 12-11-26.
//  Copyright (c) 2012年 eastedge. All rights reserved.
//

#import "GlobalFunc.h"
#import "sys/utsname.h"
#import "Reachability.h"
#import "GlobalData.h"

static GlobalFunc *sharedInstance;

@implementation GlobalFunc

+ (GlobalFunc *)sharedInstance{
    //static JRGlobalSingleton *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (WCPlistHelper *)plistHelper{
    if (!_plistHelper){
        _plistHelper = [[WCPlistHelper alloc] initWithPlistNamed:@"onbConfiguration"];
    }
    return _plistHelper;
}

- (WCOnbConfiguration *)gWCOnbConfiguration{
    if (!_gWCOnbConfiguration){
        //        WCPlistHelper *plistHelper = [[WCPlistHelper alloc] initWithPlistNamed:@"onbConfiguration"];
        _gWCOnbConfiguration = [[WCOnbConfiguration alloc] initWithDictionary:self.plistHelper.allProperties];
    }
    return _gWCOnbConfiguration;
}

- (UIImagePickerController *)camare{
    if (!_camare){
        _camare = [[UIImagePickerController alloc] init];
        _camare.delegate = self;
    }
    return _camare;
}

-(void)saveConfiguration{
    //[_configuration ]
    
    [self.plistHelper saveplistWithPath:[_gWCOnbConfiguration generateJsonDict]];
}

-(void)takePhoto:(id)handel{
    
    if(self.delegate){
        self.delegate = nil;
    }
    self.delegate = handel;
    
    /*
     拍照
     */
    if ([UIImagePickerController  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [GlobalFunc sharedInstance].camare.sourceType = UIImagePickerControllerSourceTypeCamera;
        [GlobalFunc sharedInstance].camare.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [GlobalFunc sharedInstance].camare.delegate = self;
        [GlobalFunc sharedInstance].camare.allowsEditing = YES;
        [GlobalFunc sharedInstance].camare.showsCameraControls = YES;
        
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:[GlobalFunc sharedInstance].camare
                                                                                           animated:YES completion:nil];    }
    
}
-(void)localPhoto:(id)handel{
    
    if(self.delegate){
        self.delegate = nil;
    }
    self.delegate = handel;
    
    /*
     从相册选择
     */
    
    [GlobalFunc sharedInstance].camare.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [GlobalFunc sharedInstance].camare.allowsEditing = YES; //设置选择后的图片可被编辑
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:[GlobalFunc sharedInstance].camare
                                                                                       animated:YES completion:nil];
}


+ (UIImage*) createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
+ (UIColor*) colorFromImage: (UIImage*) image{
    return [UIColor colorWithPatternImage:image];
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

#pragma mark - 比较版本号大小
+ (BOOL)moreThanVersion:(NSString *)version
{
    NSString *currentVersoion = [AppVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *compareVersoion = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSComparisonResult result = [compareVersoion compare:currentVersoion options:NSLiteralSearch];
    
    if (result == NSOrderedDescending) { //大于
        return YES;
    }
    
    return NO;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size
{
    NSAttributedString * attributeString = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    CGRect rect =[attributeString boundingRectWithSize:size  options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    attributeString = nil;
    
    return rect.size;
}


#pragma -mark 压缩图片


/*
 *宽高按照比例缩放
 */
+ (UIImage *) scaleToSizeAlpha:(UIImage *)img alpha:(float)alpha{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    CGSize targetSize = CGSizeMake(img.size.width*alpha,  img.size.height*alpha);
    UIGraphicsBeginImageContext(targetSize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/*
 *宽不变，高等比例变化
 */
+ (UIImage *) scaleToSizeAlpha:(UIImage *)img fixedWith:(float)fixedWith{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    CGSize targetSize = CGSizeMake(fixedWith, fixedWith*(img.size.height/img.size.width));
    UIGraphicsBeginImageContext(targetSize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/*
 *宽不变，高等比例变化
 */
+ (UIImage *) scaleToSizeAlpha:(UIImage *)img fixedHeight:(float)fixedHeight{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    CGSize targetSize = CGSizeMake( fixedHeight*(img.size.width/img.size.height),fixedHeight);
    UIGraphicsBeginImageContext(targetSize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


+(NSString*)getCurrentTime{
    
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    [dateFormatter setTimeZone:localzone];
    
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    //    NSLog(@"dateString:%@",dateString);
    
    return dateString;
}

+(NSString*)getCurrentTimeWithFormatter:(NSString*)formattter{
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formattter];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    //    NSLog(@"dateString:%@",dateString);
    
    return dateString;
}

+(NSString*) getTimeWithFormatter:(NSDate*)date  formattter:(NSString*)formattter{
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formattter];
    [dateFormatter setTimeZone:localzone];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+(NSDate*) getDateWithTimeStr:(NSString*)timestr{
    
    NSTimeZone* localzone = [NSTimeZone localTimeZone]; //本地时区
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:localzone];
    
    return [dateFormatter dateFromString:timestr];
}

+(void)afterTime:(float)time todo:(VoidBlock)block{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        block();
    });
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info{
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    [images addObject:image];
    if([self.delegate respondsToSelector:@selector(selectedImages:)]){
        [self.delegate selectedImages:images];
    }
    [picker dismissViewControllerAnimated:NO completion:^{}];
}
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInf{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//随机色
+(UIColor *)randomColor {
    //    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    //    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    //    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    //
    //    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    CGFloat red = ( arc4random() % 256 );  //  0.0 to 255
    CGFloat green = ( arc4random() % 256 );  //  0.0 to 255
    CGFloat blue = ( arc4random() % 256 );  //  0.0 to 255
    
    return  RGBAlphaColor(red, green, blue, 1);
}


/**
 改变UILabel部分字符颜色
 */
+ (void)setContentLabelColor:(NSString *)content
                      subStr:(NSString *)subStr
                    subColor:(UIColor*)subColor
                contentLabel:(UILabel*)contentLabel{
    
    
    NSMutableArray *locationArr = [GlobalFunc calculateSubStringCount:content str:subStr];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:content];
    for (int i=0; i<locationArr.count; i++) {
        NSNumber *location = locationArr[i];
        [attstr addAttribute:NSForegroundColorAttributeName value:subColor range:NSMakeRange(location.integerValue, subStr.length)];//改变\n前边的10位字符颜色，
    }
    contentLabel.attributedText = attstr;
}

/**
 查找子字符串在父字符串中的所有位置
 @param content 父字符串
 @param tab 子字符串
 @return 返回位置数组
 */
+ (NSMutableArray*)calculateSubStringCount:(NSString *)content str:(NSString *)tab {
    
    int location = 0;
    NSMutableArray *locationArr = [NSMutableArray new];
    NSRange range = [content rangeOfString:tab];
    if (range.location == NSNotFound){
        return locationArr;
    }
    //声明一个临时字符串,记录截取之后的字符串
    NSString * subStr = content;
    while (range.location != NSNotFound) {
        if (location == 0) {
            location += range.location;
        } else {
            location += range.location + tab.length;
        }
        //记录位置
        NSNumber *number = [NSNumber numberWithUnsignedInteger:location];
        [locationArr addObject:number];
        //每次记录之后,把找到的字串截取掉
        subStr = [subStr substringFromIndex:range.location + range.length];
        NSLog(@"subStr %@",subStr);
        range = [subStr rangeOfString:tab];
        NSLog(@"rang %@",NSStringFromRange(range));
    }
    return locationArr;
}

//判断文件是否已经在沙盒中已经存在？
+ (BOOL) isFileExist:(NSString *)fileName{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
    //    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    ;
}


/*
 *全局等待框
 */
+ (void)createHUD{  //alloc一个等待控件出来
    
    if (![GlobalFunc sharedInstance].hub){
        
        UIWindow *window =  [UIApplication sharedApplication].delegate.window;
        [GlobalFunc sharedInstance].hub = [MBProgressHUD showHUDAddedTo:window animated:YES];
        [GlobalFunc sharedInstance].hub.mode = MBProgressHUDModeText;
        [GlobalFunc sharedInstance].hub.label.text = @"加载中...";
    }
}

+ (void)showHud:(NSString*)msg{
    
    [GlobalFunc createHUD];
    [GlobalFunc sharedInstance].hub.label.text = msg;
}

+(void)hideHUD{
    
    if([GlobalFunc sharedInstance].hub){
        [[GlobalFunc sharedInstance].hub hideAnimated:YES];
        [GlobalFunc sharedInstance].hub = nil;
    }
}

+(void)hideHUD:(NSTimeInterval)delay{
    
    if([GlobalFunc sharedInstance].hub){
        [[GlobalFunc sharedInstance].hub hideAnimated:YES afterDelay:delay];
        [[GlobalFunc sharedInstance] performSelector:@selector(delayMethod) withObject:nil afterDelay:delay];
    }
}

- (void)delayMethod {
    NSLog(@"delayMethodEnd");
    [GlobalFunc sharedInstance].hub = nil;
}


#pragma mark 显示信息
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message makeSure:(VoidBlock)sure{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                          if(sure){
                                                              sure();
                                                          }
                                                      }]];
    
    
    UIViewController *topRootViewController = [[UIApplication  sharedApplication] keyWindow].rootViewController;
    
    // 在这里加一个这个样式的循环
    while (topRootViewController.presentedViewController){
        // 这里固定写法
        topRootViewController = topRootViewController.presentedViewController;
    }
    
    [topRootViewController presentViewController:alertController animated:YES completion:^{
        
    }];
    
}


+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message makeSure:(VoidBlock)sure cancel:(VoidBlock)cancel{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                          if(cancel){
                                                              cancel();
                                                          }
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                          if(sure){
                                                              sure();
                                                          }
                                                      }]];
    
    
    UIViewController *topRootViewController = [[UIApplication  sharedApplication] keyWindow].rootViewController;
    
    // 在这里加一个这个样式的循环
    while (topRootViewController.presentedViewController){
        // 这里固定写法
        topRootViewController = topRootViewController.presentedViewController;
    }
    
    [topRootViewController presentViewController:alertController animated:YES completion:^{
        
    }];
}

+ (void)showActionSheetWithTitle:(NSArray  *)sheets  Action:(IntegerBlock)actionAt {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleView.backgroundColor = [UIColor redColor];
    
    CZActionSheetView *actionSheet = [[CZActionSheetView alloc] initWithTitleView:titleView optionsArr:sheets cancelTitle:@"取消" selectedBlock:^(NSInteger index) {
        NSLog(@"select----%zd",index);
        actionAt(index);
    } cancelBlock:^{
        NSLog(@"cancel");
    }];
    [actionSheet show];
    
}




@end

