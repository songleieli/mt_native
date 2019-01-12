//
//  MyViewTableViewCell.h
//  CMPLjhMobile
//
//  Created by Liyanjun on 2017/6/26.
//  Copyright © 2017年 CMP_Ljh. All rights reserved.
//

#import <UIKit/UIKit.h>

enum MyCellTag {
    MyCellTag_logout = 0,
    MyCellTag_editor,
    MyCellTag_cleanCache,
    MyCellTag_about,
    MyCellTag_other
};



#define MyViewTableViewCellHeight     sizeScale(45)  //评论title的高度

@interface MyViewTableViewCellModel : NSObject

@property (nonatomic ,copy)NSString* imageStr;
@property (nonatomic ,copy)NSString* titleStr;
@property (nonatomic,assign)BOOL isShowLine;
@property (nonatomic,assign)enum MyCellTag cellTag;

@end

@protocol MyCellDelegate <NSObject>

-(void)myCellClick:(MyViewTableViewCellModel*)model;

@end

@interface MyViewTableViewCell : UITableViewCell


@property(nonatomic,strong) MyViewTableViewCellModel * listModel;
@property(nonatomic,weak) id <MyCellDelegate> myCellDelegate;

- (void)dataBind:(MyViewTableViewCellModel*)model;

+ (NSString*) cellId;
@end
