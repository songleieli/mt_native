//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "AddLocationViewController.h"




@interface AddLocationViewController ()<CLLocationManagerDelegate>{
    
    CLLocationManager *locationmanager;//定位服务
}

@property (nonatomic,strong) NSString * keyWord;
@property(assign, nonatomic) CLLocationCoordinate2D coordinate;



@end

@implementation AddLocationViewController

- (UIButton *) headButton{
    
    if (_headButton == nil){
        
        _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headButton.size = [UIView getSize_width:ScreenWidth height:50.0f];
        _headButton.origin = [UIView getPoint_x:0 y:0];
        _headButton.titleLabel.font = BigFont;
        [_headButton setTitle:@"    不显示我的位置" forState:UIControlStateNormal];
        [_headButton  setTitleColor:ColorWhiteAlpha80 forState:UIControlStateNormal];
        [_headButton  setTitleColor:ColorWhite forState:UIControlStateHighlighted];
        _headButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_headButton addTarget:self action:@selector(deleteLocation:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _headButton;
}



-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)registerForRemoteNotification{
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden  = NO;
    self.btnLeft.hidden = YES;
    
    //取消按钮
    self.cancleButton = [[UIButton alloc]init];
    self.cancleButton.size = [UIView getSize_width:35 height:36];
    self.cancleButton.right = ScreenWidth - 15;
    self.cancleButton.bottom = self.navBackGround.height - 5;
    [self.cancleButton setTitleColor:MTColorBtnRedNormal forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:MTColorBtnRedHighlighted forState:UIControlStateHighlighted];

    self.cancleButton.titleLabel.font = MediumBoldFont;
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackGround addSubview:self.cancleButton];
    

    self.textFieldBgView = [[UIView alloc] init];
    self.textFieldBgView.size = [UIView getSize_width:self.navBackGround.width - 15*2 - self.cancleButton.width -15
                                               height:self.navBackGround.height];
    self.textFieldBgView.origin = [UIView getPoint_x:15 y:0];
    self.textFieldBgView.layer.borderWidth = 0.0;
    self.textFieldBgView.layer.cornerRadius = 5.0;
    self.textFieldBgView.layer.borderColor = defaultLineColor.CGColor;
    [self.navBackGround addSubview:self.textFieldBgView];
    
    
    self.textFieldSearchKey = [[UITextField alloc] init];
    self.textFieldSearchKey.size = [UIView getSize_width:self.textFieldBgView.width height:36];
    self.textFieldSearchKey.origin = [UIView getPoint_x:0 y:self.textFieldBgView.height - self.textFieldSearchKey.height-5];
    self.textFieldSearchKey.layer.cornerRadius = 4.0f;
    self.textFieldSearchKey.placeholder = @"车站,学校,餐馆,景点,医院";
    self.textFieldSearchKey.textColor = [UIColor whiteColor];
    self.textFieldSearchKey.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldSearchKey.clearsOnBeginEditing = YES;
    self.textFieldSearchKey.delegate = self;
    self.textFieldSearchKey.returnKeyType = UIReturnKeyDone;
    self.textFieldSearchKey.font = MediumFont;
    self.textFieldSearchKey.backgroundColor = MTColorBtnNormal;
    [self.textFieldSearchKey setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textFieldBgView addSubview:self.textFieldSearchKey];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.textFieldSearchKey];
    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.left = 0;
    viewLine.size = [UIView getSize_width:ScreenWidth - viewLine.left height:0.6];
    viewLine.bottom = self.navBackGround.height - viewLine.height;
    viewLine.backgroundColor = MTColorLine;
    [self.navBackGround addSubview:viewLine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForRemoteNotification];
    [self setUpUI];
    
    [self getLocation];
}

-(void)setUpUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    [self.view addSubview:self.mainTableView];
    
    [self.textFieldSearchKey becomeFirstResponder]; //获得焦点
    
    NSInteger tableViewHeight = ScreenHeight - kNavBarHeight_New;
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:tableViewHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:kNavBarHeight_New];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor]; //RGBFromColor(0xecedf1);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.tableHeaderView = self.headButton;
    [self.mainTableView.mj_header beginRefreshing];
    self.mainTableView.mj_footer.hidden = YES;
    [self.mainTableView registerClass:AddLocarionCell.class forCellReuseIdentifier:[AddLocarionCell cellId]];
}


#pragma -mark ---------- CustomMethod ----------

-(void)getLocation{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
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


//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [locationmanager stopUpdatingLocation];

    CLLocation *currentLocation = [locations firstObject];
    
    self.coordinate = currentLocation.coordinate;
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    [self loadAroundAdress:currentLocation.coordinate];
}


-(void)loadAroundAdress:(CLLocationCoordinate2D )coordinate{
    
    if(self.keyWord.length == 0){
        self.keyWord = [self getRandomAdressType];
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 50, 50);
    MKLocalSearchRequest *localSearchRequest = [[MKLocalSearchRequest alloc] init] ;
    localSearchRequest.region = region;
    localSearchRequest.naturalLanguageQuery = self.keyWord;//textField.text;//搜索关键词
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:localSearchRequest];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        [self.mainDataArr removeAllObjects];
        NSLog(@"the response's count is:%ld",response.mapItems.count);
        if (error){
            NSLog(@"error info：%@",error);
        }
        else{
            
            NSString *cityName = @"";
            for (MKMapItem *mapItem in response.mapItems){
                
                NSLog(@"name:%@,\nthoroughfare:%@,\nsubThoroughfare:%@,\nlocality:%@,\nsubLocality:%@,\nadministrativeArea:%@,\nsubAdministrativeArea:%@,\ncountry:%@,\ninlandWater:%@,\nocean:%@",mapItem.placemark.name,mapItem.placemark.thoroughfare,mapItem.placemark.subThoroughfare,mapItem.placemark.locality,mapItem.placemark.subLocality,mapItem.placemark.administrativeArea,mapItem.placemark.subAdministrativeArea,mapItem.placemark.country,mapItem.placemark.inlandWater,mapItem.placemark.ocean);
                
                LocaltionModel *model = [[LocaltionModel alloc] init];
                model.name = mapItem.placemark.name;
                model.adress = [NSString stringWithFormat:@"%@%@%@",mapItem.placemark.locality,mapItem.placemark.subLocality,mapItem.placemark.name];
                model.coordinate = coordinate;
                model.city = mapItem.placemark.locality;
                cityName = mapItem.placemark.locality;
                [self.mainDataArr addObject:model];
            }
            
            if(cityName.trim.length > 0){
                LocaltionModel *model = [[LocaltionModel alloc] init];
                model.name = cityName;
                model.adress = @"";
                model.coordinate = coordinate;
                model.city = cityName;
                [self.mainDataArr insertObject:model atIndex:0];
                //[self.mainDataArr addObject:model];
            }
            
        }
        
        [self.mainTableView reloadData];
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

-(void)backBtnClick:(UIButton*)btn{
    if(self.backClickBlock){
        self.backClickBlock();
    }
}

-(void)deleteLocation:(UIButton*)btn{
    
    if ([self.delegate respondsToSelector:@selector(localDeleteClick)]) {
        [self.delegate localDeleteClick];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
    [self btnCancelClick];

}

#pragma mark -------------- 加载更多 --------------

-(void)loadNewData{
    self.currentPageIndex = 0;
    
    [self getLocation];
}

#pragma mark - 取消按钮点击事件

-(void)btnCancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --------------- tabbleView代理 -----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.mainDataArr.count;
}
//设置cell的样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.mainDataArr.count > 0){
        AddLocarionCell *cell = [tableView dequeueReusableCellWithIdentifier:[AddLocarionCell cellId] forIndexPath:indexPath];
        cell.delegate = self;
        LocaltionModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
        [cell fillDataWithModel:model withKeyWord:self.keyWord];
        return cell;
    }
    else{
        /*
         有时会出现，self.mainDataArr count为0 cellForRowAtIndexPath，却响应的bug。
         */
        UITableViewCell * celltemp =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        return celltemp;
    }
}

//设置每一组的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  AddLocarionCellHeight;
}


#pragma mark - -------- UITextFieldDelegate -------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder]; //收起键盘
    return YES;
}

-(void)textFiledEditChanged:(NSNotification*)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    self.keyWord = textField.text;
    [GlobalData sharedInstance].searchKeyWord = self.keyWord;
    [self loadAroundAdress:self.coordinate];
}

#pragma mark - -------- SearchResultSubTopicDelegate -------------

- (void)btnClicked:(id)sender cell:(AddLocarionCell *)cell{
    
    if ([self.delegate respondsToSelector:@selector(localCellClick:)]) {
        [self.delegate localCellClick:cell.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
    
    [self btnCancelClick];
}

#pragma mark - 键盘 show 与 hide

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    
    self.keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.mainTableView.height = ScreenHeight - self.keyBoardFrame.size.height -kNavBarHeight_New;
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification{
/*
 *暂时保留
 */
    self.mainTableView.height = ScreenHeight -kNavBarHeight_New;
}


@end
