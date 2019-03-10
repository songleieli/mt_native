//
//  PersonalInformationViewController.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/24.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "UserSettingViewController.h"

#import "NickNameViewController.h"
#import "IntroduceViewController.h"

@interface UserSettingViewController ()<UIAlertViewDelegate>

@property(nonatomic,strong) UIImageView * loginIconImageView;
@property(nonatomic,strong) UILabel * labelNickName;
@property(nonatomic,strong) UILabel * labelNoodle;
@property(nonatomic,strong) UIView * nicknameView;
@property(nonatomic,strong) UIScrollView * scrollBg;



@end

@implementation UserSettingViewController

-(void)dealloc{
    
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
    
    self.title = @"更多设置";
}

- (void)viewDidLoad {
    self.isNavBackGroundHiden = NO;
    
    [super viewDidLoad];
    [self creatUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUser];
    
}
-(void)creatUI{
    self.view.backgroundColor = ColorThemeBackground;

    self.scrollBg = [[UIScrollView alloc] init];
    self.scrollBg.size = [UIView getSize_width:ScreenWidth height:ScreenHeight - kNavBarHeight_New];
    self.scrollBg.origin = [UIView getPoint_x:0 y:self.navBackGround.bottom];
    self.scrollBg.showsVerticalScrollIndicator = NO;
    self.scrollBg.alwaysBounceVertical = YES; //垂直弹簧效果，不需要设置contentSize
    [self.view addSubview:self.scrollBg];
    
    // 头像的view
    UIView * iconView = [[UIView alloc]init];
    iconView.size = [UIView getSize_width:ScreenWidth height:sizeScale(65)];
    iconView.origin =[UIView getPoint_x:0 y:12];
    [self.scrollBg addSubview:iconView];
    
    //  用户头像
    self.loginIconImageView = [[UIImageView alloc]init];
    self.loginIconImageView.userInteractionEnabled = YES;
    self.loginIconImageView.size = [UIView getSize_width:sizeScale(40) height:sizeScale(40)];
    self.loginIconImageView.top = (iconView.height - self.loginIconImageView.height)/2;
    self.loginIconImageView.left = 15;
    CALayer * loginIconImageViewLayer = [self.loginIconImageView layer];
    [loginIconImageViewLayer setMasksToBounds:YES];
    [loginIconImageViewLayer setCornerRadius:self.loginIconImageView.width/2];
    [iconView addSubview:self.loginIconImageView];

    self.labelNickName = [[UILabel alloc]init];
    self.labelNickName.textColor = ColorWhite;
    self.labelNickName.font = BigBoldFont;
    self.labelNickName.left = self.loginIconImageView.right + 15;
    self.labelNickName.width = 250;
    self.labelNickName.height = 25;
    self.labelNickName.bottom = iconView.height/2;
    [iconView addSubview:self.labelNickName];
    
    
    self.labelNoodle = [[UILabel alloc]init];
    self.labelNoodle.textColor = ColorWhite;
    self.labelNoodle.font = SmallFont;
    self.labelNoodle.left = self.loginIconImageView.right + 15;
    self.labelNoodle.width = 250;
    self.labelNoodle.height = 25;
    self.labelNoodle.top = self.labelNickName.bottom;
    [iconView addSubview:self.labelNoodle];
    
    
    UILabel * lableLine = [[UILabel alloc]init];
    lableLine.backgroundColor = RGBA(132, 135, 144, 0.6);
    lableLine.left = 15;
    lableLine.width = ScreenWidth-15*2;
    lableLine.height = 0.5;
    lableLine.top = iconView.height-lableLine.height;
    [iconView addSubview:lableLine];
    
    
    
    
    
    // 举报
    self.nicknameView = [[UIView alloc]init];
    self.nicknameView.size = [UIView getSize_width:ScreenWidth height:sizeScale(50)];
    self.nicknameView.origin =[UIView getPoint_x:0 y:iconView.bottom];
    [self.scrollBg addSubview:self.nicknameView];
    
    UIButton * buttonClear = [[UIButton alloc]init];
    buttonClear.frame = self.nicknameView.bounds;
    [buttonClear setBackgroundColor:RGBAlphaColor(29, 32, 42, 1) forState:UIControlStateHighlighted];
    [buttonClear addTarget:self action:@selector(reportClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.nicknameView addSubview:buttonClear];
    
    UILabel * labelLoginIcon = [[UILabel alloc]init];
    labelLoginIcon.font = BigBoldFont;
    labelLoginIcon.textColor = [UIColor whiteColor];
    labelLoginIcon.text = @"举报";
    labelLoginIcon.width = 250;
    labelLoginIcon.height = 25;
    labelLoginIcon.left = 21;
    labelLoginIcon.top = (self.nicknameView.height - labelLoginIcon.height)/2;
    [self.nicknameView addSubview:labelLoginIcon];
    
    
    
    UIImageView *arrowImageView = [[UIImageView alloc]init];
    arrowImageView.size = [UIView getSize_width:5 height:10];
    arrowImageView.top = (self.nicknameView.height - arrowImageView.height)/2;
    arrowImageView.left = self.nicknameView.width - 21 - arrowImageView.width;
    arrowImageView.image = [UIImage imageNamed:@"command_left"];
    [self.nicknameView addSubview:arrowImageView];

    

    
//    UILabel * lableLineNickName = [[UILabel alloc]init];
//    lableLineNickName.backgroundColor = RGBA(132, 135, 144, 0.6);
//    lableLineNickName.left = 15;
//    lableLineNickName.width = ScreenWidth-15*2;
//    lableLineNickName.height = 0.5;
//    lableLineNickName.top = self.nicknameView.height-lableLineNickName.height;
//
//    [self.nicknameView addSubview:lableLineNickName];
    
    
    //编辑资料
    UIView * viewIntroduce = [[UIView alloc]init];
    viewIntroduce.size   =[UIView getSize_width:ScreenWidth height:sizeScale(50)];
    viewIntroduce.origin =[UIView getPoint_x:0 y:self.nicknameView.bottom];
    [self.scrollBg addSubview:viewIntroduce];
    
    UIButton * btnDefriend = [[UIButton alloc]init];
    [btnDefriend setBackgroundColor:RGBAlphaColor(29, 32, 42, 1) forState:UIControlStateHighlighted];
    btnDefriend.frame = viewIntroduce.bounds;
    btnDefriend.tag = 9010;
    [btnDefriend addTarget:self action:@selector(defriendClcik) forControlEvents:UIControlEventTouchUpInside];
    [viewIntroduce addSubview:btnDefriend];
    
    UILabel * lablescan = [[UILabel alloc]init];
    lablescan.font = [UIFont defaultFontWithSize:sizeScale(14)];
    lablescan.textColor = [UIColor whiteColor];
    lablescan.text = @"拉黑";
    lablescan.left = 21;
    lablescan.top = 0;
    lablescan.size = [UIView getSize_width:100 height:viewIntroduce.height];
    [viewIntroduce addSubview:lablescan];
    
    
    UIImageView * scanArrowImageView = [[UIImageView alloc]init];
    scanArrowImageView.size = [UIView getSize_width:5 height:10];
    scanArrowImageView.top = (viewIntroduce.height - scanArrowImageView.height)/2;
    scanArrowImageView.left = viewIntroduce.width - 21 - scanArrowImageView.width;
    scanArrowImageView.image = [UIImage imageNamed:@"command_left"];
    [viewIntroduce addSubview:scanArrowImageView];
    


}



//每次进入界面，从userAccount中拿值，刷新界面的值
-(void)updateUser {
    
    if(self.user){
            [self.loginIconImageView sd_setImageWithURL:[NSURL URLWithString:self.user.head]
                                       placeholderImage:[UIImage imageNamed:@"img_find_default"]]; //默认头像
        //  昵称
        if (self.user.nickname.length == 0) {
            self.labelNickName.text = @"";
        }else{
            self.labelNickName.text = self.user.nickname;
        }
        
        self.labelNoodle.text = [NSString stringWithFormat:@"面条号:%@",self.user.noodleId];
    }

}

-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)reportClcik{
    UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定举报该用户？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [msgbox show];
}

-(void)defriendClcik{
    
    UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定拉黑该用户？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [msgbox show];
}

@end
