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

+ (UIColor *)transformWithHexString:(NSString *)hexString
{
    if (hexString) {
        NSMutableString * hexStringMutable = [NSMutableString stringWithString:hexString];
        [hexStringMutable replaceCharactersInRange:[hexStringMutable rangeOfString:@"#" ] withString:@"0x"];
        // 十六进制字符串转成整形。
        long colorLong = strtoul([hexStringMutable cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
        // 通过位与方法获取三色值
        int R = (colorLong & 0xFF0000 )>>16;
        int G = (colorLong & 0x00FF00 )>>8;
        int B =  colorLong & 0x0000FF;
        
        //string转color
        return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    }
    return [[UIColor alloc] init];
    
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//颜色转字符串
+ (NSString *) changeUIColorToRGB:(UIColor *)color{
    
    
    const CGFloat *cs=CGColorGetComponents(color.CGColor);
    
    
    NSString *r = [NSString stringWithFormat:@"%@",[self  ToHex:cs[0]*255]];
    NSString *g = [NSString stringWithFormat:@"%@",[self  ToHex:cs[1]*255]];
    NSString *b = [NSString stringWithFormat:@"%@",[self  ToHex:cs[2]*255]];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
    
    
}


//十进制转十六进制
+ (NSString *)ToHex:(int)tmpid
{
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}





#pragma mark -
#pragma mark 文件的读写
//路径
+ (NSString *)pathWithFile:(NSString *)file
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSString *filename = [path stringByAppendingPathComponent:file];
    path = nil;
    
    return filename;
}

//是否存在文件
+ (BOOL)existsFile:(NSString *)file
{
    NSString *filename = [self pathWithFile:file];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filename];
    filename = nil;
    
    return isExist;
}

//删除文件
+ (BOOL)deleteFile:(NSString *)file
{
    NSString *filename = [self pathWithFile:file];
    BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
    filename = nil;
    
    return remove;
}

//把数组写入文件
+ (BOOL)writeArrToFile:(NSArray *)arr fileName:(NSString *)file
{
    BOOL finish = NO;
    @autoreleasepool {
        NSString *filename = [self pathWithFile:file];
        finish = [arr writeToFile:filename  atomically:YES];
        filename = nil;
    }
    
    return finish;
}

//把字典写入文件
+ (BOOL)writeDicToFile:(NSDictionary *)dic fileName:(NSString *)file
{
    BOOL finish = NO;
    @autoreleasepool {
        NSString *filename = [self pathWithFile:file];
        finish = [dic writeToFile:filename  atomically:YES];
        filename = nil;
    }
    
    return finish;
}

//解析文件得到数组
+ (NSArray *)parseArrFromFile:(NSString *)file
{
    NSString *filename = [self pathWithFile:file];
    NSMutableArray *array=[[NSMutableArray alloc] initWithContentsOfFile:filename];
    filename = nil;
    
    return array;
}

//解析文件得到字典
+ (NSDictionary *)parseDicFromFile:(NSString *)file
{
    //	读操作
    NSString *filename = [self pathWithFile:file];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    filename = nil;
    
    return dic;
}

//存储数据
+ (BOOL)writerData:(NSData *)data toFile:(NSString *)file
{
    NSString *filename = [self pathWithFile:file];
    
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
    //        [[NSFileManager defaultManager] removeItemAtPath:filename error:NULL];
    //    }
    
    BOOL isFinished = [[NSFileManager defaultManager] createFileAtPath:filename contents:data attributes:nil];
    filename = nil;
    
    return isFinished;
}

//读取数据
+ (NSData *)readDataWithFile:(NSString *)file
{
    NSString *filename = [self pathWithFile:file];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    filename = nil;
    
    return data;
}

#pragma mark 获取UUID
+ (NSString*) getUUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    
    return result;
}

#pragma mark - 获取指定长度的纯数字随机码
+ (NSString *)getNumbersWithIndex:(NSInteger)index
{
    NSString *str = @"";
    
    for (int i = 0; i < index; ++i) {
        @autoreleasepool {
            NSInteger code = arc4random()%10;
            str = [str stringByAppendingFormat:@"%ld",(long)code];
        }
    }
    
    return str;
}

#pragma mark - 转化NSDate为字符串
+ (NSString *)encodeDate:(NSDate *)date
{
    return [GlobalFunc encodeDate:date withFormatterString:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark - 转化NSDate为字符串 （自定义格式）
+ (NSString *)encodeDate:(NSDate *)date withFormatterString:(NSString *)formatter
{
    NSDateFormatter *tmpFormatter = [[NSDateFormatter alloc] init];
    [tmpFormatter setDateFormat:formatter];
    
    return [tmpFormatter stringFromDate:date];
}

+ (NSString *)encodeDate1970:(double)time withFormatterString:(NSString *)formatter
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    return [self encodeDate:date withFormatterString:formatter];
}

+ (NSDate *)dateWithStr:(NSString *)dateStr formatterString:(NSString *)fromatter
{
    NSDateFormatter *tmpFormatter = [[NSDateFormatter alloc] init];
    [tmpFormatter setDateFormat:fromatter];
    
    return [tmpFormatter dateFromString:dateStr];
}

+ (NSString *)weekWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    //int week=0;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSLog(@"week int:%d",(int)week);
    
    NSArray *arrWeek = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    if(week > 0 && week <= arrWeek.count){
        return [arrWeek objectAtIndex:week-1];
    }
    else{
        return @"";
    }
    
    //return arrWeek[week];
}

+ (NSString *)weekWithDate1970:(CGFloat)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    return [self weekWithDate:date];
}

#pragma mark - 检查是否为字符串
+ (BOOL)checkObject:(NSString *)str
{
    if (str == nil || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@"(null)"] || [str isEqualToString:@"（null）"]) {
        return NO;
    }
    
    return YES;
}

//自定义默认字体
+ (UIFont *)defaultFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+ (UIFont *)defaultBoldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

//16进制字符串 转换为int
+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha
{
    if (hex.length < 7) {
        return nil;
    }
    
    unsigned color = 0;
    NSScanner *hexValueScanner = [NSScanner scannerWithString:[hex substringFromIndex:1]];
    [hexValueScanner scanHexInt:&color];
    
    int blue = color & 0xFF;
    int green = (color >> 8) & 0xFF;
    int red = (color >> 16) & 0xFF;
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

#pragma mark 显示信息
+ (void)showAlertWithMessage:(NSString *)msg
{
    UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alertMsg show];
}

#pragma mark - 检测网络
+ (NSInteger)checkNetWork
{
    NSInteger state = 0;//默认 无网络
    Reachability *r=[Reachability reachabilityForInternetConnection];
    switch ([r currentReachabilityStatus]) {
        case NotReachable: // 没有网络连接 netstate=@"没有网络";
            state = 0;
            //NSLog(@"无网络");
            break;
        case ReachableViaWWAN:{ // 使用3G网络
            state = 1;
            //NSLog(@"3G");
        }
            break;
        case ReachableViaWiFi:{ // 使用WiFi网络
            state = 2;
            //NSLog(@"wifi");
        }
            break;
    }
    
    return state;
}

#pragma mark - 验证价格 double
+ (NSString *)checkPrice:(double)price
{
    if (price == (int)price) {
        return [NSString stringWithFormat:@"%.0f",price];
    }
    
    NSString *price1 = [NSString stringWithFormat:@"%.1f",price];
    NSString *price2 = [NSString stringWithFormat:@"%.2f",price];
    if (price1.doubleValue == price2.doubleValue) {
        return price1;
    }
    
    return price2;
}

+ (NSString *)standerPrice:(double)price
{
    NSString *result = [GlobalFunc standerStrPrice:[GlobalFunc checkPrice:price]];
    
    return result;
}

+ (NSString *)standerStrPrice:(NSString *)price
{
    if (price == nil || ![price isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString *pref = price;
    NSRange range = [price rangeOfString:@"."];
    if (range.length) {
        pref = [pref substringToIndex:range.location];
    }
    
    NSInteger length = pref.length;
    while (length > 3) {
        length -= 3;
        pref = [pref stringByReplacingCharactersInRange:NSMakeRange(length, 0) withString:@","];
    }
    
    NSString *result = pref;
    if (range.length) {
        result = [pref stringByAppendingString:[price substringFromIndex:range.location]];
    }
    
    return result;
}

+ (NSString *)unstanderStrPrice:(NSString *)price
{
    if (price == nil || ![price isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString *result = [price stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    return result;
}

+ (NSString *)standerValue:(NSString *)value
{
    if ([value isKindOfClass:[NSString class]] && [value hasSuffix:@"."]) {
        return [value substringToIndex:value.length-1];
    }
    return value;
}

#pragma mark - 检测URL
+ (NSURL *)urlWithStr:(NSString *)str
{
    //NSLog(@"str:%@",str);
    if ([str isKindOfClass:[NSString class]]) {
        return [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return nil;
}

#pragma mark - 检测是否开启推送
+ (BOOL)enabledRemoteNotification
{
    //iOS8 check if user allow notification
    if (IOS8_OR_LATER) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    
    return NO;
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

#pragma mark - 倒计时
+ (NSString *)detailTimer:(NSString *)minut byIndex:(NSInteger)index
{
    // 0:天 1:时 2:分 3:秒 4:总小时
    NSInteger day = 0;
    long long hour = 0;
    long long minutes = 0;
    long long secondes = 0;
    if (minut.intValue > 0) {
        day = minut.integerValue/(24*60*60);
        hour = (minut.longLongValue/(60*60))%24;
        minutes = minut.longLongValue/60-(day*24*60)-(hour*60);
        secondes = minut.longLongValue%60;
    }
    
    NSString *returnStr = nil;
    switch (index) {
        case 0: { //天
            if (day < 10) {
                returnStr = [NSString stringWithFormat:@"0%ld",(long)day];
            } else {
                returnStr = [NSString stringWithFormat:@"%ld",(long)day];
            }
        }
            break;
        case 1: { //时
            if (hour < 10) {
                returnStr = [NSString stringWithFormat:@"0%lld",hour];
            } else {
                returnStr = [NSString stringWithFormat:@"%lld",hour];
            }
        }
            break;
        case 2: { //分
            if (minutes < 10) {
                returnStr = [NSString stringWithFormat:@"0%lld",minutes];
            } else {
                returnStr = [NSString stringWithFormat:@"%lld",minutes];
            }
        }
            break;
        case 3: { //秒
            if (secondes < 10) {
                returnStr = [NSString stringWithFormat:@"0%lld",secondes];
            } else {
                returnStr = [NSString stringWithFormat:@"%lld",secondes];
            }
        }
            break;
        case 4: { //总小时
            if (day*24+hour < 10) {
                returnStr = [NSString stringWithFormat:@"0%lld",day*24+hour];
            } else {
                returnStr = [NSString stringWithFormat:@"%lld",day*24+hour];
            }
        }
            break;
        default:
            break;
    }
    
    return returnStr;
}

+ (NSString *)detailSignTimer:(NSString *)minut byIndex:(NSInteger)index
{
    // 0:天 1:时 2:分 3:秒 4:总小时
    NSInteger day = 0;
    long long hour = 0;
    long long minutes = 0;
    long long secondes = 0;
    if (minut.intValue > 0) {
        day = minut.integerValue/(24*60*60);
        hour = (minut.longLongValue/(60*60))%24;
        minutes = minut.longLongValue/60-(day*24*60)-(hour*60);
        secondes = minut.longLongValue%60;
    }
    
    NSString *returnStr = nil;
    switch (index) {
        case 0: { //天
            returnStr = [NSString stringWithFormat:@"%ld",(long)day];
        }
            break;
        case 1: { //时
            returnStr = [NSString stringWithFormat:@"%lld",hour];
        }
            break;
        case 2: { //分
            returnStr = [NSString stringWithFormat:@"%lld",minutes];
        }
            break;
        case 3: { //秒
            returnStr = [NSString stringWithFormat:@"%lld",secondes];
        }
            break;
        case 4: { //总小时
            returnStr = [NSString stringWithFormat:@"%lld",day*24+hour];
        }
            break;
        default:
            break;
    }
    
    return returnStr;
}

+ (NSString *)compareDate:(NSString *)dateStr day:(BOOL)day
{
    //2015-09-28 13:55
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dateCurrent =[format dateFromString:dateStr];
    
    if (day) {
        NSDate *today = [NSDate date];
        NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
        
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString *strCurrent = [format stringFromDate:dateCurrent];
        NSString *strToday = [format stringFromDate:today];
        NSString *strTomorrow = [format stringFromDate:tomorrow];
        
        if ([strCurrent isEqualToString:strToday]) {
            return @"今天";
        } else if ([strCurrent isEqualToString:strTomorrow]) {
            return @"明天";
        } else {
            [format setDateFormat:@"M月d日"];
            NSString *result = [format stringFromDate:dateCurrent];
            return result;
        }
    } else {
        [format setDateFormat:@"H:mm"];
        NSString *result = [format stringFromDate:dateCurrent];
        return result;
    }
    
    return nil;
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


+ (void)countDownWithTime:(int)time
           countDownBlock:(void (^)(int timeLeft))countDownBlock
                 endBlock:(void (^)())endBlock
{
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (endBlock) {
                    endBlock();
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (countDownBlock) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    countDownBlock(timeout);
                    [UIView commitAnimations];
                }
                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
}

+ (BOOL)isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
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


+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message makeSure:(VoidBlock)sure cancel:(VoidBlock)cancel{
    //    NSString *str = @"";
    //    if (title.length > 0) {
    //        str = title;
    //
    //        if (message.length > 0) {
    //            str = [NSString stringWithFormat:@"%@\n%@",title,message];
    //        }
    //    }else{
    //        str = message;
    //    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          cancel();
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          sure();
                                                      }]];
    UIViewController *topRootViewController = [[UIApplication  sharedApplication] keyWindow].rootViewController;
    
    // 在这里加一个这个样式的循环
    while (topRootViewController.presentedViewController)
    {
        // 这里固定写法
        topRootViewController = topRootViewController.presentedViewController;
    }
    
    [topRootViewController presentViewController:alertController animated:YES completion:^{
        
    }];
    //    [[AppDelegate shareAppDelegate].tabbarController.selectedViewController presentViewController:alertController animated:YES completion:^{
    //
    //    }];
}





@end

