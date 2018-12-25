//
//  TCBGMListViewController.m
//  TXXiaoShiPinDemo
//
//  Created by linkzhzhu on 2017/12/8.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "TCBGMListViewController.h"
#import "TCBGMHelper.h"
#import "UIView+CustomAutoLayout.h"
#import "TCBGMCell.h"
#import "MBProgressHUD.h"
#import <MediaPlayer/MPMediaPickerController.h>
#import "ColorMacro.h"

#import "NetWork_mt_getMusicList.h"

@interface TCBGMListViewController()<TCBGMHelperListener,TCBGMCellDelegate,MPMediaPickerControllerDelegate>{
    
    NSMutableDictionary* _progressList;
    NSTimeInterval lastUIFreshTick;
    NSString* _bgmPath;
    
}

@property(nonatomic,strong) TCBGMHelper* bgmHelper;
@property(nonatomic,weak) id<TCBGMControllerListener> bgmListener;

@property(nonatomic,strong)NSMutableArray* mainDataArr;


@end


@implementation TCBGMListViewController{
    
    NSIndexPath *_BGMCellPath;
    BOOL      _useLocalMusic;
}

#pragma -mark ---------懒加载---------

- (NSMutableArray *)mainDataArr{
    if (_mainDataArr == nil){
        _mainDataArr = [[NSMutableArray alloc] init];
    }
    return _mainDataArr;
}



- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _progressList = [NSMutableDictionary new];
        _useLocalMusic = NO;
    }
    return self;
}

-(void)setBGMControllerListener:(id<TCBGMControllerListener>) listener{
    _bgmListener = listener;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//-(void)initNavTitle{
//
//    [super initNavTitle];
//    self.isNavBackGroundHiden  = NO;
//
//    self.title = @"选择背景音乐";
//}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.title = NSLocalizedString(@"TCBGMListView.TitileChooseBGM", nil);


    
    _bgmPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/bgm"];
    
    _bgmHelper = [TCBGMHelper sharedInstance];
    [_bgmHelper setDelegate:self];
    
    UIBarButtonItem *customBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = customBackButton;
    
    self.tableView.backgroundColor = RGB(25, 29, 38);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TCBGMCell" bundle:nil] forCellReuseIdentifier:@"TCBGMCell"];

}

//-(void)loadNewData{
//
//    [self.mainDataArr removeAllObjects];
//
//
//    [self initRequest];
//
//    [self.mainTableView.mj_header endRefreshing];
//
//}

-(void)initRequest{
    NetWork_mt_getMusicList *request = [[NetWork_mt_getMusicList alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.pageNo = @"1";
    request.pageSize = @"20";
    [request startGetWithBlock:^(GetMusicListResponse *result, NSString *msg, BOOL finished) {
        NSLog(@"--------");
        
        if(finished){
            
            [self.mainDataArr removeAllObjects];
            
            for(MusicModel*model in result.obj){
                if(model.name.length > 0){
                    TCBGMElement* ele =  [[TCBGMElement alloc] init];
                    
                    NSString *pathExtension = [model.playUrl pathExtension];
                    if(pathExtension.length > 0){
                        ele.name = [NSString stringWithFormat:@"%@.%@",model.name,pathExtension];
                    }
                    else{
                        ele.name = [NSString stringWithFormat:@"%@.mp3",model.name];
                    }
                    ele.netUrl = model.playUrl;
                    ele.author = model.nickname;
                    ele.title = model.name;
                    ele.localUrl = [_bgmPath stringByAppendingPathComponent:ele.name];
                    [self.mainDataArr addObject:ele];
                }
            }
        }
        [self.tableView reloadData];
        
        
//        [self refreshNoDataViewWithListCount:self.mainDataArr.count];
//        [self.mainTableView reloadData];
    }];
}

- (void)goBack
{
    [_bgmListener onBGMControllerPlay:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadBGMList{
    
//    [self.mainTableView.mj_header beginRefreshing];

    [self initRequest];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mainDataArr count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TCBGMCell* cell = (TCBGMCell *)[tableView dequeueReusableCellWithIdentifier:@"TCBGMCell"];
    if (!cell) {
        cell = [[TCBGMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TCBGMCell"];
    }
    cell.delegate = self;
    TCBGMElement* ele = [self.mainDataArr objectAtIndex:indexPath.row];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:ele.localUrl]){
        [cell setDownloadProgress:1.0];
        cell.progressView.hidden = YES;
    }
    else{
        cell.progressView.hidden = YES;
        [cell.downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
    }
    
    
    cell.downLoadBtn.hidden = [_BGMCellPath isEqual:indexPath];
    cell.musicLabel.text = ele.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)onBGMDownLoad:(TCBGMCell *)cell;
{
    if (_BGMCellPath) {
        TCBGMCell *cell = (TCBGMCell*)[self.tableView cellForRowAtIndexPath:_BGMCellPath];
        cell.progressView.hidden = YES;
        cell.downLoadBtn.hidden  = NO;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _BGMCellPath = indexPath;
    cell.downLoadBtn.hidden = YES;
    cell.progressView.hidden = NO;
    TCBGMElement* ele = [self.mainDataArr objectAtIndex:indexPath.row];
    if([[NSFileManager defaultManager] fileExistsAtPath:ele.localUrl]){
        [_bgmListener onBGMControllerPlay: ele.localUrl];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [_bgmHelper downloadBGM:ele];
    }
}

-(void) onBGMDownloading:(TCBGMElement*)current percent:(float)percent{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[self.tableView indexPathsForVisibleRows] containsObject:_BGMCellPath]) {
            TCBGMCell *cell = [self.tableView cellForRowAtIndexPath:_BGMCellPath];
            cell.progressView.hidden = NO;
            cell.downLoadBtn.hidden = YES;
            [cell setDownloadProgress:percent];
        }
    });
}

-(void) onBGMDownloadDone:(TCBGMElement*)element{
    
    
    
//    if([[element isValid] boolValue]){
    
        
        BGMLog(@"Download \"%@\" success!", [element name]);
        [_progressList setObject :[NSNumber numberWithFloat:1.f] forKey:[element netUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            TCBGMCell *cell = [self.tableView cellForRowAtIndexPath:_BGMCellPath];
            cell.progressView.hidden = YES;
            cell.downLoadBtn.hidden = NO;
            _BGMCellPath = nil;
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        });
//        [_bgmListener onBGMControllerPlay: element.localUrl];
    
        
//    }
//    else BGMLog(@"Download \"%@\" failed!", [element name]);

}

- (void)showMPMediaPickerController
{
    MPMediaPickerController *mpc = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    mpc.delegate = self;
    mpc.editing = YES;
    mpc.allowsPickingMultipleItems = NO;
    [self.navigationController presentViewController:mpc animated:YES completion:nil];
}

#pragma mark - BGM
//选中后调用
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    NSArray *items = mediaItemCollection.items;
    MPMediaItem *songItem = [items objectAtIndex:0];
    NSURL *url = [songItem valueForProperty:MPMediaItemPropertyAssetURL];
    AVAsset *songAsset = [AVAsset assetWithURL:url];
    if (songAsset != nil) {
        [_bgmListener onBGMControllerPlay:songAsset];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//点击取消时回调
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [_bgmListener onBGMControllerPlay:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
