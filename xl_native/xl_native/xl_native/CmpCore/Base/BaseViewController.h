//
//  YCCustomViewController.h
//  YCBuddy
//
//  Created by bita on 15/5/26.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ShowNotice.h"
#import "MJTableView.h"
#import "BaseTableViewCell.h"

@interface BaseViewController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,
WCServiceJrLoanDelegate,UITableViewDelegate,UITableViewDataSource,CellDelegate>

@property (strong, nonatomic) UIButton *btnLeft;
@property (strong, nonatomic) UIButton *btnRight;
@property (strong, nonatomic) UIView *titleNavView;
@property (strong, nonatomic) UILabel *lableNavTitle;
@property (strong, nonatomic) UIView *navBackGround;

@property (nonatomic, strong) ShowNotice *showNotice;
@property (nonatomic, assign) BOOL isNavBackGroundHiden;

/*是否当前TableView style group*/
@property (nonatomic, assign) BOOL          isGroup;


- (void)setTitle:(NSString *)title;

-(void)setBtnRight:(UIButton *)btnRight;


#pragma mark - 进入下一页面
- (void)pushNewVC:(UIViewController *)newViewController
         animated:(BOOL)animated;

- (void)pushNewVC:(UIViewController *)newViewController
         animated:(BOOL)animated
          hideNav:(BOOL)hideNav;

#pragma mark - 到指定页面处理
- (void)pushNewVC:(UIViewController *)newViewController
         enableVC:(NSString *)enableViewControllerName
         animated:(BOOL)animated;

- (void)pushNewVC:(UIViewController *)newViewController
         enableVC:(NSString *)enableViewControllerName
         animated:(BOOL)animated
          hideNav:(BOOL)hideNav;

- (void)addLeftBtn;
- (void)LeftBtnClicked:(UIButton *)sender;

- (void)initNavTitle;


//一般的提示
- (void)showFaliureHUD:(NSString *)message;//接口请求失败提示
- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg;
- (void)handleTokenOverdue:(NSString *)msg; //token 过期处理方法

/*
 *等待框
 */
- (void)startWithCursor:(NSString*)msg;
- (void)stopWatiCursor;

/*
 *懒加载tableView的数据
 */
@property (strong, nonatomic) NSMutableArray *mainDataArr;
/*
 *懒加载tableView
 */
@property (nonatomic, strong) MJTableView * mainTableView;
/*
 *当前页,默认值是0，
 */
@property (nonatomic, assign) int     currentPageIndex;

/*
 *当前页面请求数量,默认值20
 */
@property (nonatomic, assign) int     currentPageSize;
/*
 *总条数
 */
@property (nonatomic, assign) int     totalCount;

//-(void)headerRereshing;
//-(void)footerRereshing;

- (void)loadMoreData;
- (void)loadNewData;

/*
 *根据当前tableview的条数，显示空数据
 */
-(void)refreshNoDataViewWithListCount:(NSInteger)listCount;


@end
