//
//  CLPlayerMaskView.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/2/24.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "SwitchPlayerMaskView_temp.h"
#import "CLSlider.h"
#import "Masonry.h"


@interface SwitchPlayerMaskView_temp ()



@end

@implementation SwitchPlayerMaskView_temp


#pragma mark ------------UI元素----------------

- (UIImageView *) musicIcon{
    if (_musicIcon == nil){
        //init aweme message //音乐icon
        _musicIcon = [[UIImageView alloc]init];
        _musicIcon.size =  [UIView getScaleSize_width:30 height:25]; //[UIView getSize_width:50 height:50];
        _musicIcon.left = 0;
        _musicIcon.bottom = self.height - kTabBarHeight_New - 5;
        _musicIcon.contentMode = UIViewContentModeCenter;
        _musicIcon.image = [UIImage imageNamed:@"icon_home_musicnote3"];
        
        //test
//                _musicIcon.backgroundColor = [UIColor redColor];
    }
    return _musicIcon;
}

- (CircleTextView *) musicName{
    if (_musicName == nil){
        //音乐名称
        _musicName = [[CircleTextView alloc]init];
        _musicName.left = self.musicIcon.right;
        _musicName.textColor = ColorWhite;
        _musicName.font = MediumFont;
        _musicName.width = self.width/2;
        _musicName.height = 24;
        _musicName.centerY = self.musicIcon.centerY; //centerY 需要放在宽高设置完成之后，要不然不起作用。
        
//        _musicName.backgroundColor = [UIColor redColor];
    }
    return _musicName;
}


- (MusicAlbumView *) musicAlum{
    if (_musicAlum == nil){ //转动的CD
        _musicAlum = [[MusicAlbumView alloc]init];
        _musicAlum.width = 50;
        _musicAlum.height = 50;
        _musicAlum.right = self.right - 10;
        _musicAlum.bottom = self.musicName.bottom;
        
        _musicAlum.userInteractionEnabled = YES;
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [_musicAlum addGestureRecognizer:_singleTapGesture];
    }
    return _musicAlum;
}

- (UILabel *) desc{
    if (_desc == nil){ //
        //描述
        _desc = [[UILabel alloc]init];
        _desc.numberOfLines = 0;
        _desc.textColor = ColorWhiteAlpha80;
        _desc.font = MediumFont;
        
        _desc.left = 10;
        _desc.bottom = self.musicIcon.top;
        _desc.width = ScreenWidth/5*3;
    }
    return _desc;
}

- (UILabel *) nickName{
    if (_nickName == nil){ //
        _nickName = [[UILabel alloc]init];
        _nickName.textColor = ColorWhite;
        _nickName.font = BigBoldFont;
        
        _nickName.left = 10;
        _nickName.bottom = self.desc.top;
        _nickName.width = _desc.width;
        _nickName.height = 30;
    }
    return _nickName;
}

- (UIImageView *) share{
    if (_share == nil){ //
        //init share、comment、like action view
        _share = [[UIImageView alloc]init];
        _share.contentMode = UIViewContentModeCenter;
        _share.image = [UIImage imageNamed:@"icon_home_share"];
        _share.userInteractionEnabled = YES;
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [_share addGestureRecognizer:_singleTapGesture];
        
        _share.width = 50;
        _share.height = 45;
        _share.bottom = self.musicAlum.top - 30;
        _share.right = self.right - 10;
    }
    return _share;
}

- (UILabel *) shareNum{
    if (_shareNum == nil){ //
        _shareNum = [[UILabel alloc]init];
        _shareNum.text = @"0";
        _shareNum.textColor = ColorWhite;
        _shareNum.font = SmallFont;
        _shareNum.textAlignment = NSTextAlignmentCenter;
        
        
        _shareNum.top = self.share.bottom;
        _shareNum.height = 20;
        _shareNum.width = 50;
        _shareNum.centerX = self.share.centerX;
    }
    return _shareNum;
}

- (UIImageView *) comment{
    if (_comment == nil){ //
        //init share、comment、like action view
        _comment = [[UIImageView alloc]init];
        _comment.contentMode = UIViewContentModeCenter;
        _comment.image = [UIImage imageNamed:@"icon_home_comment"];
        _comment.userInteractionEnabled = YES;
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [_comment addGestureRecognizer:_singleTapGesture];
        
        _comment.width = 50;
        _comment.height = 45;
        _comment.bottom = self.share.top - 30;
        _comment.right = self.right - 10;
    }
    return _comment;
}

- (UILabel *) commentNum{
    if (_commentNum == nil){ //
        _commentNum = [[UILabel alloc]init];
        _commentNum.text = @"0";
        _commentNum.textColor = ColorWhite;
        _commentNum.font = SmallFont;
        _commentNum.textAlignment = NSTextAlignmentCenter;
        
        
        _commentNum.top = self.comment.bottom;
        _commentNum.height = 20;
        _commentNum.width = 50;
        _commentNum.centerX = self.comment.centerX;
    }
    return _commentNum;
}

- (FavoriteView *) favorite{
    if (_favorite == nil){ //
        
        __weak __typeof(self) weakSelf = self;
        _favorite = [[FavoriteView alloc]init];
        _favorite.contentMode = UIViewContentModeCenter;
        _favorite.userInteractionEnabled = YES;
        
        _favorite.width = 50;
        _favorite.height = 45;
        _favorite.bottom = self.comment.top - 30;
        _favorite.right = self.right - 10;
        _favorite.likeClickBlock = ^(FavoriteView *favoriteView) {
            //点赞按钮响应事件
            
            NSLog(@"------------");
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(zanButtonAction:)]) {
                [weakSelf.delegate zanButtonAction:favoriteView];
            }else{
                NSLog(@"没有实现代理或者没有设置代理人");
            }
        };
        
    }
    return _favorite;
}

- (UILabel *) favoriteNum{
    if (_favoriteNum == nil){ //
        _favoriteNum = [[UILabel alloc]init];
        _favoriteNum.text = @"0";
        _favoriteNum.textColor = ColorWhite;
        _favoriteNum.font = SmallFont;
        _favoriteNum.textAlignment = NSTextAlignmentCenter;
        
        
        _favoriteNum.top = self.favorite.bottom;
        _favoriteNum.height = 20;
        _favoriteNum.width = 50;
        _favoriteNum.centerX = self.favorite.centerX;
    }
    return _favoriteNum;
}

- (UIImageView *) avatar{
    if (_avatar == nil){
        
        //init avatar
        CGFloat avatarRadius = 25;
        _avatar = [[UIImageView alloc] init];
        _avatar.image = [UIImage imageNamed:@"img_find_default"];
        _avatar.layer.cornerRadius = avatarRadius;
        _avatar.layer.borderColor = ColorWhiteAlpha80.CGColor;
        _avatar.layer.borderWidth = 1;
        [_avatar.layer setMasksToBounds:YES];
        _avatar.userInteractionEnabled = YES;
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [_avatar addGestureRecognizer:_singleTapGesture];

        _avatar.height = avatarRadius*2;
        _avatar.width = avatarRadius*2;
        _avatar.bottom = self.favorite.top - 30;
        _avatar.right = self.right - 10;

        //test
//        _avatar.backgroundColor = [UIColor redColor];
    }
    return _avatar;
}

- (FocusView *) focus{
    if (_focus == nil){
        
        __weak __typeof(self) weakSelf = self;

        
        //init avatar
        _focus = [[FocusView alloc] init];
        
        _focus.width = _focus.height = 24;
        _focus.centerY = self.avatar.bottom;
        _focus.centerX = self.avatar.centerX;
        _focus.focusClickBlock = ^(FocusView *focusView) {
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(followButtonAction:)]) {
                [weakSelf.delegate followButtonAction:focusView];
            }else{
                NSLog(@"没有实现代理或者没有设置代理人");
            }
        };

    }
    return _focus;
}

- (UIImageView *) pauseIcon{
    if (_pauseIcon == nil){
        
        _pauseIcon = [[UIImageView alloc] init];
        _pauseIcon.image = [UIImage imageNamed:@"icon_play_pause"];
        _pauseIcon.contentMode = UIViewContentModeCenter;
        //众所周知CALayer的zPosition等效于在Z轴上做了个偏移Transform。所以我们可以通过3D Transform来视觉化各个CALayer的zPosition。
        _pauseIcon.layer.zPosition = 3; //去掉和没去掉，没有多大差别
        _pauseIcon.hidden = YES;
        
        
        _pauseIcon.center = self.center;
        
        

        
        //test
        //_pauseIcon.backgroundColor = [UIColor redColor];
    }
    return _avatar;
}


- (UIButton *) btnPlay{
    if (_btnPlay == nil){
        _btnPlay = [[UIButton alloc] init];
        _btnPlay.size = [UIView getSize_width:50 height:50];
        _btnPlay.origin = [UIView getPoint_x:(self.width - _btnPlay.width)/2
                                           y:(self.height - _btnPlay.height)/2];
        [_btnPlay setImage:[self getPictureWithName:@"video_play"] forState:UIControlStateNormal];
        [_btnPlay addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPlay;
}




-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame listLoginModel:(HomeListModel *)listLoginModel{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        self.listLoginModel = listLoginModel;
    }
    return self;
}



- (void)initViews{
    
    /*
     container，渐变色,避免视频有白色时，白色图标显示效果不明显
     */
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[(__bridge id)ColorClear.CGColor, (__bridge id)ColorBlackAlpha20.CGColor, (__bridge id)ColorBlackAlpha40.CGColor];
    _gradientLayer.locations = @[@0.3, @0.6, @1.0];
    _gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    _gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
    [self.layer addSublayer:_gradientLayer];
    
    [self addSubview:self.musicIcon];
    [self addSubview:self.musicName];
    [self addSubview:self.musicAlum];
    [self addSubview:self.desc];
    [self addSubview:self.nickName];
    
    [self addSubview:self.share];
    [self addSubview:self.shareNum];
    
    [self addSubview:self.comment];
    [self addSubview:self.commentNum];
    
    [self addSubview:self.favorite];
    [self addSubview:self.favoriteNum];
    
    [self addSubview:self.avatar];
    [self addSubview:self.focus];
    
//    [self addSubview:self.pauseIcon];
    [self addSubview:self.btnPlay];
}


-(void)setListLoginModel:(HomeListModel *)listLoginModel{
    _listLoginModel = listLoginModel;
    
    [self.musicName setText:listLoginModel.musicName];
    
    __weak __typeof(self) wself = self;
    [self.musicAlum.album sd_setImageWithURL:[NSURL URLWithString:listLoginModel.coverUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(!error) {
            wself.musicAlum.album.image = [image drawCircleImage];
        }
    }];
    
    [_musicAlum startAnimation:12];
    
    
    CGRect contentLabelSize = [listLoginModel.title boundingRectWithSize:CGSizeMake(self.desc.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.desc.font,NSFontAttributeName, nil] context:nil];
    self.desc.height = contentLabelSize.size.height;
    self.desc.text = listLoginModel.title;
    self.desc.bottom = self.musicIcon.top;
    
    self.nickName.text = [NSString stringWithFormat:@"@%@", listLoginModel.nickname];
    self.nickName.bottom = self.desc.top;
    
    self.shareNum.text = [NSString stringWithFormat:@"%d",[listLoginModel.saveAlbumSum intValue] ];
    self.commentNum.text = [NSString stringWithFormat:@"%d",[listLoginModel.forwardSum intValue] ];
    self.favoriteNum.text = [NSString stringWithFormat:@"%d",[listLoginModel.likeSum intValue] ];
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:listLoginModel.head] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(!error) {
            wself.musicAlum.album.image = [image drawCircleImage];
        }
    }];
}


-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _gradientLayer.frame = CGRectMake(0, self.frame.size.height - 500, self.frame.size.width, 500);
    [CATransaction commit];
}


#pragma mark - 自定义方法
-(void)showPlayBtn{
    self.btnPlay.hidden = NO;
}

-(void)hidePlayBtn{
    self.btnPlay.hidden = YES;
}

//gesture
- (void)handleGesture:(UITapGestureRecognizer *)sender {
    
    if(sender.view == self.avatar){ //点击用户头像
        NSLog(@"--------点击用户头像------");
        
        if (_delegate && [_delegate respondsToSelector:@selector(userInfoAction)]) {
            [_delegate userInfoAction];
        }else{
            NSLog(@"没有实现代理或者没有设置代理人");
        }
    }
    if(sender.view == self.comment){//点击回复按钮
        NSLog(@"--------点击回复按钮------");
        if (_delegate && [_delegate respondsToSelector:@selector(commentAction)]) {
            [_delegate commentAction];
        }else{
            NSLog(@"没有实现代理或者没有设置代理人");
        }
    }
    if(sender.view == self.share){//点击分享按钮
        NSLog(@"--------点击分享按钮------");
        
        if (_delegate && [_delegate respondsToSelector:@selector(shareAction)]) {
            [_delegate shareAction];
        }else{
            NSLog(@"没有实现代理或者没有设置代理人");
        }
    }
    if(sender.view == self.musicAlum){//点击z转动CD
        NSLog(@"--------点击z转动CD------");
        
        if (_delegate && [_delegate respondsToSelector:@selector(musicCdAction)]) {
            [_delegate musicCdAction];
        }else{
            NSLog(@"没有实现代理或者没有设置代理人");
        }
    }
    
    /*
    switch (sender.view.tag) {
        case kAwemeListLikeCommentTag: {
            CommentsPopView *popView = [[CommentsPopView alloc] initWithAwemeId:_aweme.aweme_id];
            [popView show];
            break;
        }
        case kAwemeListLikeShareTag: {
            SharePopView *popView = [[SharePopView alloc] init];
            [popView show];
            break;
        }
        default: {
            //获取点击坐标，用于设置爱心显示位置
            CGPoint point = [sender locationInView:_container];
            //获取当前时间
            NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
            //判断当前点击时间与上次点击时间的时间间隔
            if(time - _lastTapTime > 0.25f) {
                //推迟0.25秒执行单击方法
                [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.25f];
            }else {
                //取消执行单击方法
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object: nil];
                //执行连击显示爱心的方法
                [self showLikeViewAnim:point oldPoint:_lastTapPoint];
            }
            //更新上一次点击位置
            _lastTapPoint = point;
            //更新上一次点击时间
            _lastTapTime =  time;
            break;
        }
    }
    */
}

#pragma mark - 获取资源图片
- (UIImage *)getPictureWithName:(NSString *)name{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"SwitchPlayer" ofType:@"bundle"]];
    NSString *path   = [bundle pathForResource:name ofType:@"png"];
    return [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

//播放按钮
- (void)playButtonAction:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(playButtonAction:)]) {
        [_delegate playButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}



@end
