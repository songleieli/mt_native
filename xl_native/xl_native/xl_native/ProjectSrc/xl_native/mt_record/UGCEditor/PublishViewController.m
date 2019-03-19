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



-(void)initNavTitle{
    self.isNavBackGroundHiden = NO;
    
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft = leftButton;
    
    UIButton * rightBarButton = [[UIButton alloc]init];
//    rightBarButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];

    rightBarButton.size = [UIView getSize_width:50 height:50];
    rightBarButton.right = self.navBackGround.width - 5;
    rightBarButton.bottom = self.navBackGround.bottom - 5;
    [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = [UIFont defaultFontWithSize:17];
    //    rightBarButton.titleLabel.textColor = [UIColor whiteColor] ;
    rightBarButton.enabled = YES;
    [rightBarButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(btnClcik) forControlEvents:UIControlEventTouchUpInside];
    self.btnRight = rightBarButton;
    
    self.title = @"发布视频";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma -mark  initUI---

-(void)setupUI{
    
    self.view.backgroundColor = ColorThemeBackground;

    CGRect frame = CGRectMake(0, self.navBackGround.bottom, ScreenWidth, ScreenHeight - kNavBarHeight_New);
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
//    self.scrollView.alwaysBounceHorizontal = YES; // 垂直
    self.scrollView.alwaysBounceVertical = YES; // 水平
    


//    self.scrollView.contentSize = [UIView getSize_width:self.scrollView.width height:self.scrollView.height+1];
    
    [self.view addSubview:self.scrollView];
    
    self.speakTextView = [[UITextView alloc] init];
    self.speakTextView.frame = CGRectMake(0, 0,self.scrollView.width, sizeScale(125));
    self.speakTextView.delegate = self;
    self.speakTextView.returnKeyType = UIReturnKeyDefault;
    self.speakTextView.font = [UIFont systemFontOfSize:16.0];
    [self.scrollView addSubview:self.speakTextView];
    
    
    self.placeHoldelLebel = [[UILabel alloc]init];
    self.placeHoldelLebel.frame = [UIView getScaleFrame_x:10 y:0 width:100 height:30];
    self.placeHoldelLebel.text = @"这一刻我想说......";
    self.placeHoldelLebel.textColor = [UIColor lightGrayColor];
    self.placeHoldelLebel.font = [UIFont systemFontOfSize:14];
    [self.speakTextView addSubview:self.placeHoldelLebel];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeHoldelLebel.hidden = YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeHoldelLebel.hidden = NO;
    }
}


-(void)btnClcik{
    NSLog(@"发表视频");
    
    
    
    
    
    
    NetWork_mt_getUploadSignature *request = [[NetWork_mt_getUploadSignature alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    [request showWaitMsg:@"正在获取签名" handle:self];
    [request startGetWithBlock:^(GetUploadSignatureResponse *result, NSString *msg, BOOL finished) {
        
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
        
    }];
    
    
    
}


#pragma mark - TXVideoPublishListener

-(void) onPublishProgress:(uint64_t)uploadBytes totalBytes: (uint64_t)totalBytes{
    
//    _generateProgressView.progress = (float)uploadBytes / totalBytes;
    
}

-(void) onPublishComplete:(TXPublishResult*)result{
    
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
    model.addr = @"北京市朝阳区北苑路180号";
    model.size = @"720p";
    model.title = @"songlei 发布内容测试";
    model.topic = @"#万圣节";
    
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



@end
