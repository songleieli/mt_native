//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "MusicCollectionSubMusicCell.h"

static NSString* const ViewTableViewCellId = @"MusicCollectionSubMusicCellId";


@implementation MusicCollectionSubMusicCell


#pragma mark - 类方法
+ (NSString*) cellId{
    return ViewTableViewCellId;
}

#pragma mark ---------- 懒加载 ------

- (UIButton *) viewBg{
    if (_viewBg == nil){
        
        _viewBg = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewBg.size = [UIView getSize_width:ScreenWidth height:MusicCollectionSubMusicCellHeight];
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
        _imageVeiwIcon.size = [UIView getSize_width:MusicCollectionSubMusicCellHeight/5*3
                                             height:MusicCollectionSubMusicCellHeight/5*3];
        _imageVeiwIcon.origin = [UIView getPoint_x:10 y:(self.viewBg.height - _imageVeiwIcon.height)/2];
        
        _imageVeiwIcon.layer.cornerRadius = 3.0f;
        _imageVeiwIcon.layer.borderColor = ColorWhiteAlpha80.CGColor;
        _imageVeiwIcon.layer.borderWidth = 0.0;
        [_imageVeiwIcon.layer setMasksToBounds:YES];
        _imageVeiwIcon.userInteractionEnabled = YES;
    }
    return _imageVeiwIcon;
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
        _lableuseCount.top = (MusicCollectionSubMusicCellHeight - self.lableuseCount.height)/2;
        _lableuseCount.font = [UIFont defaultFontWithSize:14];
        _lableuseCount.clipsToBounds = YES;
        _lableuseCount.textColor = RGBA(120, 122, 132, 1);
    }
    return _lableuseCount;
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
    [self.viewBg addSubview:self.labelTitle];
    [self.viewBg addSubview:self.labelSign];
    [self.viewBg addSubview:self.lableuseCount];
}
- (void)fillDataWithModel:(GetMusicCollectionModel *)model{
    
    self.listModel = model;
    [self.imageVeiwIcon sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"img_find_default"]];
    
    self.labelTitle.text = model.musicName;
//    self.lableuseCount.text = [NSString stringWithFormat:@"%@",model.];
}


- (void)btnDelClick:(id)sender{
    
    if ([self.subCellDelegate respondsToSelector:@selector(btnCellClick:)]) {
        [self.subCellDelegate btnCellClick:self.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

@end
