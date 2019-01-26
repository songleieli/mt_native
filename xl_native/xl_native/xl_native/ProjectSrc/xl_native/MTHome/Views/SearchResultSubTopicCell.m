//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "SearchResultSubTopicCell.h"

static NSString* const ViewTableViewCellId = @"SearchResultSubTopicCellId";


@implementation SearchResultSubTopicCell


#pragma mark - 类方法
+ (NSString*) cellId{
    return ViewTableViewCellId;
}


- (UIButton *) viewBg{
    if (_viewBg == nil){
        
        _viewBg  = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewBg.size = [UIView getSize_width:ScreenWidth height:SearchResultSubTopicCellHeight];
        _viewBg.origin = [UIView getPoint_x:0 y:0];

        [_viewBg setBackgroundColor:ColorThemeBackground forState:UIControlStateNormal];
        [_viewBg setBackgroundColor:RGBAlphaColor(29, 32, 42, 1) forState:UIControlStateHighlighted];
        
        
        //test
//        [_viewBg setBackgroundColor:[GlobalFunc randomColor] forState:UIControlStateNormal];
        
        [_viewBg addSubview:self.imageVeiwBg];
    }
    return _viewBg;
}

- (UIView *) imageVeiwBg{
    if (_imageVeiwBg == nil){
        
        _imageVeiwBg  = [[UIView alloc] init];
        _imageVeiwBg.size = [UIView getSize_width:45 height:45];
        _imageVeiwBg.origin = [UIView getPoint_x:15 y:(SearchResultSubTopicCellHeight - _imageVeiwBg.height)/2];
        
        _imageVeiwBg.layer.cornerRadius = _imageVeiwBg.width/2;
        _imageVeiwBg.layer.borderColor = ColorWhiteAlpha80.CGColor;
        _imageVeiwBg.layer.borderWidth = 0.0;
        [_imageVeiwBg.layer setMasksToBounds:YES];
        _imageVeiwBg.backgroundColor = RGBA(54, 58, 67, 1);
        
        [_imageVeiwBg addSubview:self.imageVeiwIcon];
    }
    return _imageVeiwBg;
}

- (UIImageView *)imageVeiwIcon{
    if (_imageVeiwIcon == nil){
        _imageVeiwIcon = [[UIImageView alloc]init];
        _imageVeiwIcon.size = [UIView getSize_width:15 height:15];
        _imageVeiwIcon.left = (_imageVeiwBg.width - _imageVeiwIcon.width)/2;
        _imageVeiwIcon.top = (_imageVeiwBg.height - _imageVeiwIcon.height)/2;
        
        _imageVeiwIcon.image = [UIImage imageNamed:@"icon_m_typic"];
    }
    return _imageVeiwIcon;
}

- (UILabel*)titleLalbe{
    
    if (!_titleLalbe) {
        _titleLalbe = [[UILabel alloc] init];
        _titleLalbe.font = [UIFont defaultBoldFontWithSize:14];
        _titleLalbe.textColor = [UIColor whiteColor];
        _titleLalbe.size = [UIView getSize_width:250 height:20];
        _titleLalbe.left = self.imageVeiwBg.right+5;
        _titleLalbe.centerY = self.imageVeiwBg.centerY;
    }
    return _titleLalbe;
}

- (UILabel*)useCountLalbe{
    
    if (!_useCountLalbe) {
        _useCountLalbe = [[UILabel alloc] init];
        _useCountLalbe.size = [UIView getSize_width:80 height:30];
        _useCountLalbe.right = ScreenWidth - 15;
        _useCountLalbe.top = (SearchResultSubTopicCellHeight - _titleLalbe.height)/2;
        _useCountLalbe.font = [UIFont defaultFontWithSize:14];
        _useCountLalbe.clipsToBounds = YES;
        _useCountLalbe.textColor = RGBA(120, 122, 132, 1);
        _useCountLalbe.textAlignment = NSTextAlignmentRight;
    }
    return _useCountLalbe;
}

//self.lableuseCount = [[UILabel alloc] init];
//self.lableuseCount.size = [UIView getSize_width:80 height:30];
//self.lableuseCount.right = ScreenWidth - 15;
//self.lableuseCount.top = (SearchResultSubMusicCellHeight - self.lableuseCount.height)/2;
//self.lableuseCount.font = [UIFont defaultFontWithSize:14];
//self.lableuseCount.clipsToBounds = YES;
//self.lableuseCount.textColor = RGBA(120, 122, 132, 1);
//[self.viewBg addSubview:self.lableuseCount];




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.viewBg];
    [self.viewBg addSubview:self.titleLalbe];
    [self.viewBg addSubview:self.useCountLalbe];
}
- (void)fillDataWithModel:(GetFuzzyTopicListModel *)model{
    
    self.listModel = model;
    self.titleLalbe.text = model.topic;
    self.useCountLalbe.text = model.hotCount;
//    [self.imageVeiwIcon sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"img_find_default"]];
//
//    self.labelTitle.text = [NSString stringWithFormat:@"%@",model.name];
//    self.lableuseCount.text = [NSString stringWithFormat:@"%@",model.hotCount];
}


- (void)btnDelClick:(id)sender{
    
    if ([self.subTopicDelegate respondsToSelector:@selector(btnDeleteClick:)]) {
        [self.subTopicDelegate btnDeleteClick:self.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

@end
