//
//  NewProjectView.h
//  JrLoanMobile
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 Junrongdai. All rights reserved.
//


@interface CTProdectItemModel : IObjcJsonBase

@property (nonatomic, assign) int index;//index
@property (nonatomic, copy) NSString *id;//产品id
@property (nonatomic, copy) NSString *itemTitle;//功能名称
@property (nonatomic, copy) NSString *itemIcon;//功能图标



@end



@interface CTProdectView : UIView

/*
 *rowCount 每一行显示个数
 */
-(void)reloadWithSource:(NSArray*)source rowCount:(NSInteger) rowCount;

@property(nonatomic,strong) void (^blockClcik)(CTProdectItemModel *item);


@end
