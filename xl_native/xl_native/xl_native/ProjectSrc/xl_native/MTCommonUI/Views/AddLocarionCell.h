//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "VUILable.h"
#import "NetWork_mt_getFuzzyAccountList.h"
#import "NetWork_mt_saveflour.h"
#import "NetWork_mt_delflour.h"

@interface LocaltionModel : IObjcJsonBase

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *adress;
@property (copy, nonatomic) NSString *city;

@property(assign, nonatomic) CLLocationCoordinate2D coordinate;

@end

#define AddLocarionCellHeight 60.0f
#define AddLocarionCellSpace 6.0f


@interface AddLocarionCell : BaseTableViewCell

+ (NSString*) cellId;

@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) VUILable * labelTitle;
@property(nonatomic,strong) VUILable * labelSign;
@property(nonatomic,strong) LocaltionModel * listModel;

- (void)fillDataWithModel:(LocaltionModel *)listModel withKeyWord:(NSString*)withKeyWord;

@end
