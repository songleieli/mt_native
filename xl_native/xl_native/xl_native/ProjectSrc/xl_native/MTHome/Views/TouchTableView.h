//
//  ZJD_TableView.h
//  让UITableView响应touch事件
//
//  Created by songlei on 15/5/22.
//  Copyright (c) 2015年 aidong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  我们知道UITableView没有像UIButton那样可以通过addTarget方法来监听touch事件，因此在某些场合，特别是在UITableViewCell中包含UITextField的时候，我们很有可能想通过点击UITableView的其他地方来取消UITextField的焦点。也许有朋友会说，使用UITapGestureRecognizer手势来取消焦点，这样是可以行得通，但是如果TextField中有clearButton或者其自定义的Button的时候，手势就会吸收掉事件了，导致按钮无效。
 */

/**
 *  本类使用方法也很简单在原有UITableView的基础上赋予touchDelegate委托即可取到touch事件响应。如下：
 
 - (void)loadView
 {
 [super loadView];
 TouchTableView *tableView = [[TouchTableView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320, 400)   style:UITableViewStyleGrouped];
 tableView.touchDelegate = self;
 [self.view addSubview:tableView];
 }
 
 
 - (void)tableView:(UITableView *)tableView
 touchesEnded:(NSSet *)touches
 withEvent:(UIEvent *)event
 {
 //touch结束后的处理
 }
 */


/**
 *  重写UITableView的touch相关的方法，然后通过委托的方式提供给外部对象使用。首先定义Delegate：
 */
@protocol TouchTableViewDelegate <NSObject>

@optional
/**
 *  重写touch方法时必须把父类实现方法写上，否则UITableViewCell将无法正常工作。所有的改写工作如下所示，新的TableView类具有touch事件响应了。
 */
- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
 touchesCancelled:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesMoved:(NSSet *)touches
        withEvent:(UIEvent *)event;
@end

/**
 *  然后UITableView的子类加入一委托对象，并重写所有touch相关方法
 */
@interface TouchTableView : UITableView

@property (nonatomic,weak) id<TouchTableViewDelegate> touchDelegate;

@end
