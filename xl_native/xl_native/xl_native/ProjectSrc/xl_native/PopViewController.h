//
//  PopViewController.h
//  CMPLjhMobile
//
//  Created by songleilei on 16/7/6.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol presentViewControllerDelegate <NSObject>

-(void)clickRow:(NSInteger)row;

@end


@interface PopViewController : UIViewController

@property (nonatomic,weak) id <presentViewControllerDelegate> delegate;


@end
