//
//  NickNameViewController.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/24.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "IntroduceViewController.h"
//#import "NetWork_updateUser.h"
@interface IntroduceViewController ()<UITextFieldDelegate>{
    
    BOOL _canedit;
    
}

/** 昵称textField */
@property(nonatomic,strong) UITextField * nickNameTextField;

@end

@implementation IntroduceViewController

- (UIButton *)btnSave{
    
    if (!_btnSave) {
        
        _btnSave =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSave setBackgroundColor:MTColorBtnRedNormal forState:UIControlStateNormal];
        [_btnSave setBackgroundColor:MTColorBtnRedHighlighted forState:UIControlStateHighlighted];
        _btnSave.size = [UIView getSize_width:sizeScale(250) height:sizeScale(35)];
        
        _btnSave.centerX = self.view.width/2;
        _btnSave.bottom = self.scrollView.height - 50;
        _btnSave.layer.cornerRadius = 2.0f;
        _btnSave.layer.masksToBounds = true;//给按钮添加边框效果
        [_btnSave addTarget:self action:@selector(btnSaveClcik:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageIcon = [[UIImageView alloc] init];
        imageIcon.size = [UIView getSize_width:sizeScale(12.5) height:sizeScale(12.5)];
        imageIcon.origin = [UIView getPoint_x:(_btnSave.width - imageIcon.width)/2 - imageIcon.width-2
                                            y:(_btnSave.height - imageIcon.height)/2];
        imageIcon.image = [UIImage imageNamed:@"icon_home_all_share_collention"];
        
        UILabel *lableCollectionTitle = [[UILabel alloc] init];
        lableCollectionTitle.size = [UIView getSize_width:_btnSave.width/2 height:_btnSave.height];
        lableCollectionTitle.origin = [UIView getPoint_x:imageIcon.right+5 y:0];
        lableCollectionTitle.textColor = [UIColor whiteColor];
        lableCollectionTitle.textAlignment = NSTextAlignmentLeft;
        lableCollectionTitle.text = @"保存";
        lableCollectionTitle.font = [UIFont defaultBoldFontWithSize:14];
        
        [_btnSave addSubview:imageIcon];
        [_btnSave addSubview:lableCollectionTitle];
    }
    return  _btnSave;
}

-(void)initNavTitle{
    self.isNavBackGroundHiden = NO;
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft = leftButton;

    self.title = @"签名";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

-(void)creatUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    
    
    CGRect frame = CGRectMake(0, self.navBackGround.bottom, ScreenWidth, ScreenHeight - kNavBarHeight_New);
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.alwaysBounceVertical = YES; //垂直方向添加弹簧效果
    [self.view addSubview:self.scrollView];
    
    
    // 昵称的View
    UIView * nickNameView = [[UIView alloc]init];
    nickNameView.size = [UIView getSize_width:ScreenWidth height:63];
    nickNameView.left = 0;
    nickNameView.top = 12;
    nickNameView.backgroundColor = ColorThemeBackground;
    [self.scrollView addSubview:nickNameView];
    
    
    
    self.nickNameTextField = [[UITextField alloc]init];
    self.nickNameTextField.size = [UIView getSize_width:ScreenWidth-12*2 height:20];
    self.nickNameTextField.top = (nickNameView.height - self.nickNameTextField.height)/2;
    self.nickNameTextField.left = 12;
    self.nickNameTextField.delegate = self;
    self.nickNameTextField.font = [UIFont defaultFontWithSize:14];
    self.nickNameTextField.borderStyle = UITextBorderStyleNone;
    self.nickNameTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    self.nickNameTextField.placeholder = @"请填写一句话介绍";
    self.nickNameTextField.text = [GlobalData sharedInstance].loginDataModel.signature;
    self.nickNameTextField.textColor = [UIColor whiteColor];
    [nickNameView addSubview:self.nickNameTextField];
    [self.nickNameTextField becomeFirstResponder];
    
    
    
    //test
    nickNameView.backgroundColor = MTColorCellHighlighted;
    
    [self.scrollView addSubView:self.btnSave frameBottomView:nickNameView offset:100];
}

-(void)btnSaveClcik:(UIButton *)btn{
    
    NSString *signature = self.nickNameTextField.text.trim;
    if(signature.length > 0){
        
        UpdateNoodleAccountContentModel *model = [[UpdateNoodleAccountContentModel alloc] init];
        model.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        model.nickname = [GlobalData sharedInstance].loginDataModel.nickname;
        model.sex = [GlobalData sharedInstance].loginDataModel.sex;
        model.birthday = [GlobalData sharedInstance].loginDataModel.birthday;
        model.school = [GlobalData sharedInstance].loginDataModel.school;
        model.department = [GlobalData sharedInstance].loginDataModel.department;
        model.enrolmentTime = [GlobalData sharedInstance].loginDataModel.enrolmentTime;
        model.company = [GlobalData sharedInstance].loginDataModel.company;
        model.signature = signature;
        model.city = [GlobalData sharedInstance].loginDataModel.city;
        model.addr = [GlobalData sharedInstance].loginDataModel.addr;
        model.country = [GlobalData sharedInstance].loginDataModel.country;
        
        NetWork_mt_updateNoodleAccount *request = [[NetWork_mt_updateNoodleAccount alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.content = [model generateJsonStringForProperties];
        [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
            if(finished){
                NSLog(@"-------");
                
                LoginModel *tempModel = [GlobalData sharedInstance].loginDataModel;
                tempModel.signature = signature;
                [GlobalData sharedInstance].loginDataModel = tempModel;
                
                //用户信息修改成功发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationUserInfoChange
                                                                    object:nil];
                
                [self backBtnClick:nil]; //修改成功后返回
            }
            else{
                [UIWindow showTips:msg];
            }
        }];
    }
    else{
        [UIWindow showTips:@"昵称不能为空！"];
    }
}

-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
