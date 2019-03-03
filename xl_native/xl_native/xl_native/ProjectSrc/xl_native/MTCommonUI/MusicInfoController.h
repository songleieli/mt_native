//
//  UserInfoViewController.h
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/8.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "AwemeCollectionCell.h"
#import "LoadMoreControl.h"


#import "ScrollPlayerListViewController.h"
#import "MyMusicHeaderView.h"

#import "NetWork_mt_getHotVideosByMusic.h"
#import "NetWork_mt_collectionMusic.h"
#import "NetWork_mt_deleteCollection.h"

@interface MusicInfoController : ZJBaseViewController<UICollectionViewDelegate,
                                                                    UICollectionViewDataSource,
                                                                    UICollectionViewDelegateFlowLayout,
                                                                    UIViewControllerTransitioningDelegate,MusicHeadDelegate>


@property (nonatomic, strong) UICollectionView                 *collectionView;
@property (nonatomic, assign) NSInteger                        selectIndex;
@property (nonatomic, strong) MyMusicHeaderView             *topicHeader;
@property (nonatomic, strong) LoadMoreControl                  *loadMore;
@property (nonatomic, strong) GetHotVideosByMusicModel         *musicModel;

@property (nonatomic, copy) NSString                        *musicId;

@end
