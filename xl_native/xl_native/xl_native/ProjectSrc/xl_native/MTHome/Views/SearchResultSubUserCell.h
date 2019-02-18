//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getFuzzyAccountList.h"


@protocol SearchResultSubUserDelegate <NSObject>

-(void)btnCellClick:(GetFuzzyAccountListModel*)model;

@end


#define SearchResultSubUserCellHeight 80.0f
#define SearchResultSubUserCellSpace 6.0f


@interface SearchResultSubUserCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(GetFuzzyAccountListModel *)listModel;

@property(nonatomic,strong) GetFuzzyAccountListModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property (nonatomic, strong) UIButton *focusButton;


@property(nonatomic,weak) id <SearchResultSubUserDelegate> subCellDelegate;


@end
