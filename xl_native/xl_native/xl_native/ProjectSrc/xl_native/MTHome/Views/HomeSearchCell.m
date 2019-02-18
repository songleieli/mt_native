//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "HomeSearchCell.h"

static NSString* const ViewTableViewCellId = @"HomeSearchCellId";


@implementation HomeSearchCell


#pragma mark - 类方法
+ (NSString*) cellId{
    return ViewTableViewCellId;
}



#pragma mark ------------ 懒加载 --------------
//head
- (UIView *) viewTitle{
    if (_viewTitle == nil){
        
        CGRect rect =  [UIView getFrame_x:15 y:0 width:ScreenWidth-15*2 height:50];
        _viewTitle  = [[UIView alloc] initWithFrame:rect];
//        _viewTitle.backgroundColor = [UIColor redColor];
        
        [_viewTitle addSubview:self.imageVeiwBg];
        [_viewTitle addSubview:self.titleLalbe];
        [_viewTitle addSubview:self.descLalbe];
        [_viewTitle addSubview:self.playCountLalbe];
    }
    return _viewTitle;
}

- (UIView *) imageVeiwBg{
    if (_imageVeiwBg == nil){
        
        _imageVeiwBg  = [[UIView alloc] init];
        _imageVeiwBg.size = [UIView getSize_width:30 height:30];
        _imageVeiwBg.origin = [UIView getPoint_x:0 y:(_viewTitle.height - _imageVeiwBg.height)/2];
        _imageVeiwBg.layer.cornerRadius = _imageVeiwBg.width/2;
        _imageVeiwBg.layer.borderColor = ColorWhiteAlpha80.CGColor;
        _imageVeiwBg.layer.borderWidth = 0.0;
        [_imageVeiwBg.layer setMasksToBounds:YES];
        
        //test
        _imageVeiwBg.backgroundColor = RGBA(54, 58, 67, 1);
        [_imageVeiwBg addSubview:self.btnIcon];
    }
    return _imageVeiwBg;
}

- (UIButton *)btnIcon{
    if (_btnIcon == nil){
        _btnIcon = [UIButton buttonWithType:UIButtonTypeCustom]; //[[UIImageView alloc]init];
        _btnIcon.size = [UIView getSize_width:15 height:15];
        _btnIcon.left = (_imageVeiwBg.width - _btnIcon.width)/2;
        _btnIcon.top = (_imageVeiwBg.height - _btnIcon.height)/2;
        [_btnIcon addTarget:self action:@selector(btnIconClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnIcon;
}

- (UILabel*)titleLalbe{
    
    if (!_titleLalbe) {
        _titleLalbe = [[UILabel alloc] init];
        _titleLalbe.font = [UIFont defaultBoldFontWithSize:14];
        _titleLalbe.textColor = [UIColor whiteColor];
        _titleLalbe.size = [UIView getSize_width:250 height:20];
        _titleLalbe.origin = [UIView getPoint_x:self.imageVeiwBg.right+5
                                              y:(self.imageVeiwBg.centerY - _titleLalbe.height)];
        
        //test
//        _titleLalbe.backgroundColor = [UIColor greenColor];
    }
    return _titleLalbe;
}

- (UILabel*)descLalbe{
    
    if (!_descLalbe) {
        _descLalbe = [[UILabel alloc] init];
        _descLalbe.font = [UIFont defaultFontWithSize:14];
        _descLalbe.textColor = RGBA(123, 125, 134, 1);
        _descLalbe.size = [UIView getSize_width:250 height:20];
        _descLalbe.origin = [UIView getPoint_x:self.imageVeiwBg.right+5
                                              y:self.imageVeiwBg.centerY];
        
        //test
//        _descLalbe.backgroundColor = [UIColor orangeColor];
    }
    return _descLalbe;
}

- (UILabel*)playCountLalbe{
    
    if (!_playCountLalbe) {
        _playCountLalbe = [[UILabel alloc] init];
        _playCountLalbe.font = [UIFont defaultBoldFontWithSize:12];
        _playCountLalbe.textColor = [UIColor whiteColor];
        _playCountLalbe.size = [UIView getSize_width:50 height:20];
        _playCountLalbe.left = self.viewTitle.width - _playCountLalbe.width - 15;
        _playCountLalbe.centerY = self.imageVeiwBg.centerY;
        _playCountLalbe.textAlignment = NSTextAlignmentRight;
    }
    return _playCountLalbe;
}

- (UIScrollView *) scrollerBody{
    if (_scrollerBody == nil){
        
        CGRect rect =  [UIView getFrame_x:15 y:self.viewTitle.bottom width:self.viewTitle.width height:130];
        _scrollerBody  = [[UIScrollView alloc] initWithFrame:rect];
        _scrollerBody.alwaysBounceVertical = NO;
        _scrollerBody.alwaysBounceHorizontal = YES;
    }
    return _scrollerBody;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = ColorThemeBackground;

}
- (void)fillDataWithModel:(GetHotVideoListModel *)model{

    
    self.listModel = model;
    
    self.contentView.height = HomeSearchCellHeight;
    
    [self.contentView addSubview:self.viewTitle];
    [self.contentView addSubview:self.scrollerBody];
    
    if([model.hotType integerValue] == 1){
        //self.btnIcon.image = [UIImage imageNamed:@"icon_m_typic"];
        [self.btnIcon setImage:[UIImage imageNamed:@"icon_m_typic"] forState:UIControlStateNormal];
        self.titleLalbe.text = model.topic.topic;
        self.descLalbe.text = @"热门话题";
        self.playCountLalbe.text = [NSString formatCount:[model.topic.playSum integerValue]];

    }
    else{
//        self.btnIcon.image = [UIImage imageNamed:@"icon_m_music_red"];
        [self.btnIcon setImage:[UIImage imageNamed:@"icon_m_music_red"] forState:UIControlStateNormal];
        self.titleLalbe.text = model.music.name;
        self.descLalbe.text = @"热门音乐";
        self.playCountLalbe.text = [NSString formatCount:[model.music.hotCount integerValue]];

    }
    
    
    CGFloat videoHeight = 130;
    CGFloat videoWidth = (CGFloat)videoHeight/1.35;
    self.scrollerBody.contentSize = [UIView getSize_width:(model.videoList.count)*videoWidth height:100];
    [self.scrollerBody removeAllSubviews];
    [model.videoList enumerateObjectsUsingBlock:^(HomeListModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btnVideo = [UIButton buttonWithType:UIButtonTypeCustom]; //[[UIImageView alloc] init];
        btnVideo.tag = idx;
        btnVideo.height = videoHeight;
        btnVideo.width = videoWidth;
        btnVideo.origin = [UIView getPoint_x:idx*btnVideo.width y:0];
        [btnVideo sd_setImageWithURL:[NSURL URLWithString:obj.coverUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaul_publishcover"]];
        btnVideo.layer.borderWidth = 0.25;
        btnVideo.layer.borderWidth = 1.0;
        btnVideo.layer.borderColor = ColorThemeBackground.CGColor;
        [btnVideo addTarget:self action:@selector(btnVideoClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollerBody addSubview:btnVideo];
    }];
}

#pragma -mark -------- btnClick -------

-(void)btnIconClick:(UIButton*)btn{
    
    if([self.cellDelegate respondsToSelector:@selector(btnCellIconClick:)]){
        [self.cellDelegate btnCellIconClick:self.listModel];
    }
    else{
        NSLog(@"代理没响应，快开看看吧");
    }
}

-(void)btnVideoClick:(UIButton*)btn{
    
    if([self.cellDelegate respondsToSelector:@selector(btnCellVideoClick:selectIndex:)]){
        [self.cellDelegate btnCellVideoClick:self.listModel.videoList selectIndex:btn.tag];
    }
    else{
        NSLog(@"代理没响应，快开看看吧");
    }
}


@end
