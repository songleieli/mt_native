//
//  DeliverArticleViewController.m
//  CMPLjhMobile
//
//  Created by 刘欣 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "PublishViewController.h"

#import "NetWork_mt_getUploadSignature.h"
#import "NetWork_mt_saveVideo.h"

#import "TXUGCPublish.h"

@interface PublishViewController ()<TXVideoPublishListener>{
    CLLocationManager *locationmanager;//定位服务
}

@end

@implementation PublishViewController

#pragma mark ------------- 懒加载  ----------

/*
 *话题数组
 */
- (NSMutableArray *)topicArray {
    if (!_topicArray) {
        _topicArray = [[NSMutableArray alloc] init];
    }
    return _topicArray;
}

/*
 *At好友数组
 */
- (NSMutableArray *)atArray {
    if (!_atArray) {
        _atArray = [[NSMutableArray alloc] init];
    }
    return _atArray;
}

/*
 *话题和At好友数组
 */
- (NSMutableArray *)atAndTopicArray {
    if (!_atAndTopicArray) {
        _atAndTopicArray = [[NSMutableArray alloc] init];
    }
    return _atAndTopicArray;
}



- (UITextView *) speakTextView{
    
    if (_speakTextView == nil){
        
        CGFloat textViewHeight = sizeScale(125);
        CGFloat videoWidth = textViewHeight/1.35f;
        
        _speakTextView = [[UITextView alloc] init];
        _speakTextView.backgroundColor = ColorThemeBackground; //ColorThemeBackground;
        _speakTextView.frame = CGRectMake(10, 0,self.scrollView.width-videoWidth - 30, sizeScale(125));
        _speakTextView.delegate = self;
        _speakTextView.textColor = ColorWhite;
        _speakTextView.returnKeyType = UIReturnKeyDone;
//        _speakTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _speakTextView.font = [UIFont systemFontOfSize:16.0];
        [_speakTextView becomeFirstResponder];
    }
    
    return _speakTextView;
}

- (UILabel *) placeHoldelLebel{
    
    if (_placeHoldelLebel == nil){
        
        _placeHoldelLebel = [[UILabel alloc]init];
        _placeHoldelLebel.frame = [UIView getScaleFrame_x:10 y:0 width:100 height:30];
        _placeHoldelLebel.text = @"这一刻我想说......";
        _placeHoldelLebel.textColor = ColorWhiteAlpha60;
        _placeHoldelLebel.font = [UIFont systemFontOfSize:16.0];
    }
    
    return _placeHoldelLebel;
}

- (UIImageView*)imageViewCover{
    
    if (!_imageViewCover) {
        
        CGFloat textViewHeight = sizeScale(125)-30;
        CGFloat videoWidth = textViewHeight/1.35f;
        
        
        _imageViewCover = [[UIImageView alloc] init];
        _imageViewCover.size = [UIView getSize_width:videoWidth height:textViewHeight];
        _imageViewCover.left = self.speakTextView.right + 10;
        _imageViewCover.top = 15;
        _imageViewCover.backgroundColor = RGBA(54, 58, 67, 1);
        _imageViewCover.userInteractionEnabled  =   YES;
        _imageViewCover.layer.cornerRadius = 5;
        _imageViewCover.layer.masksToBounds = YES;
        _imageViewCover.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _imageViewCover;
}

- (UIButton*)btnTopic{
    
    if (!_btnTopic) {
        _btnTopic = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTopic.size = [UIView getSize_width:60 height:25];
        _btnTopic.origin = [UIView getPoint_x:sizeScale(15) y:self.speakTextView.bottom];
        [_btnTopic setBackgroundColor:MTColorBtnNormal forState:UIControlStateNormal];
        [_btnTopic setBackgroundColor:MTColorBtnHighlighted forState:UIControlStateHighlighted];
        _btnTopic.titleLabel.font = MediumFont;
        [_btnTopic setTitle:@"#话题" forState:UIControlStateNormal];
        _btnTopic.layer.cornerRadius = 2.0f;
        [_btnTopic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnTopic.layer.masksToBounds = true;//给按钮添加边框效果
        [_btnTopic addTarget:self action:@selector(btnAddTopic:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnTopic;
}

- (UIButton*)btnAFriend{
    
    if (!_btnAFriend) {
        _btnAFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAFriend.size = [UIView getSize_width:60 height:25];
        _btnAFriend.origin = [UIView getPoint_x:self.btnTopic.right+sizeScale(15) y:self.speakTextView.bottom];
        [_btnAFriend setBackgroundColor:MTColorBtnNormal forState:UIControlStateNormal];
        [_btnAFriend setBackgroundColor:MTColorBtnHighlighted forState:UIControlStateHighlighted];
        _btnAFriend.titleLabel.font = MediumFont;
        [_btnAFriend setTitle:@"@好友" forState:UIControlStateNormal];
        [_btnAFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnAFriend.layer.cornerRadius = 2.0f;
        _btnAFriend.layer.masksToBounds = true;//给按钮添加边框效果
        [_btnAFriend addTarget:self action:@selector(btnAFriend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAFriend;
}

- (TCBGMProgressView *) progressView{
    
    if (_progressView == nil){
        
        CGRect frame = CGRectMake(self.speakTextView.left, self.btnTopic.bottom + 5, self.scrollView.width, 3.0f);
        
        _progressView = [[TCBGMProgressView alloc] initWithFrame:frame];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.progressBackgroundColor = [UIColor yellowColor];
        _progressView.hidden = YES;
    }
    
    return _progressView;
}

- (UIView*)viewLine{
    
    if (!_viewLine) {
        _viewLine = [[UIView alloc] init];
        _viewLine.left = 0;
        _viewLine.size = [UIView getSize_width:ScreenWidth height:0.4];
        _viewLine.bottom = self.progressView.bottom + sizeScale(10);
        _viewLine.backgroundColor = MTColorLine;
    }
    return _viewLine;
}


- (UIButton *)btnLocation{
    
    if (!_btnLocation) {
        
        _btnLocation =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLocation setBackgroundColor:ColorThemeBackground forState:UIControlStateNormal];
        [_btnLocation setBackgroundColor:MTColorBtnNormal forState:UIControlStateHighlighted];
        _btnLocation.size = [UIView getSize_width:ScreenWidth height:sizeScale(40)];
        _btnLocation.top = self.viewLine.bottom;
        [_btnLocation addTarget:self action:@selector(btnAddLocation:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_m_location"]];
        imgView.size = [UIView getScaleSize_width:14 height:14];
        imgView.origin = [UIView getPoint_x:15 y:(_btnLocation.height - imgView.height)/2];
        [_btnLocation addSubview:imgView];
        
        UIImageView *narrowImg= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_m_s_right"]];
        narrowImg.size = [UIView getSize_width:9 height:15];
        narrowImg.origin = [UIView getPoint_x:ScreenWidth - narrowImg.width - 15
                                            y:(_btnLocation.height - narrowImg.height)/2];
        [_btnLocation addSubview:narrowImg];
        
        UILabel *titleLalbe = [[UILabel alloc] init];
        titleLalbe.tag = 99;
        titleLalbe.font = MediumFont;
        titleLalbe.textColor = ColorWhite;
        titleLalbe.size = [UIView getSize_width:_btnLocation.width - imgView.width - narrowImg.width - 20 height:30];
        titleLalbe.origin = [UIView getPoint_x:imgView.right + 5
                                             y:(_btnLocation.height - titleLalbe.height)/2];
        titleLalbe.text = @"添加位置";
        [_btnLocation addSubview:titleLalbe];
        
        
    }
    return  _btnLocation;
}

- (UIScrollView *) scrollerLocation{
    if (_scrollerLocation == nil){
        
        CGRect rect =  [UIView getFrame_x:0 y:self.btnLocation.bottom width:self.btnLocation.width height:sizeScale(40)];
        _scrollerLocation  = [[UIScrollView alloc] initWithFrame:rect];
        _scrollerLocation.alwaysBounceVertical = NO;
        _scrollerLocation.alwaysBounceHorizontal = YES;
        
        //test
        //        _scrollerLocation.backgroundColor = [UIColor redColor];
    }
    return _scrollerLocation;
}

- (UIButton *)btnDraft{
    
    if (!_btnDraft) {
        
        _btnDraft =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDraft setBackgroundColor:MTColorBtnNormal forState:UIControlStateNormal];
        [_btnDraft setBackgroundColor:MTColorBtnHighlighted forState:UIControlStateHighlighted];
        _btnDraft.size = [UIView getSize_width:sizeScale(150) height:sizeScale(35)];
        _btnDraft.right = self.scrollView.width/2 - 5;
        _btnDraft.bottom = self.scrollView.height - 50;
        _btnDraft.layer.cornerRadius = 2.0f;
        _btnDraft.layer.masksToBounds = true;//给按钮添加边框效果
        
        UIImageView *imageIcon = [[UIImageView alloc] init];
        imageIcon.size = [UIView getSize_width:sizeScale(12.5) height:sizeScale(12.5)];
        imageIcon.origin = [UIView getPoint_x:(_btnDraft.width - imageIcon.width)/2 - imageIcon.width-2
                                            y:(_btnDraft.height - imageIcon.height)/2];
        imageIcon.image = [UIImage imageNamed:@"icon_home_all_share_collention"];
        
        UILabel *lableCollectionTitle = [[UILabel alloc] init];
        lableCollectionTitle.size = [UIView getSize_width:_btnDraft.width/2 height:_btnDraft.height];
        lableCollectionTitle.origin = [UIView getPoint_x:imageIcon.right+5 y:0];
        lableCollectionTitle.textColor = [UIColor whiteColor];
        lableCollectionTitle.textAlignment = NSTextAlignmentLeft;
        lableCollectionTitle.text = @"草稿";
        lableCollectionTitle.font = [UIFont defaultBoldFontWithSize:14];
        
        [_btnDraft addSubview:imageIcon];
        [_btnDraft addSubview:lableCollectionTitle];
    }
    return  _btnDraft;
}

- (UIButton *)btnSave{
    
    if (!_btnSave) {
        
        _btnSave =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSave setBackgroundColor:MTColorBtnRedNormal forState:UIControlStateNormal];
        [_btnSave setBackgroundColor:MTColorBtnRedHighlighted forState:UIControlStateHighlighted];
        _btnSave.size = [UIView getSize_width:sizeScale(250) height:sizeScale(35)];
        
        _btnSave.centerX = self.view.width/2;
        _btnSave.bottom = self.scrollView.height - 50;
        _btnSave.layer.cornerRadius = 2.0f;
        _btnSave.layer.masksToBounds = true;//给按钮添加边框效果
        [_btnSave addTarget:self action:@selector(btnSaveClcik) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageIcon = [[UIImageView alloc] init];
        imageIcon.size = [UIView getSize_width:sizeScale(12.5) height:sizeScale(12.5)];
        imageIcon.origin = [UIView getPoint_x:(_btnSave.width - imageIcon.width)/2 - imageIcon.width-2
                                            y:(_btnSave.height - imageIcon.height)/2];
        imageIcon.image = [UIImage imageNamed:@"icon_home_all_share_collention"];
        
        UILabel *lableCollectionTitle = [[UILabel alloc] init];
        lableCollectionTitle.size = [UIView getSize_width:_btnSave.width/2 height:_btnSave.height];
        lableCollectionTitle.origin = [UIView getPoint_x:imageIcon.right+5 y:0];
        lableCollectionTitle.textColor = [UIColor whiteColor];
        lableCollectionTitle.textAlignment = NSTextAlignmentLeft;
        lableCollectionTitle.text = @"发布";
        lableCollectionTitle.font = [UIFont defaultBoldFontWithSize:14];
        
        [_btnSave addSubview:imageIcon];
        [_btnSave addSubview:lableCollectionTitle];
    }
    return  _btnSave;
}


-(void)initNavTitle{
    self.isNavBackGroundHiden = NO;
    
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.btnLeft = leftButton;
    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.left = 0;
    viewLine.size = [UIView getSize_width:ScreenWidth - viewLine.left height:0.6];
    viewLine.bottom = self.navBackGround.height - viewLine.height;
    viewLine.backgroundColor = MTColorLine;
    [self.navBackGround addSubview:viewLine];
    
    self.title = @"发布视频";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    self.imageViewCover.image = [UIImage imageWithContentsOfFile:self.videoOutputCoverPath];
    
    //获取周边的地址
    [self getLocation];
    
}

#pragma -mark  initUI---

-(void)setupUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    
    CGRect frame = CGRectMake(0, self.navBackGround.bottom, ScreenWidth, ScreenHeight - kNavBarHeight_New);
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.alwaysBounceVertical = YES; //垂直方向添加弹簧效果
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.speakTextView];
    [self.speakTextView addSubview:self.placeHoldelLebel];
    [self.scrollView addSubview:self.imageViewCover];
    [self.scrollView addSubview:self.progressView];
    [self.scrollView addSubview:self.viewLine];
    [self.scrollView addSubview:self.btnTopic];
    [self.scrollView addSubview:self.btnAFriend];
    [self.scrollView addSubview:self.btnLocation];
    [self.scrollView addSubview:self.scrollerLocation];
    //    [self.scrollView addSubview:self.btnDraft]; //屏蔽草稿按钮
    [self.scrollView addSubview:self.btnSave];
}

#pragma -mark  --------------- CustomMethod  ---

-(NSString*)getTopStr{
    
    NSMutableString *topicStr = [[NSMutableString alloc] init];
    for(int i=0;i<self.topicArray.count;i++){
        GetFuzzyTopicListModel *topicModel = [self.topicArray objectAtIndex:i];
        
        if(i == self.topicArray.count -1){
            [topicStr appendString:topicModel.topic];
        }
        else{
            [topicStr appendString:[NSString stringWithFormat:@"%@,",topicModel.topic]];
        }
    }
    return topicStr;
}

-(NSMutableArray*)getAtFriendArray{
    
    NSMutableArray *rangeArrays = [NSMutableArray array];
    for(GetFollowsModel *model in self.atArray){
        SaveVideoAtFriendContentModel *contentModel = [[SaveVideoAtFriendContentModel alloc] init];
        contentModel.noodle_id = model.noodleId;
        contentModel.head = model.noodleHead;
        contentModel.nickname = model.noodleNickname;
        [rangeArrays addObject:contentModel];
    }
    return rangeArrays;
}

-(void)getLocation{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled] && [GlobalData sharedInstance].hasClickPublicLocationBtn) {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestAlwaysAuthorization];
        [locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = 5.0;
        [locationmanager startUpdatingLocation];
    }
}

-(NSString*)getRandomAdressType{
    
    NSArray *array = @[@"车站",@"商场",@"酒店",@"景点",@"银行"];
    int x = arc4random() % array.count;
    return [array objectAtIndex:x];
}


#pragma mark   --------- CLLocationManagerDelegate -----------
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [manager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations firstObject];
    
    self.coordinate = currentLocation.coordinate;
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    [self loadAroundAdress:currentLocation.coordinate];
}

-(void)loadAroundAdress:(CLLocationCoordinate2D )coordinate{
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
    MKLocalSearchRequest *localSearchRequest = [[MKLocalSearchRequest alloc] init] ;
    localSearchRequest.region = region;
    localSearchRequest.naturalLanguageQuery = [self getRandomAdressType];//textField.text;//搜索关键词
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:localSearchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        NSLog(@"the response's count is:%ld",response.mapItems.count);
        if (error){
            NSLog(@"error info：%@",error);
        }
        else{
            
            CGFloat btnRight = 0.0f;
            CGFloat btnSpace = 15.0f;
            [self.mainDataArr removeAllObjects];
            [self.scrollerLocation removeAllSubviews];
            for(int i=0;i<response.mapItems.count;i++){
                
                MKMapItem *mapItem = [response.mapItems objectAtIndex:i];
                
                NSLog(@"name:%@,\nthoroughfare:%@,\nsubThoroughfare:%@,\nlocality:%@,\nsubLocality:%@,\nadministrativeArea:%@,\nsubAdministrativeArea:%@,\ncountry:%@,\ninlandWater:%@,\nocean:%@",mapItem.placemark.name,mapItem.placemark.thoroughfare,mapItem.placemark.subThoroughfare,mapItem.placemark.locality,mapItem.placemark.subLocality,mapItem.placemark.administrativeArea,mapItem.placemark.subAdministrativeArea,mapItem.placemark.country,mapItem.placemark.inlandWater,mapItem.placemark.ocean);
                
                LocaltionModel *model = [[LocaltionModel alloc] init];
                model.name = mapItem.placemark.name;
                model.adress = [NSString stringWithFormat:@"%@%@%@",mapItem.placemark.locality,mapItem.placemark.subLocality,mapItem.placemark.thoroughfare];
                model.coordinate = coordinate;
                model.city = mapItem.placemark.locality;
                [self.mainDataArr addObject:model];
                
                UIButton *btnAdress = [UIButton buttonWithType:UIButtonTypeCustom];
                btnAdress.tag = i;
                btnAdress.titleLabel.font = SmallFont;
                btnAdress.layer.masksToBounds = YES;
                btnAdress.layer.borderWidth = 0.6;
                btnAdress.layer.borderColor = MTColorLine.CGColor;
                btnAdress.layer.cornerRadius = 3;
                [btnAdress setTitleColor:ColorWhiteAlpha40 forState:UIControlStateNormal];
                [btnAdress setTitleColor:ColorThemeYellow forState:UIControlStateHighlighted];
                [btnAdress setTitleColor:ColorThemeYellow forState:UIControlStateSelected];
                [btnAdress setTitle:model.name forState:UIControlStateNormal];
                [btnAdress addTarget:self action:@selector(btnAdressClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                CGSize titleSize = [model.name sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btnAdress.titleLabel.font.fontName size:btnAdress.titleLabel.font.pointSize]}];
                
                btnAdress.width = titleSize.width+20;
                btnAdress.height = sizeScale(25);
                btnAdress.right = btnRight + btnAdress.width + btnSpace;
                btnAdress.centerY = self.scrollerLocation.height/2;
                btnRight = btnAdress.right;
                
                [self.scrollerLocation addSubview:btnAdress];
            }
            
            self.scrollerLocation.contentSize = [UIView getSize_width:btnRight height:self.scrollerLocation.height];
            
        }
    }];
}


#pragma mark ----------  UITextViewDelegate  -------------

-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeHoldelLebel.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeHoldelLebel.hidden = NO;
    }
}

#pragma mark ----------  话题,At好友, 选择地址Delegete-------------

-(void)TopicClick:(GetFuzzyTopicListModel*)model{
    
    NSString *topicString = [NSString stringWithFormat:@"%@ ",model.topic];
    [self.speakTextView insertText:topicString];
    
    NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithAttributedString:self.speakTextView.attributedText];
    NSRange range = NSMakeRange(self.cursorLocation - topicString.length, topicString.length);
    model.topicRange = range;
    
    [tmpAString setAttributes:@{ NSForegroundColorAttributeName: [UIColor yellowColor],NSFontAttributeName: self.speakTextView.font }
                        range:range];
    
    self.speakTextView.attributedText = tmpAString;
    [self.topicArray addObject:model];
    
    
    if (self.speakTextView.text.length == 0) {
        _placeHoldelLebel.hidden = NO;
    }
    else{
        _placeHoldelLebel.hidden = YES;
    }
}

-(void)AtFriendClick:(GetFollowsModel*)model{
    
    
    NSString *atString = [NSString stringWithFormat:@"@%@ ",model.noodleNickname];
    [self.speakTextView insertText:atString];
    
    NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithAttributedString:self.speakTextView.attributedText];
    NSRange range = NSMakeRange(self.cursorLocation - atString.length, atString.length);
    model.atRange = range;
    
    [tmpAString setAttributes:@{ NSForegroundColorAttributeName: [UIColor yellowColor],NSFontAttributeName: self.speakTextView.font }
                        range:range];
    
    self.speakTextView.attributedText = tmpAString;
    [self.atArray addObject:model];
    
    
    if (self.speakTextView.text.length == 0) {
        _placeHoldelLebel.hidden = NO;
    }
    else{
        _placeHoldelLebel.hidden = YES;
    }
}

-(void)localCellClick:(LocaltionModel*)model{
    NSLog(@"-------");
    self.localtionModel = model;
    
    UILabel *titleLalbe = [self.btnLocation viewWithTag:99];
    if(titleLalbe){
        titleLalbe.text = self.localtionModel.name;
    }
}

-(void)localDeleteClick{
    self.localtionModel = nil;
    UILabel *titleLalbe = [self.btnLocation viewWithTag:99];
    if(titleLalbe){
        titleLalbe.text = @"添加位置";
    }
}


#pragma mark ----------  textView Delegete-------------

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    self.cursorLocation = textView.selectedRange.location;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) { //收起键盘
        [textView resignFirstResponder];
        return NO;
    }
    if ([text isEqualToString:@""]) { // 删除
        
        //at Friends
        NSArray *rangeArrays = [self getAtAndTopicRangeArray];
        
        for (NSInteger i = 0; i < rangeArrays.count; i++) {
            AtAndTopicModel *atAndTopicModel = [rangeArrays objectAtIndex:i];
            NSRange tmpRanges = NSRangeFromString(atAndTopicModel.rangeStr);
            if ((range.location + range.length) == (tmpRanges.location + tmpRanges.length)) {
                
                if ([NSStringFromRange(tmpRanges) isEqualToString:NSStringFromRange(textView.selectedRange)]) {
                    
                    //[self.atArray removeObjectAtIndex:rangeArrays.count - 1];
                    // 第二次点击删除按钮 删除
                    
                    if(atAndTopicModel.publishType == PublishTypeTopic){
                        [self.topicArray removeObject:atAndTopicModel.topicModel];
                    }
                    else if(atAndTopicModel.publishType == PublishTypeAtFriend){
                        [self.atArray removeObject:atAndTopicModel.atFriendModel];
                    }
                    else{
                        return NO;
                    }
                    return YES;
                } else {
                    // 第一次点击删除按钮 选中
                    textView.selectedRange = tmpRanges;
                    return NO;
                }
            }
        }
    }
    else{//增加,设置为正在编辑
        
        _changeRanges = NSMakeRange(range.location, text.length);
        _isChanged = YES;
        return YES;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    /*
    //参考：https://www.cnblogs.com/supercheng/archive/2012/11/26/2789677.html
    textView.markedTextRange == nil判断是否有候选字符，如果不为nil，代表有候选字符，不纳入判断范围
     */
    if(textView.markedTextRange == nil){
        NSLog(@"没有");
    }
    else{
        NSLog(@"有");
        _isChanged = NO;
        return;
    }
    
    //@功能
    if (_isChanged) {
        NSMutableAttributedString *tmpAStrings = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
        [tmpAStrings setAttributes:@{ NSForegroundColorAttributeName:ColorWhite, NSFontAttributeName: [UIFont systemFontOfSize:16] } range:_changeRanges];
        textView.attributedText = tmpAStrings;
        _isChanged = NO;
    }
    
}

-(NSArray*)getAtAndTopicRangeArray{
    
    NSMutableArray *rangeArrays = [NSMutableArray array];
    for(GetFollowsModel *model in self.atArray){
        
        AtAndTopicModel *atAndTopicModel = [[AtAndTopicModel alloc] init];
        atAndTopicModel.publishType = PublishTypeAtFriend;
        atAndTopicModel.atFriendModel = model;
        atAndTopicModel.rangeStr = NSStringFromRange(model.atRange);
        [rangeArrays addObject:atAndTopicModel];
    }
    for(GetFuzzyTopicListModel *model in self.topicArray){
        AtAndTopicModel *atAndTopicModel = [[AtAndTopicModel alloc] init];
        atAndTopicModel.publishType = PublishTypeTopic;
        atAndTopicModel.topicModel = model;
        atAndTopicModel.rangeStr = NSStringFromRange(model.topicRange);
        [rangeArrays addObject:atAndTopicModel];
    }
    return rangeArrays;
}


#pragma mark ----------  btnClick  -------------

-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnSaveClcik{
    
    NetWork_mt_getUploadSignature *request = [[NetWork_mt_getUploadSignature alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    [request showWaitMsg:@"正在获取签名" handle:self];
    [request startGetWithBlock:^(GetUploadSignatureResponse *result, NSString *msg, BOOL finished) {
        
        if(finished){
            TXPublishParam * param = [[TXPublishParam alloc] init];
            param.signature = result.obj;                                // 需要填写第四步中计算的上传签名
            // 录制生成的视频文件路径 TXVideoRecordListener 的 onRecordComplete 回调中可以获取
            param.videoPath = self.videoPath;
            // 录制生成的视频首帧预览图路径。值为通过调用startRecord指定的封面路径，或者指定一个路径，然后将TXVideoRecordListener 的 onRecordComplete 回调中获取到的UIImage保存到指定路径下，可以置为 nil。
            param.coverPath = self.videoOutputCoverPath; //_coverPath;
            TXUGCPublish *_ugcPublish = [[TXUGCPublish alloc] init];
            // 文件发布默认是采用断点续传
            _ugcPublish.delegate = self;                                 // 设置 TXVideoPublishListener 回调
            [_ugcPublish publishVideo:param];
        }
        else{
            [self showFaliureHUD:@"获取签名失败"];
        }
    }];
}

-(void)btnAddTopic:(UIButton*)btn{
    
    AddTopicViewController *addTopicViewController = [[AddTopicViewController alloc] init];
    addTopicViewController.delegate = self;
    [self presentViewController:addTopicViewController animated:YES completion:nil];
    //[self pushNewVC:addTopicViewController animated:NO];
}

-(void)btnAFriend:(UIButton*)btn{
    
    AtFriendViewController *atFriendViewController = [[AtFriendViewController alloc] init];
    atFriendViewController.delegate = self;
    [self presentViewController:atFriendViewController animated:YES completion:nil];
}

-(void)btnAddLocation:(UIButton*)btn{
    
    [GlobalData sharedInstance].hasClickPublicLocationBtn = YES;
    [self loadAroundAdress:self.coordinate];
    
    AddLocationViewController *addLocationViewController = [[AddLocationViewController alloc] init];
    addLocationViewController.delegate = self;
    [self presentViewController:addLocationViewController animated:YES completion:nil];
}

-(void)btnAdressClick:(UIButton*)btn{
    
    NSArray *btnArray = [self.scrollerLocation subviews];
    for(UIButton *btn in btnArray){
        if([btn isKindOfClass: [UIButton class]]){
            btn.selected = NO;
            btn.layer.borderColor = MTColorLine.CGColor;
            [btn setTitleColor:ColorWhiteAlpha40 forState:UIControlStateNormal];
        }
    }
    
    btn.selected = YES;
    btn.layer.borderColor = ColorThemeYellow.CGColor;
    
    LocaltionModel *model = [self.mainDataArr objectAtIndex:btn.tag];
    if(model){
        self.localtionModel = model;
        
        UILabel *titleLalbe = [self.btnLocation viewWithTag:99];
        if(titleLalbe){
            titleLalbe.text = self.localtionModel.name;
        }
    }
}


#pragma mark ----------  TXVideoPublishListener 上传腾讯云 进度  -------------

-(void) onPublishProgress:(uint64_t)uploadBytes totalBytes: (uint64_t)totalBytes{
    
    CGFloat progress = (float)uploadBytes / totalBytes;
    if(progress == 0.0f){
        self.progressView.hidden = YES;
    }
    else{
        self.progressView.hidden = NO;
        self.progressView.progress = progress;
    }
    
}

-(void) onPublishComplete:(TXPublishResult*)result{
    
    NSString *strContent = self.speakTextView.text.trim;
    SaveVideoContentModel *model = [[SaveVideoContentModel alloc] init];
    model.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    model.nickname = [GlobalData sharedInstance].loginDataModel.nickname;
    model.fileId = result.videoId;
    model.noodleVideoCover = result.coverURL;
    model.storagePath = result.videoURL;
    model.noodleVideoName = [result.videoURL lastPathComponent];
    
    if(self.musicModel){
        model.musicId = [NSString stringWithFormat:@"%@",self.musicModel.musicId];
        model.musicName = self.musicModel.musicName;
        model.musicUrl = self.musicModel.playUrl;
        model.coverUrl = self.musicModel.coverUrl;
    }
    
    if([GlobalData sharedInstance].videoQuality == VIDEO_COMPRESSED_720P){
        model.size = @"720p";
    }
    if([GlobalData sharedInstance].videoQuality == VIDEO_COMPRESSED_540P){
        model.size = @"540p";
    }
    if([GlobalData sharedInstance].videoQuality == VIDEO_COMPRESSED_480P){
        model.size = @"480p";
    }
    if([GlobalData sharedInstance].videoQuality == VIDEO_COMPRESSED_360P){
        model.size = @"360p";
    }
    
    model.title = strContent;
    model.topic = [self getTopStr];
    model.aFriends = [self getAtFriendArray];
    if(self.localtionModel){
        model.addr = self.localtionModel.name;
        model.city = self.localtionModel.city;
        model.latitude = [NSString stringWithFormat:@"%f",self.localtionModel.coordinate.latitude];
        model.longitude = [NSString stringWithFormat:@"%f",self.localtionModel.coordinate.longitude];
    }
    
    NetWork_mt_saveVideo *request = [[NetWork_mt_saveVideo alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.content = [model generateJsonStringForProperties];
    [request showWaitMsg:@"正在发布" handle:self];
    [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
        if(finished){
            [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:1];
        }
        else{
            [UIWindow showTips:@"视频上传失败，请稍再试。"];
        }
    }];
}

- (void)dismissViewController{
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
