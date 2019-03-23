//
//  DeliverArticleViewController.m
//  CMPLjhMobile
//
//  Created by 刘欣 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "PublishViewController.h"

#import "NetWork_mt_getUploadSignature.h"
#import "NetWork_mt_saveVideo.h"

#import "TXUGCPublish.h"

@interface PublishViewController ()<TXVideoPublishListener>

@end

@implementation PublishViewController

#pragma mark ------------- 懒加载  ----------

- (UITextView *) speakTextView{
    
    if (_progressView == nil){
        
        CGFloat textViewHeight = sizeScale(125);
        CGFloat videoWidth = textViewHeight/1.35f;
        
        _speakTextView = [[UITextView alloc] init];
        _speakTextView.backgroundColor = ColorThemeBackground; //ColorThemeBackground;
        _speakTextView.frame = CGRectMake(10, 0,self.scrollView.width-videoWidth - 30, sizeScale(125));
        _speakTextView.delegate = self;
        _speakTextView.textColor = ColorWhite;
        _speakTextView.returnKeyType = UIReturnKeyDone;
        _speakTextView.font = [UIFont systemFontOfSize:16.0];
        [_speakTextView becomeFirstResponder];
    }
    
    return _speakTextView;
}

- (UILabel *) placeHoldelLebel{
    
    if (_placeHoldelLebel == nil){
        
        _placeHoldelLebel = [[UILabel alloc]init];
        _placeHoldelLebel.frame = [UIView getScaleFrame_x:10 y:0 width:100 height:30];
        _placeHoldelLebel.text = @"这一刻我想说......";
        _placeHoldelLebel.textColor = ColorWhiteAlpha60;
        _placeHoldelLebel.font = [UIFont systemFontOfSize:16.0];
    }
    
    return _placeHoldelLebel;
}

- (UIImageView*)imageViewCover{
    
    if (!_imageViewCover) {
        
        CGFloat textViewHeight = sizeScale(125)-30;
        CGFloat videoWidth = textViewHeight/1.35f;
        
        
        _imageViewCover = [[UIImageView alloc] init];
        _imageViewCover.size = [UIView getSize_width:videoWidth height:textViewHeight];
        _imageViewCover.left = self.speakTextView.right + 10;
        _imageViewCover.top = 15;
        _imageViewCover.backgroundColor = RGBA(54, 58, 67, 1);
        _imageViewCover.userInteractionEnabled  =   YES;
        _imageViewCover.layer.cornerRadius = 5;
        _imageViewCover.layer.masksToBounds = YES;
        _imageViewCover.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _imageViewCover;
}



- (UIButton*)btnTopic{
    
    if (!_btnTopic) {
        _btnTopic = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTopic.size = [UIView getSize_width:60 height:25];
        _btnTopic.origin = [UIView getPoint_x:sizeScale(15) y:self.speakTextView.bottom];
        [_btnTopic setBackgroundColor:MTColorBtnNormal forState:UIControlStateNormal];
        [_btnTopic setBackgroundColor:MTColorBtnHighlighted forState:UIControlStateHighlighted];
        _btnTopic.titleLabel.font = [UIFont defaultBoldFontWithSize:13];
        [_btnTopic setTitle:@"#话题" forState:UIControlStateNormal];
        _btnTopic.layer.cornerRadius = 2.0f;
        [_btnTopic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnTopic.layer.masksToBounds = true;//给按钮添加边框效果
        [_btnTopic addTarget:self action:@selector(btnAddTopic:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnTopic;
}

- (UIButton*)btnAFriend{
    
    if (!_btnAFriend) {
        _btnAFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAFriend.size = [UIView getSize_width:60 height:25];
        _btnAFriend.origin = [UIView getPoint_x:self.btnTopic.right+sizeScale(15) y:self.speakTextView.bottom];
        [_btnAFriend setBackgroundColor:MTColorBtnNormal forState:UIControlStateNormal];
        [_btnAFriend setBackgroundColor:MTColorBtnHighlighted forState:UIControlStateHighlighted];
        _btnAFriend.titleLabel.font = [UIFont defaultBoldFontWithSize:13];
        [_btnAFriend setTitle:@"@好友" forState:UIControlStateNormal];
        [_btnAFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnAFriend.layer.cornerRadius = 2.0f;
        _btnAFriend.layer.masksToBounds = true;//给按钮添加边框效果
        [_btnAFriend addTarget:self action:@selector(btnAFriend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAFriend;
}

- (TCBGMProgressView *) progressView{
    
    if (_progressView == nil){
        
        CGRect frame = CGRectMake(self.speakTextView.left, self.btnTopic.bottom, self.scrollView.width, 3.0f);
        
        _progressView = [[TCBGMProgressView alloc] initWithFrame:frame];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.progressBackgroundColor = [UIColor yellowColor];
        _progressView.hidden = YES;
    }
    
    return _progressView;
}

- (UIButton *)btnLocation{
    
    if (!_btnLocation) {
        
        _btnLocation =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLocation setBackgroundColor:ColorThemeBackground forState:UIControlStateNormal];
        [_btnLocation setBackgroundColor:MTColorBtnNormal forState:UIControlStateHighlighted];
        _btnLocation.size = [UIView getSize_width:ScreenWidth height:sizeScale(40)];
        _btnLocation.top = self.btnTopic.bottom + sizeScale(12);
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_m_location"]];
        imgView.size = [UIView getScaleSize_width:14 height:14];
        imgView.origin = [UIView getPoint_x:15 y:(_btnLocation.height - imgView.height)/2];
        [_btnLocation addSubview:imgView];
        
        
        UILabel *titleLalbe = [[UILabel alloc] init];
        titleLalbe.font = [UIFont defaultBoldFontWithSize:13];
        titleLalbe.textColor = ColorWhite;
        titleLalbe.size = [UIView getSize_width:150 height:30];
        titleLalbe.origin = [UIView getPoint_x:imgView.right+15
                                             y:(_btnLocation.height - titleLalbe.height)/2];
        titleLalbe.text = @"添加位置";
        [_btnLocation addSubview:titleLalbe];
        
        
        UIImageView *narrowImg= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_m_s_right"]];
        narrowImg.size = [UIView getSize_width:9 height:15];
        narrowImg.origin = [UIView getPoint_x:ScreenWidth - narrowImg.width - 15
                                            y:(_btnLocation.height - narrowImg.height)/2];
        [_btnLocation addSubview:narrowImg];
    }
    return  _btnLocation;
}

- (UIButton *)btnDraft{
    
    if (!_btnDraft) {
        
        _btnDraft =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDraft setBackgroundColor:MTColorBtnNormal forState:UIControlStateNormal];
        [_btnDraft setBackgroundColor:MTColorBtnHighlighted forState:UIControlStateHighlighted];
        _btnDraft.size = [UIView getSize_width:sizeScale(150) height:sizeScale(35)];
        _btnDraft.right = self.scrollView.width/2 - 5;
        _btnDraft.bottom = self.scrollView.height - 50;
        _btnDraft.layer.cornerRadius = 2.0f;
        _btnDraft.layer.masksToBounds = true;//给按钮添加边框效果
        
        UIImageView *imageIcon = [[UIImageView alloc] init];
        imageIcon.size = [UIView getSize_width:sizeScale(12.5) height:sizeScale(12.5)];
        imageIcon.origin = [UIView getPoint_x:(_btnDraft.width - imageIcon.width)/2 - imageIcon.width-2
                                            y:(_btnDraft.height - imageIcon.height)/2];
        imageIcon.image = [UIImage imageNamed:@"icon_home_all_share_collention"];
        
        UILabel *lableCollectionTitle = [[UILabel alloc] init];
        lableCollectionTitle.size = [UIView getSize_width:_btnDraft.width/2 height:_btnDraft.height];
        lableCollectionTitle.origin = [UIView getPoint_x:imageIcon.right+5 y:0];
        lableCollectionTitle.textColor = [UIColor whiteColor];
        lableCollectionTitle.textAlignment = NSTextAlignmentLeft;
        lableCollectionTitle.text = @"草稿";
        lableCollectionTitle.font = [UIFont defaultBoldFontWithSize:14];
        
        [_btnDraft addSubview:imageIcon];
        [_btnDraft addSubview:lableCollectionTitle];
    }
    return  _btnDraft;
}

- (UIButton *)btnSave{
    
    if (!_btnSave) {
        
        _btnSave =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSave setBackgroundColor:MTColorBtnRedNormal forState:UIControlStateNormal];
        [_btnSave setBackgroundColor:MTColorBtnRedHighlighted forState:UIControlStateHighlighted];
        _btnSave.size = [UIView getSize_width:sizeScale(150) height:sizeScale(35)];
        _btnSave.left = self.scrollView.width/2 + 5;
        _btnSave.bottom = self.scrollView.height - 50;
        _btnSave.layer.cornerRadius = 2.0f;
        
        _btnSave.layer.masksToBounds = true;//给按钮添加边框效果
        [_btnSave addTarget:self action:@selector(btnSaveClcik) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageIcon = [[UIImageView alloc] init];
        imageIcon.size = [UIView getSize_width:sizeScale(12.5) height:sizeScale(12.5)];
        imageIcon.origin = [UIView getPoint_x:(_btnDraft.width - imageIcon.width)/2 - imageIcon.width-2
                                            y:(_btnDraft.height - imageIcon.height)/2];
        imageIcon.image = [UIImage imageNamed:@"icon_home_all_share_collention"];
        
        UILabel *lableCollectionTitle = [[UILabel alloc] init];
        lableCollectionTitle.size = [UIView getSize_width:_btnDraft.width/2 height:_btnDraft.height];
        lableCollectionTitle.origin = [UIView getPoint_x:imageIcon.right+5 y:0];
        lableCollectionTitle.textColor = [UIColor whiteColor];
        lableCollectionTitle.textAlignment = NSTextAlignmentLeft;
        lableCollectionTitle.text = @"发布";
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
    self.btnLeft = leftButton;
    
    //    UIButton * rightBarButton = [[UIButton alloc]init];
    //
    //    rightBarButton.size = [UIView getSize_width:50 height:50];
    //    rightBarButton.right = self.navBackGround.width - 5;
    //    rightBarButton.bottom = self.navBackGround.bottom ;
    //    [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    rightBarButton.titleLabel.font = [UIFont defaultBoldFontWithSize:16];;
    //    [rightBarButton setTitle:@"保存" forState:UIControlStateNormal];
    //    [rightBarButton addTarget:self action:@selector(btnClcik) forControlEvents:UIControlEventTouchUpInside];
    //    self.btnRight = rightBarButton;
    
    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.left = 0;
    viewLine.size = [UIView getSize_width:ScreenWidth - viewLine.left height:0.6];
    viewLine.bottom = self.navBackGround.height - viewLine.height;
    viewLine.backgroundColor = MTColorLine;
    [self.navBackGround addSubview:viewLine];
    
    self.title = @"发布视频";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    self.imageViewCover.image = [UIImage imageWithContentsOfFile:self.videoOutputCoverPath];
}

#pragma -mark  initUI---

-(void)setupUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    
    CGRect frame = CGRectMake(0, self.navBackGround.bottom, ScreenWidth, ScreenHeight - kNavBarHeight_New);
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.alwaysBounceVertical = YES; //垂直方向添加弹簧效果
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.speakTextView];
    [self.speakTextView addSubview:self.placeHoldelLebel];
    [self.scrollView addSubview:self.imageViewCover];
    
    [self.scrollView addSubview:self.progressView];
    [self.scrollView addSubview:self.btnTopic];
    [self.scrollView addSubview:self.btnAFriend];
    [self.scrollView addSubview:self.btnLocation];
    [self.scrollView addSubview:self.btnDraft];
    [self.scrollView addSubview:self.btnSave];
    
    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.left = 0;
    viewLine.size = [UIView getSize_width:ScreenWidth - viewLine.left height:0.4];
    viewLine.bottom = self.btnTopic.bottom + 10;
    viewLine.backgroundColor = MTColorLine;
    
    [self.scrollView addSubview:viewLine];
    
}

#pragma mark ----------  UITextViewDelegate  -------------

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeHoldelLebel.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeHoldelLebel.hidden = NO;
    }
}

#pragma mark ----------  btnClick  -------------

-(void)btnSaveClcik{
    
    NSString *strContent = self.speakTextView.text.trim;

    
    NetWork_mt_getUploadSignature *request = [[NetWork_mt_getUploadSignature alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    [request showWaitMsg:@"正在获取签名" handle:self];
    [request startGetWithBlock:^(GetUploadSignatureResponse *result, NSString *msg, BOOL finished) {
        
        if(finished){
            
            
            TXPublishParam * param = [[TXPublishParam alloc] init];
            param.signature = result.obj;                                // 需要填写第四步中计算的上传签名
            // 录制生成的视频文件路径 TXVideoRecordListener 的 onRecordComplete 回调中可以获取
            param.videoPath = self.videoPath;
            // 录制生成的视频首帧预览图路径。值为通过调用startRecord指定的封面路径，或者指定一个路径，然后将TXVideoRecordListener 的 onRecordComplete 回调中获取到的UIImage保存到指定路径下，可以置为 nil。
            param.coverPath = self.videoOutputCoverPath; //_coverPath;
            TXUGCPublish *_ugcPublish = [[TXUGCPublish alloc] init];
            // 文件发布默认是采用断点续传
            _ugcPublish.delegate = self;                                 // 设置 TXVideoPublishListener 回调
            [_ugcPublish publishVideo:param];
        }
        else{
            [self showFaliureHUD:@"获取签名失败"];
        }
        
    }];
}

-(void)btnAddTopic:(UIButton*)btn{
    NSLog(@"------添加话题 ---s");
}

-(void)btnAFriend:(UIButton*)btn{
    NSLog(@"------@好友 ---s");
}


#pragma mark ----------  TXVideoPublishListener 上传腾讯云 进度  -------------

-(void) onPublishProgress:(uint64_t)uploadBytes totalBytes: (uint64_t)totalBytes{
    
    CGFloat progress = (float)uploadBytes / totalBytes;
    if(progress == 0.0f){
        self.progressView.hidden = YES;
    }
    else{
        self.progressView.hidden = NO;
        self.progressView.progress = progress;
    }
    
}

-(void) onPublishComplete:(TXPublishResult*)result{
    
    NSString *strContent = self.speakTextView.text.trim;
    SaveVideoContentModel *model = [[SaveVideoContentModel alloc] init];
    model.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    model.nickname = [GlobalData sharedInstance].loginDataModel.nickname;
    model.fileId = result.videoId;
    model.noodleVideoCover = result.coverURL;
    model.storagePath = result.videoURL;
    model.noodleVideoName = [result.videoURL lastPathComponent];
    model.musicId = [NSString stringWithFormat:@"%@",self.musicModel.musicId];
    model.musicName = self.musicModel.musicName;
    model.musicUrl = self.musicModel.playUrl;
    model.coverUrl = self.musicModel.coverUrl;
    //    model.addr = @"北京市朝阳区北苑路180号";
    model.size = @"720p";
    model.title = strContent;
    //    model.topic = @"#万圣节";
    
    NetWork_mt_saveVideo *request = [[NetWork_mt_saveVideo alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.content = [model generateJsonStringForProperties];
    [request showWaitMsg:@"正在发布" handle:self];
    [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
        if(finished){
            [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:1];
        }
        else{
            [UIWindow showTips:@"视频上传失败，请稍再试。"];
        }
    }];
}

- (void)dismissViewController{
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}



@end
