#import <UIKit/UIKit.h>

#import <MBProgressHUD/MBProgressHUD.h>
#import "BaseNavigationController.h"
#import "BgMusicListViewController.h"

@interface RecordMusicInfo : NSObject
@property (nonatomic, copy) NSString* filePath;
@property (nonatomic, copy) NSString* soneName;
@property (nonatomic, copy) NSString* singerName;
@property (nonatomic, assign) CGFloat duration;
@end

/**
 *  短视频录制VC
 */
@interface TCVideoRecordViewController : UIViewController

@property (nonatomic,strong) NSString *videoPath;
@property (nonatomic,assign) BOOL savePath;
@property (nonatomic,assign) BOOL preloadingVideos;

@property(nonatomic,strong) MusicSearchModel * selectMusicModel;//合唱需要musicModel


@end
