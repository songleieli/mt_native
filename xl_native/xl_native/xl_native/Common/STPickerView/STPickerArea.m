//
//  STPickerArea.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerArea.h"


@interface STPickerArea()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
/** 4.当前地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayArea;
///** 5.当前选中数组 */
//@property (nonatomic, strong, nullable)NSMutableArray *arraySelected;

/** 6.省份 */
@property (nonatomic, strong, nullable)GetProvinceDataModel *provinceModel;
/** 7.城市 */
@property (nonatomic, strong, nullable)GetProvinceDataModel *cityModel;
/** 8.地区 */
@property (nonatomic, strong, nullable)GetProvinceDataModel *areaModel;

@end

@implementation STPickerArea

#pragma mark - --- init 视图初始化 ---

- (void)setupUI{
    
    [self getPrivaceData];
    
    // 2.设置视图的默认属性
    _heightPickerComponent = 32;
    
}

#pragma mark - --- 初始化省市区数据 ---
-(void)getPrivaceData{
    NetWork_mt_scenic_getProvinceData *request = [[NetWork_mt_scenic_getProvinceData alloc] init];
    [request startGetWithBlock:^(GetProvinceDataResponse *result, NSString *msg, BOOL finished) {
        if(finished){
            if(result.obj.count > 0){
                self.arrayProvince = [[NSMutableArray alloc] initWithArray:result.obj];
                [self getCityData:self.arrayProvince.firstObject];
                self.provinceModel = self.arrayProvince.firstObject;
            }
        }
    }];
}
-(void)getCityData:(GetProvinceDataModel*)proviceModel{
    
    NetWork_mt_scenic_getCityByProvinceCode *requestOne = [[NetWork_mt_scenic_getCityByProvinceCode alloc] init];
    requestOne.code = proviceModel.code;
    [requestOne startGetWithBlock:^(GetProvinceDataResponse *result, NSString *msg, BOOL finished) {
        if(finished){
            if(result.obj.count > 0){
                self.arrayCity = [[NSMutableArray alloc] initWithArray:result.obj];
//                [self getAreaData:self.arrayCity.firstObject];
                self.cityModel = self.arrayCity.firstObject;
                
                
                if ([self.delegate respondsToSelector:@selector(pickerArea:province:city:)]) {
                    [self.delegate pickerArea:self province:self.provinceModel city:self.cityModel];
                }
                [self setTitle:@"请选择城市地区"];
                [self.pickerView setDelegate:self];
                [self.pickerView setDataSource:self];

            }
        }
    }];
}
//-(void)getAreaData:(GetProvinceDataModel*)proviceModel{
//
//    NetWork_mt_scenic_getCountyByCityCode *requestOne = [[NetWork_mt_scenic_getCountyByCityCode alloc] init];
//    requestOne.code = proviceModel.code;
//    [requestOne startGetWithBlock:^(GetProvinceDataResponse *result, NSString *msg, BOOL finished) {
//        if(finished){
//            if(result.obj.count > 0){
//                self.arrayCity = [[NSMutableArray alloc] initWithArray:result.obj];
//
//                self.provinceModel = (GetProvinceDataModel*)self.arrayProvince.firstObject;
//                self.cityModel = (GetProvinceDataModel*)self.arrayCity.firstObject; //self.arrayCity[0];
//                if (self.arrayArea.count != 0) {
//                    self.areaModel =  (GetProvinceDataModel*)self.arrayArea.firstObject;//self.arrayArea[0];
//                }else{
//                    //self.area = @"";
//                }
//                self.saveHistory = NO;
//
//
//                [self setTitle:@"请选择城市地区"];
//                [self.pickerView setDelegate:self];
//                [self.pickerView setDataSource:self];
//            }
//        }
//    }];
//}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.arrayProvince.count;
    }else if (component == 1) {
        
        
        return self.arrayCity.count;
        
        
        
        
    }else{
        return self.arrayArea.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        
        
        GetProvinceDataModel *model = [self.arrayProvince objectAtIndex:row];
        [self.arrayCity removeAllObjects];
        
        NetWork_mt_scenic_getCityByProvinceCode *requestOne = [[NetWork_mt_scenic_getCityByProvinceCode alloc] init];
        requestOne.code = model.code;
        [requestOne startGetWithBlock:^(GetProvinceDataResponse *result, NSString *msg, BOOL finished) {
            if(finished){
                if(result.obj.count > 0){
                    self.arrayCity = [[NSMutableArray alloc] initWithArray:result.obj];
                    self.cityModel = self.arrayCity.firstObject;
                    
                    if ([self.delegate respondsToSelector:@selector(pickerArea:province:city:)]) {
                        [self.delegate pickerArea:self province:self.provinceModel city:self.cityModel];
                    }

                    [pickerView reloadComponent:1];
//                    [pickerView reloadComponent:2];
                    [pickerView selectRow:0 inComponent:1 animated:YES];
//                    [pickerView selectRow:0 inComponent:2 animated:YES];
                }
            }
        }];
    }
    else if (component == 1) {
        GetProvinceDataModel *model = [self.arrayCity objectAtIndex:row];
        self.cityModel = model;
        
        if ([self.delegate respondsToSelector:@selector(pickerArea:province:city:)]) {
            [self.delegate pickerArea:self province:self.provinceModel city:self.cityModel];
        }
        
//        NetWork_mt_scenic_getCountyByCityCode *requestOne = [[NetWork_mt_scenic_getCountyByCityCode alloc] init];
//        requestOne.code = model.code;
//        [requestOne startGetWithBlock:^(GetProvinceDataResponse *result, NSString *msg, BOOL finished) {
//            if(finished){
//                if(result.obj.count > 0){
//                    self.arrayArea = [[NSMutableArray alloc] initWithArray:result.obj];
//
////                    [pickerView reloadComponent:2];
////                    [pickerView selectRow:0 inComponent:2 animated:YES];
//                }
//            }
//        }];
    }else{
    }

    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{

    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    
    
    GetProvinceDataModel *model;
    if (component == 0) {
        model =  self.arrayProvince[row];
    }else if (component == 1){
        model =  self.arrayCity[row];
    }else{
        if (self.arrayArea.count > 0) {
            model = self.arrayArea[row];
        }
        else{
//            text =  @"";
        }
    }
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:model.name];
    label.textColor = [UIColor whiteColor];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk{
    
    if (self.isSaveHistory) {
        NSDictionary *dicHistory = @{@"province":self.provinceModel, @"city":self.cityModel, @"area":self.areaModel};
        [[NSUserDefaults standardUserDefaults] setObject:dicHistory forKey:@"STPickerArea"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"STPickerArea"];
    }
    
    if ([self.delegate respondsToSelector:@selector(pickerArea:province:city:area:)]) {
        [self.delegate pickerArea:self province:self.provinceModel city:self.cityModel area:self.areaModel];
    }
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
//    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    self.provinceModel = self.arrayProvince[index0];
    
    if(self.arrayCity.count > 0){
        self.cityModel = self.arrayCity[index1];
    }
    else{
        self.cityModel = nil;
    }
    if (self.arrayArea.count > 0) {
//        self.areaModel = self.arrayArea[index2];
    }else{
        self.areaModel = nil;
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", self.provinceModel.name.length>0?self.provinceModel.name:@"",
                       self.cityModel.name.length>0?self.cityModel.name:@"",
                       self.areaModel.name.length>0?self.areaModel.name:@""];
    [self setTitle:title];

}

#pragma mark - --- getters 属性 ---

- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
        NSString *path = [[NSBundle bundleForClass:[STPickerView class]] pathForResource:@"area" ofType:@"plist"];
        _arrayRoot = [[NSArray alloc]initWithContentsOfFile:path];
    }
    return _arrayRoot;
}

- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
        _arrayProvince = @[].mutableCopy;
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = @[].mutableCopy;
    }
    return _arrayCity;
}

- (NSMutableArray *)arrayArea
{
    if (!_arrayArea) {
        _arrayArea = @[].mutableCopy;
    }
    return _arrayArea;
}

@end


