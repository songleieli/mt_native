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


@protocol SearchResultSubUserDelegate <NSObject>

-(void)btnCellClick:(GetFuzzyAccountListModel*)model;

@end


#define SearchResultSubUserCellHeight 90.0f
#define SearchResultSubUserCellSpace 6.0f


@interface SearchResultSubUserCell : BaseTableViewCell

+ (NSString*) cellId;



@property(nonatomic,strong) UIButton * viewBg;

@property(nonatomic,strong) UIImageView * imageVeiwIcon;
@property(nonatomic,strong) VUILable * labelTitle;
@property(nonatomic,strong) VUILable * labelNoodleInfo;
@property(nonatomic,strong) VUILable * labelSign;

@property (nonatomic, strong) UIButton *focusButton;
@property(nonatomic,weak) id <SearchResultSubUserDelegate> subCellDelegate;

@property(nonatomic,strong) GetFuzzyAccountListModel * listModel;

- (void)fillDataWithModel:(GetFuzzyAccountListModel *)listModel withKeyWord:(NSString*)withKeyWord;



@end
