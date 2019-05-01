//
//  CZActionSheetView.h
//  ProjectModelX
//
//  Created by MRZHU－MAC on 2018/4/25.
//  Copyright © 2018年 sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZActionSheetView : UIView

typedef void(^VoidBlock)(void);
typedef void(^IntegerBlock)(NSInteger index);

- (instancetype)initWithTitleView:(UIView*)titleView
                       optionsArr:(NSArray*)optionsArr
                      cancelTitle:(NSString*)cancelTitle
                    selectedBlock:(IntegerBlock)selectedBlock
                      cancelBlock:(VoidBlock)cancelBlock;

- (void)show ;
@end
