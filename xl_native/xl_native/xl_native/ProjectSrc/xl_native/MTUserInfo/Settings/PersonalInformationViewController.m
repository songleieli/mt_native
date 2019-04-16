//
//  PersonalInformationViewController.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/24.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "PersonalInformationViewController.h"

#import "NickNameViewController.h"
#import "IntroduceViewController.h"


//#import "NetWork_uploadApi.h"
//#import "NetWork_uploadIcon.h"


@interface PersonalInformationViewController ()<UIAlertViewDelegate>

@property(nonatomic,strong) UIImageView * loginIconImageView;
@property(nonatomic,strong) UILabel * labelNickName;
@property(nonatomic,strong) UILabel * labelIntrduce;
@property(nonatomic,strong) UIView * nicknameView;
@property(nonatomic,strong) UIImageView * nicknameArrowImageView;
@property(nonatomic,strong) UIScrollView * scrollBg;



@end

@implementation PersonalInformationViewController

-(void)dealloc{
    
    NSLog(@"---------------%@ dealloc ",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotificationUserInfoChange
                                                  object:nil];
}

-(void)registerForRemoteNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeUserInfo:)
                                                 name:NSNotificationUserInfoChange
                                               object:nil];
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
    
    self.title = @"编辑个人资料";
}

- (void)viewDidLoad {
    self.isNavBackGroundHiden = NO;
    
    [super viewDidLoad];
    [self registerForRemoteNotification];
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
    iconView.size = [UIView getSize_width:ScreenWidth height:sizeScale(45)];
    iconView.origin =[UIView getPoint_x:0 y:12];
    [self.scrollBg addSubview:iconView];
    
    UILabel * lableLine = [[UILabel alloc]init];
    lableLine.backgroundColor = RGBA(132, 135, 144, 0.6);
    lableLine.left = 15;
    lableLine.width = ScreenWidth-15*2;
    lableLine.height = 0.5;
    lableLine.top = iconView.height-lableLine.height;
    [iconView addSubview:lableLine];
    
    UILabel * labelIcon = [[UILabel alloc]init];
    labelIcon.font = MediumBoldFont;
    labelIcon.textColor = [UIColor whiteColor];
    labelIcon.text = @"头像";
    
    CGSize labelIconSize = [labelIcon.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:labelIcon.font,NSFontAttributeName, nil]];
    labelIcon.size = [UIView getSize_width:labelIconSize.width height:labelIconSize.height];
    labelIcon.left = 21;
    labelIcon.top = (iconView.height - labelIcon.height)/2;
    [iconView addSubview:labelIcon];
    
    UIImageView * arrowImageView = [[UIImageView alloc]init];
    arrowImageView.size = [UIView getSize_width:5 height:10];
    arrowImageView.top = (iconView.height - arrowImageView.height)/2;
    arrowImageView.left = iconView.width - 21 - arrowImageView.width;
    arrowImageView.image = [UIImage imageNamed:@"command_left"];
    [iconView addSubview:arrowImageView];
    
    //  用户头像
    self.loginIconImageView = [[UIImageView alloc]init];
    self.loginIconImageView.userInteractionEnabled = YES;
    self.loginIconImageView.size = [UIView getSize_width:33 height:33];
    self.loginIconImageView.top = (iconView.height - self.loginIconImageView.height)/2;
    self.loginIconImageView.left = ScreenWidth - arrowImageView.width - 8 -self.loginIconImageView.width-21;
    CALayer * loginIconImageViewLayer = [self.loginIconImageView layer];
    [loginIconImageViewLayer setMasksToBounds:YES];
    [loginIconImageViewLayer setCornerRadius:self.loginIconImageView.width/2];
    self.loginIconImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginIconImageViewClcik:)];
    [self.loginIconImageView addGestureRecognizer:tap];
    
    [iconView addSubview:self.loginIconImageView];
    // 昵称
    self.nicknameView = [[UIView alloc]init];
    self.nicknameView.size = [UIView getSize_width:ScreenWidth height:sizeScale(45)];
    self.nicknameView.origin =[UIView getPoint_x:0 y:iconView.bottom];
    [self.scrollBg addSubview:self.nicknameView];
    
    UILabel * labelLoginIcon = [[UILabel alloc]init];
    labelLoginIcon.font = MediumBoldFont;
    labelLoginIcon.textColor = [UIColor whiteColor];
    labelLoginIcon.text = @"昵称";
    CGSize lableNicknameSize = [labelLoginIcon.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:labelLoginIcon.font,NSFontAttributeName, nil]];
    
    labelLoginIcon.size = [UIView getSize_width:lableNicknameSize.width height:lableNicknameSize.height];
    labelLoginIcon.left = 21;
    labelLoginIcon.top = (self.nicknameView.height - labelLoginIcon.height)/2;
    [self.nicknameView addSubview:labelLoginIcon];
    
    self.nicknameArrowImageView = [[UIImageView alloc]init];
    self.nicknameArrowImageView.size = [UIView getSize_width:5 height:10];
    self.nicknameArrowImageView.top = (self.nicknameView.height - self.nicknameArrowImageView.height)/2;
    self.nicknameArrowImageView.left = self.nicknameView.width - 21 - self.nicknameArrowImageView.width;
    self.nicknameArrowImageView.image = [UIImage imageNamed:@"command_left"];
    [self.nicknameView addSubview:self.nicknameArrowImageView];
    
    self.labelNickName = [[UILabel alloc]init];
    self.labelNickName.userInteractionEnabled = YES;
    self.labelNickName.textAlignment = NSTextAlignmentRight;
    self.labelNickName.font = MediumFont;
    self.labelNickName.textColor = ColorWhiteAlpha80;
    [self.nicknameView addSubview:self.labelNickName];
    
    UIButton * buttonClear = [[UIButton alloc]init];
    buttonClear.size = [UIView getSize_width:200 height:self.nicknameView.height];
    buttonClear.origin = [UIView getPoint_x:ScreenWidth-200 y:0];
    [buttonClear addTarget:self action:@selector(nickNameClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.nicknameView addSubview:buttonClear];
    
    UILabel * lableLineNickName = [[UILabel alloc]init];
    lableLineNickName.backgroundColor = RGBA(132, 135, 144, 0.6);
    lableLineNickName.left = 15;
    lableLineNickName.width = ScreenWidth-15*2;
    lableLineNickName.height = 0.5;
    lableLineNickName.top = self.nicknameView.height-lableLineNickName.height;
    
    [self.nicknameView addSubview:lableLineNickName];
    
    
    //编辑资料
    UIView * viewIntroduce = [[UIView alloc]init];
    viewIntroduce.size   =[UIView getSize_width:ScreenWidth height:sizeScale(45)];
    viewIntroduce.origin =[UIView getPoint_x:0 y:self.nicknameView.bottom];
    [self.scrollBg addSubview:viewIntroduce];
    
    UILabel * lablescan = [[UILabel alloc]init];
    lablescan.font = MediumBoldFont;
    lablescan.textColor = [UIColor whiteColor];
    lablescan.text = @"签名";
    lablescan.left = 21;
    lablescan.top = 0;
    lablescan.size = [UIView getSize_width:100 height:viewIntroduce.height];
    [viewIntroduce addSubview:lablescan];
    
    self.labelIntrduce = [[UILabel alloc]init];
    self.labelIntrduce.userInteractionEnabled = YES;
    self.labelIntrduce.textAlignment = NSTextAlignmentRight;
    self.labelIntrduce.font = MediumFont;
    self.labelIntrduce.textColor = ColorWhiteAlpha80;
    [viewIntroduce addSubview:self.labelIntrduce];
    
    
    UIImageView * scanArrowImageView = [[UIImageView alloc]init];
    scanArrowImageView.size = [UIView getSize_width:5 height:10];
    scanArrowImageView.top = (viewIntroduce.height - scanArrowImageView.height)/2;
    scanArrowImageView.left = viewIntroduce.width - 21 - scanArrowImageView.width;
    scanArrowImageView.image = [UIImage imageNamed:@"command_left"];
    [viewIntroduce addSubview:scanArrowImageView];
    
    UIButton * btnEditInfo = [[UIButton alloc]init];
    btnEditInfo.size = [UIView getSize_width:viewIntroduce.width height:viewIntroduce.height];
    btnEditInfo.origin = [UIView getPoint_x:0 y:0];
    btnEditInfo.tag = 9010;
    [btnEditInfo addTarget:self action:@selector(introduceClcik) forControlEvents:UIControlEventTouchUpInside];
    [viewIntroduce addSubview:btnEditInfo];
    
    UILabel * lableLineEditInfo = [[UILabel alloc]init];
    lableLineEditInfo.backgroundColor = RGBA(132, 135, 144, 0.6);
    lableLineEditInfo.left = 15;
    lableLineEditInfo.width = ScreenWidth-15*2;
    lableLineEditInfo.height = 0.5;
    lableLineEditInfo.top = viewIntroduce.height-lableLineEditInfo.height;
    [viewIntroduce addSubview:lableLineEditInfo];
}



//每次进入界面，从userAccount中拿值，刷新界面的值
-(void)updateUser {
    
    [self.loginIconImageView sd_setImageWithURL:[NSURL URLWithString:[GlobalData sharedInstance].loginDataModel.head]
                               placeholderImage:[UIImage imageNamed:@"img_find_default"]]; //默认头像
    //  昵称
    if ([GlobalData sharedInstance].loginDataModel.nickname.length == 0) {
        self.labelNickName.text = @"";
    }else{
        self.labelNickName.text = [GlobalData sharedInstance].loginDataModel.nickname;
    }
    
    CGRect nameLabelSize = [self.labelNickName.text boundingRectWithSize:CGSizeMake(1000, self.nicknameView.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelNickName.font,NSFontAttributeName, nil] context:nil];
    
    self.labelNickName.size = [UIView getSize_width:nameLabelSize.size.width height:self.nicknameView.height];
    self.labelNickName.top = (self.nicknameView.height - self.labelNickName.height)/2;
    self.labelNickName.left = self.nicknameArrowImageView.left -8-self.labelNickName.width;
    
    
    //  一句话签名
    if ([GlobalData sharedInstance].loginDataModel.signature.length == 0) {
        self.labelIntrduce.text = @"";
    }else{
        self.labelIntrduce.text = [GlobalData sharedInstance].loginDataModel.signature;
    }
    
    CGRect introduceLabelSize = [self.labelIntrduce.text boundingRectWithSize:CGSizeMake(1000, self.nicknameView.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelNickName.font,NSFontAttributeName, nil] context:nil];
    
    self.labelIntrduce.size = [UIView getSize_width:introduceLabelSize.size.width height:self.nicknameView.height];
    self.labelIntrduce.top = (self.nicknameView.height - self.labelNickName.height)/2;
    self.labelIntrduce.left = self.nicknameArrowImageView.left -8-self.labelNickName.width;
    self.labelIntrduce.right = ScreenWidth - 35;
    
}

-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [[GlobalFunc sharedInstance] localPhoto:self];
            break;
        case 1:
            [[GlobalFunc sharedInstance] takePhoto:self];
            break;
        default:
            break;
    }
}




#pragma mark - 选择图片后返回图片列表

- (void)selectedImages:(NSArray*)images{
    
    
    NSString *key = [GlobalFunc getCurrentTime];
    
    NSMutableDictionary *fileDic = [[NSMutableDictionary alloc]init];
    for(UIImage *image in images){
        
        NSData *imageData = nil;
        int max = image.size.height > image.size.width ? image.size.height : image.size.width;
        float alpha = 1;
        if (max>700) {
            alpha = 700.0 / (float)max;
        }
        
        imageData = UIImageJPEGRepresentation([GlobalFunc scaleToSizeAlpha:image alpha:alpha], 0.5);
        [fileDic setObject:imageData forKey:key];
    }
    
    if(fileDic.allKeys.count > 0){
        
        
        NSData *imageData = [fileDic objectForKey:key];
        NSMutableDictionary *fileDic = [[NSMutableDictionary alloc]init];
        [fileDic setObject:imageData forKey:@"head"];
        
        NetWork_mt_updateNoodelHead *request = [[NetWork_mt_updateNoodelHead alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.uploadFilesDic = fileDic;
        [request startPostWithBlock:^(UpdateNoodelHeadResponse *result, NSString *msg, BOOL finished) {
            NSLog(@"头像修改成功");
            
            if(finished){
                [self.loginIconImageView sd_setImageWithURL:[NSURL URLWithString:result.obj.trim]
                                           placeholderImage:[UIImage imageNamed:@"img_find_default"]]; //默认头像
                
                LoginModel *tempModel = [GlobalData sharedInstance].loginDataModel;
                tempModel.head = result.obj.trim;
                [GlobalData sharedInstance].loginDataModel = tempModel;
                
                //用户信息修改成功发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationUserInfoChange
                                                                    object:nil];
            }
            else{
                [UIWindow showTips:msg];
            }
            
        }];
    }
}
//事件处理
-(void)loginIconImageViewClcik:(UIGestureRecognizer *)tap{
    
    
    /*
    *  如果要实现ActionSheet的效果，这里的preferredStyle应该设置为UIAlertControllerStyleActionSheet，而不是UIAlertControllerStyleAlert；
    */
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    
    /**
     *  style参数：
     UIAlertActionStyleDefault,
     UIAlertActionStyleCancel,
     UIAlertActionStyleDestructive（默认按钮文本是红色的）
     *
     */
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"拍一张" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [[GlobalFunc sharedInstance] takePhoto:self];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [[GlobalFunc sharedInstance] localPhoto:self];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(void)nickNameClcik{
    
    NickNameViewController * nickNameViewController = [[NickNameViewController alloc]init];
    [self pushNewVC:nickNameViewController animated:YES];
//    [self.navigationController pushViewController:nickNameViewController animated:YES];
}

-(void)introduceClcik{
    
    IntroduceViewController * introduceViewController = [[IntroduceViewController alloc]init];
    [self pushNewVC:introduceViewController animated:YES];
//    [self.navigationController pushViewController:introduceViewController animated:YES];
}

#pragma mark ------------------ 通知 ---------------

-(void)changeUserInfo:(id)sender{
    [self updateUser];
}



@end
