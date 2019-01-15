//
//  NewProjectView.h
//  JrLoanMobile
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 Junrongdai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetWork_mt_getHotSearchSix.h"
#import "VUILable.h"


@interface MTSearchHeadFunctionView : UIView

-(void)reloadWithSource:(NSArray*)source dataLoadFinishBlock:(void(^)())dataLoadFinishBlock;

@property(nonatomic,strong) void (^zanClcik)(GetHotSearchSixModel *item,UIButton *btnZan,UILabel *labelZan);
@property(nonatomic,strong) void (^playVideoClcik)(GetHotSearchSixModel *item);

@end
