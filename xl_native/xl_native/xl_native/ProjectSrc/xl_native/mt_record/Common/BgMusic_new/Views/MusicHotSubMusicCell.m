//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "MusicHotSubMusicCell.h"

#import "MusicDownloadHelper.h"


static NSString* const ViewTableViewCellId = @"MusicHotSubMusicCellId";


@implementation MusicHotSubMusicCell


#pragma mark - 类方法
+ (NSString*) cellId{
    return ViewTableViewCellId;
}

- (UIButton *) viewBg{
    if (_viewBg == nil){
        
        _viewBg = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewBg.size = [UIView getSize_width:ScreenWidth height:MusicHotSubMusicCellHeight];
        _viewBg.origin = [UIView getPoint_x:0 y:0];
        [_viewBg setBackgroundColor:ColorThemeBackground forState:UIControlStateNormal];
        [_viewBg setBackgroundColor:RGBAlphaColor(29, 32, 42, 1) forState:UIControlStateHighlighted];
        
//        [self.viewBg addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewBg;
}

- (UIImageView *) imageVeiwIcon{
    if (_imageVeiwIcon == nil){
        
        _imageVeiwIcon = [[UIImageView alloc]init];
        _imageVeiwIcon.size = [UIView getSize_width:MusicHotSubMusicCellHeight/5*3
                                                 height:MusicHotSubMusicCellHeight/5*3];
        _imageVeiwIcon.origin = [UIView getPoint_x:10 y:(self.viewBg.height - _imageVeiwIcon.height)/2];
        
        _imageVeiwIcon.layer.cornerRadius = 3.0f;
        _imageVeiwIcon.layer.borderColor = ColorWhiteAlpha80.CGColor;
        _imageVeiwIcon.layer.borderWidth = 0.0;
        [_imageVeiwIcon.layer setMasksToBounds:YES];
        _imageVeiwIcon.userInteractionEnabled = YES;
    }
    return _imageVeiwIcon;
}

/*
 暂停按钮
 */
- (UIButton *) btnPauseIcon{
    if (_btnPauseIcon == nil){
        _btnPauseIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPauseIcon setBackgroundImage:[UIImage imageNamed:@"ugc_play_music"] forState:UIControlStateNormal];
        _btnPauseIcon.contentMode = UIViewContentModeCenter;
        //众所周知CALayer的zPosition等效于在Z轴上做了个偏移Transform。所以我们可以通过3D Transform来视觉化各个CALayer的zPosition。
        _btnPauseIcon.layer.zPosition = 3; //去掉和没去掉，没有多大差别
        _btnPauseIcon.width = _btnPauseIcon.height = 20;
        [_btnPauseIcon addTarget:self action:@selector(btnPlayMusicClick:) forControlEvents:UIControlEventTouchUpInside];
        //居中
        _btnPauseIcon.top = (self.imageVeiwIcon.height - _btnPauseIcon.height)/2;
        _btnPauseIcon.left = (self.imageVeiwIcon.width - _btnPauseIcon.width)/2;
    }
    return _btnPauseIcon;
}

- (UILabel *) labelTitle{
    if (_labelTitle == nil){
        
        _labelTitle = [[UILabel alloc]init];
        _labelTitle.size = [UIView getSize_width:200 height:20];
        _labelTitle.origin = [UIView getPoint_x:self.imageVeiwIcon.right+10 y:18];
        _labelTitle.font = [UIFont defaultBoldFontWithSize:15];
        _labelTitle.textColor = [UIColor whiteColor];
    }
    return _labelTitle;
}

- (UILabel *) labelSign{
    if (_labelSign == nil){
        
        _labelSign = [[UILabel alloc]init];
        _labelSign.size = [UIView getSize_width:220 height:20];
        _labelSign.origin = [UIView getPoint_x:self.labelTitle.left y:self.labelTitle.bottom+5];
        _labelSign.font = [UIFont defaultFontWithSize:14];
        _labelSign.textColor = RGBA(120, 122, 132, 1);
    }
    return _labelSign;
}

- (UILabel *) lableuseCount{
    
    if (_lableuseCount == nil){
        _lableuseCount = [[UILabel alloc] init];
        _lableuseCount.size = [UIView getSize_width:80 height:30];
        _lableuseCount.right = ScreenWidth - 15;
        _lableuseCount.top = (MusicHotSubMusicCellHeight - self.lableuseCount.height)/2;
        _lableuseCount.font = BigFont;
        _lableuseCount.clipsToBounds = YES;
        _lableuseCount.textColor = RGBA(120, 122, 132, 1);
    }
    return _lableuseCount;
}


/*
 下载按钮
 */
- (UIButton *) btnDownLoad{
    if (_btnDownLoad == nil){
        _btnDownLoad = [[UIButton alloc] init];
        _btnDownLoad.size = [UIView getSize_width:75.0f height:30.5f];
        _btnDownLoad.right = ScreenWidth - 10;
        _btnDownLoad.top = (MusicHotSubMusicCellHeight - _btnDownLoad.height)/2;
        [_btnDownLoad setTitle:@"使用" forState:UIControlStateNormal];
        [_btnDownLoad setTitleColor:ColorWhite forState:UIControlStateNormal];
        [_btnDownLoad setBackgroundColor:RGBA(252, 89, 82, 1) forState:UIControlStateNormal];
        [_btnDownLoad addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnDownLoad.titleLabel.font = MediumFont;;
        _btnDownLoad.clipsToBounds = YES;
        _btnDownLoad.layer.cornerRadius = 8;
    }
    return _btnDownLoad;
}

- (TCBGMProgressView *) progressView{
    
    if (_progressView == nil){
        _progressView = [[TCBGMProgressView alloc] initWithFrame:self.btnDownLoad.frame];
         _progressView.layer.cornerRadius = 8;
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.progressBackgroundColor = RGBA(252, 89, 82, 0.8);
        _progressView.hidden = YES;
    }
    
    return _progressView;
}





- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.viewBg];
    [self.viewBg addSubview:self.imageVeiwIcon];
    [self.imageVeiwIcon addSubview:self.btnPauseIcon]; //音乐封面添加播放暂停按钮
    [self.viewBg addSubview:self.labelTitle];
    [self.viewBg addSubview:self.labelSign];
    [self.viewBg addSubview:self.lableuseCount];
    [self.viewBg addSubview:self.btnDownLoad];
    
    [self.viewBg addSubview:self.progressView];
    
    

}


- (void)fillDataWithModel:(MusicSearchModel *)model{
    
    self.listModel = model;
    [self.imageVeiwIcon sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"default_music_cover"]];
    
    self.labelTitle.text = model.musicName;
    self.labelSign.text = model.nickname;
}


-(void)btnPlayMusicClick:(UIButton*)btn{
    
    self.isPlayMusic = !self.isPlayMusic;
    if(self.isPlayMusic){ //如果播放，显示暂停按钮，如果暂停显示播放按钮
        [btn setBackgroundImage:[UIImage imageNamed:@"ugc_pause_music"] forState:UIControlStateNormal];
        //播放音乐
        //[self.player play];
        
        if ([self.subCellDelegate respondsToSelector:@selector(playMusic:)]) {
            [self.subCellDelegate playMusic:self.listModel];
        } else {
            NSLog(@"代理没响应，快开看看吧");
        }
    }
    else{
        [btn setBackgroundImage:[UIImage imageNamed:@"ugc_play_music"] forState:UIControlStateNormal];
        //暂停音乐
        //[self.player pause];
        
        if ([self.subCellDelegate respondsToSelector:@selector(pauseMusic)]) {
            [self.subCellDelegate pauseMusic];
        } else {
            NSLog(@"代理没响应，快开看看吧");
        }
    }
}

- (void)download:(id)sender {
    
    
    if([GlobalFunc isFileExist:self.listModel.localUrl]){
        NSLog(@"使用音乐");
        
        if ([self.subCellDelegate respondsToSelector:@selector(useMusicClick:)]) {
            [self.subCellDelegate useMusicClick:self.listModel];
        } else {
            NSLog(@"代理没响应，快开看看吧");
        }
    }
    else{
        NSLog(@"---下载音乐---%@-------",self.listModel.playUrl);
        [self.btnDownLoad setTitle:@"下载中..." forState:UIControlStateNormal];
        [self.btnDownLoad setBackgroundColor:RGBA(50, 57, 70, 1) forState:UIControlStateNormal];

        [[MusicDownloadHelper sharedInstance] downloadMusicWithBlock:self.listModel downloadBlock:^(float percent,NSString *msg) {
            NSLog(@"-------%f",percent);
            if(percent >= 0.0f){
                if(percent == 0.0f){
                    NSLog(@"------%@--下载完成-----",self.listModel.nickname);
                    [self.btnDownLoad setTitle:@"使用" forState:UIControlStateNormal];
                    [self.btnDownLoad setBackgroundColor:RGBA(252, 89, 82, 1) forState:UIControlStateNormal];
                    
                    if ([self.subCellDelegate respondsToSelector:@selector(useMusicClick:)]) {
                        [self.subCellDelegate useMusicClick:self.listModel];
                    } else {
                        NSLog(@"代理没响应，快开看看吧");
                    }
                }
                [self setDownloadProgress:percent];
            }
            else{
                [self.btnDownLoad setTitle:@"使用" forState:UIControlStateNormal];
                [UIWindow showTips:msg];
            }
        }];
    }
}

-(void) setDownloadProgress:(CGFloat)progress{
    
    if(progress == 0.0f){
        self.progressView.hidden = YES;
    }
    else{
        [self.btnDownLoad setTitle:@"下载中..." forState:UIControlStateNormal];
        self.progressView.hidden = NO;
        self.progressView.progress = progress;
    }
}

@end
