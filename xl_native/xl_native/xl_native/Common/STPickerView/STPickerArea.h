//
//  STPickerArea.h
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPickerView.h"
#import "NetWork_mt_scenic_getProvinceData.h"
#import "NetWork_mt_scenic_getCountyByCityCode.h"
#import "NetWork_mt_scenic_getCityByProvinceCode.h"

NS_ASSUME_NONNULL_BEGIN
@class STPickerArea;
@protocol  STPickerAreaDelegate<NSObject>

- (void)pickerArea:(STPickerArea *)pickerArea province:(GetProvinceDataModel *)province city:(GetProvinceDataModel *)city area:(GetProvinceDataModel *)area;

- (void)pickerArea:(STPickerArea *)pickerArea province:(GetProvinceDataModel *)province city:(GetProvinceDataModel *)city;

@end
@interface STPickerArea : STPickerView
/** 1.中间选择框的高度，default is 32*/
@property(nonatomic, assign)CGFloat heightPickerComponent;
/** 2.保存之前的选择地址，default is NO */
@property(nonatomic, assign, getter=isSaveHistory)BOOL saveHistory;

@property(nonatomic, weak)id <STPickerAreaDelegate>delegate;

@end
NS_ASSUME_NONNULL_END
