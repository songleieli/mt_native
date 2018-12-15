//
//  CommentsPopView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWork_mt_home_list.h"
#import "NetWork_mt_publishComment.h"
#import "NetWork_mt_getCommentList.h"

@interface CommentsPopView:UIView

@property (nonatomic, strong) UILabel           *label;
@property (nonatomic, strong) UIImageView       *close;

- (instancetype)initWithAwemeId:(HomeListModel *)listModel;

@property (nonatomic,strong) HomeListModel *listModel;

- (void)show;
- (void)dismiss;

@end


//@class Comment;

@interface CommentListCell : UITableViewCell

@property (nonatomic, strong) UIImageView        *avatar;
@property (nonatomic, strong) UIImageView        *likeIcon;
@property (nonatomic, strong) UILabel            *nickName;
@property (nonatomic, strong) UILabel            *extraTag;
@property (nonatomic, strong) UILabel            *content;
@property (nonatomic, strong) UILabel            *likeNum;
@property (nonatomic, strong) UILabel            *date;
@property (nonatomic, strong) UIView             *splitLine;

-(void)initData:(CommentListModel *)comment;
+(CGFloat)cellHeight:(CommentListModel *)comment;

@end



@protocol CommentTextViewDelegate

@required

-(void)onSendText:(NSString *)text;

@end


@interface CommentTextView : UIView

@property (nonatomic, strong) UIView                         *container;
@property (nonatomic, strong) UITextView                     *textView;
@property (nonatomic, strong) id<CommentTextViewDelegate>    delegate;

- (void)show;
- (void)dismiss;

@end
