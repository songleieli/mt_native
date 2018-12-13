//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "HomeVideoCell.h"

static NSString* const ViewTableViewCellId = @"HomeVideoCellId";

@implementation HomeVideoCell

#pragma mark - 类方法
+ (NSString*) cellId{
    return ViewTableViewCellId;
}

- (SwitchPlayerView *)playerView{
    
    if (!_playerView) {
        __weak __typeof(self) weakSelf = self;
        CGRect frame = CGRectMake(0, 0, ScreenWidth, HomeVideoCellHeight);
        _playerView = [[SwitchPlayerView alloc] initWithFrame:frame];
        _playerView.pushUserInfo = ^{
            
            if ([weakSelf.homeDelegate respondsToSelector:@selector(userInfoClicked:)]) {
                [weakSelf.homeDelegate userInfoClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
            
        };
        _playerView.followClick = ^{
            
            if ([weakSelf.homeDelegate respondsToSelector:@selector(followClicked:)]) {
                [weakSelf.homeDelegate followClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
        };
        _playerView.zanClick = ^{
            
            if ([weakSelf.homeDelegate respondsToSelector:@selector(zanClicked:)]) {
                [weakSelf.homeDelegate zanClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
            
        };
        
        _playerView.commentClick = ^{
            
            if ([weakSelf.homeDelegate respondsToSelector:@selector(commentClicked:)]) {
                [weakSelf.homeDelegate commentClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
            
        };


        _playerView.shareClick = ^{
            
            if ([weakSelf.homeDelegate respondsToSelector:@selector(shareClicked:)]) {
                [weakSelf.homeDelegate shareClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
            
        };
        
        _playerView.musicCDClick = ^{
            if ([weakSelf.homeDelegate respondsToSelector:@selector(musicCDClicked:)]) {
                [weakSelf.homeDelegate musicCDClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
        };


    }
    return _playerView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    //contentView 的默认高度是 44 ，需要先设置一下宽和高
    self.contentView.height = HomeVideoCellHeight;
    self.contentView.width = ScreenWidth;
//    self.contentView.backgroundColor = [GlobalFunc randomColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.playerView];
}
- (void)fillDataWithModel:(HomeListModel *)model{
    
    self.listModel = model;
    self.playerView.listLoginModel = model;
    self.playerView.url = [NSURL URLWithString:model.storagePath];//视频地址
//    [self.playerView playVideo];
}

- (void)cellClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(btnClicked:cell:)]) {
        [self.delegate btnClicked:sender cell:self];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}




@end
