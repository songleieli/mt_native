//
//  SettingAboutViewController.m
//  CMPLjhMobile
//
//  Created by Liyanjun on 2017/5/25.
//  Copyright © 2017年 CMP_Ljh. All rights reserved.
//

#import "SettingAboutViewController.h"

/*
 *分享
 */
//#import "NetWork_download_qr.h" //请求下载二维码
//#import "ShareView.h"
#import "WXApi.h"


@interface SettingAboutViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong)ShareView *shareView;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic ,strong)NSMutableArray *dataSource;




@end

@implementation SettingAboutViewController


- (UIImageView *)img{
    
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.image = [BundleUtil getCurrentBundleImageByName:@"login_icon"];;
        _img.top = self.navBackGround.bottom + MasScale_1080(148);
        _img.height = MasScale_1080(262);
        _img.width = MasScale_1080(262);
        _img.left = (self.view.width-_img.width)/2;
    }
    return _img;
}

- (UILabel *)contenLabel{
    
    if (!_contenLabel) {
        _contenLabel = [[UILabel alloc] init];
        _contenLabel.font = BigFont;
        _contenLabel.textColor = ColorWhiteAlpha80;
        _contenLabel.text = @"查看历史消息";
        _contenLabel.numberOfLines = 0;
        
        NSString* content = @"面条短视频是一款可以拍短视频的音乐创意短视频社交软件用户可以通过这款软件选择歌曲拍摄音乐短视频,形成自己的作品上传至面条平台。";
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        
        [paragraphStyle setLineSpacing:MasScale_1080(20)];
        
        [paragraphStyle setFirstLineHeadIndent:MasScale_1080(78)];
        
        paragraphStyle.paragraphSpacing = MasScale_1080(60);
        
        [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
        
        _contenLabel.attributedText = attrStr;
        
        
        _contenLabel.top = self.img.bottom + MasScale_1080(150);
        _contenLabel.left = 20;
        _contenLabel.height = 250;
        _contenLabel.width = self.view.width-2*20;
        
        //test
//        _contenLabel.backgroundColor = [UIColor redColor];
    }
    
    return  _contenLabel;
}

- (UILabel *)companyLable{
    
    if (!_companyLable) {
        _companyLable = [[UILabel alloc] init];
        
        _companyLable.top = self.contenLabel.bottom+MasScale_1080(150);
        _companyLable.left = 0;
        _companyLable.width = self.view.width;
        _companyLable.height = 35;

        
        _companyLable.font = BigFont;
        _companyLable.textColor = ColorWhite;
        _companyLable.textAlignment = NSTextAlignmentCenter;
        _companyLable.text = @"重庆面条网络技术有限公司";
        
        //test
//        _companyLable.backgroundColor = [UIColor blueColor];
    }
    
    return _companyLable;
}

- (UILabel *)copyrightLalel{
    
    if (!_copyrightLalel) {
        _copyrightLalel = [[UILabel alloc] init];
        
        _copyrightLalel.top = self.companyLable.bottom;
        _copyrightLalel.left = 0;
        _copyrightLalel.width = self.view.width;
        _copyrightLalel.height = 35;
        
        _copyrightLalel.font = BigFont;
        _copyrightLalel.textColor = ColorWhite;
        _copyrightLalel.textAlignment = NSTextAlignmentCenter;
        _copyrightLalel.text = @"Copyright © 2019-2050";
    }
    return _copyrightLalel;
}

-(void)initNavTitle{
    self.title = @"关于我们";
    
    self.isNavBackGroundHiden = NO;
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
    
    [self.btnLeft setImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    
//    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navBackGround.height-1, ScreenWidth, 1)];
//    lineView.backgroundColor = RGBFromColor(0xd4d4d4);
//    [self.navBackGround addSubview:lineView];

//    UIButton *rightButton = [[UIButton alloc]init];
//    rightButton.tag = 91;
//    rightButton.size = [UIView getSize_width:70 height:44];
//    rightButton.origin = [UIView getPoint_x:self.navBackGround.width - rightButton.width y:self.lableNavTitle.top];
//    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [rightButton setTitleColor:RGBFromColor(0xecedf1) forState:UIControlStateHighlighted];
//    rightButton.titleLabel.font = [UIFont defaultFontWithSize:18];
//    [rightButton setTitle:@"分享" forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(requestShareDownLoad) forControlEvents:UIControlEventTouchUpInside];
//    [self.navBackGround addSubview:rightButton];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载

- (NSMutableArray *)dataSource
{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    
    return _dataSource;
    
}

#pragma -maek 分享下载

//-(void)requestShareDownLoad{
//    //请求App下载二维码的下载地址
//    __weak __typeof(self) weakSelf = self;
//    NetWork_download_qr *request = [[NetWork_download_qr alloc] init];
//    [request showWaitMsg:@"正在加载..." handle:self];
//    [request startGetWithBlock:^(id result, NSString *msg) {} finishBlock:^(DownloadQrRespone *result, NSString *msg, BOOL finished) {
//        for(DownloadQrModel *model in result.data){
//            if([model.appkey.trim isEqualToString:@"ljh"]){
//
//                NSURL *url = [NSURL URLWithString: model.url];
//                SDWebImageManager *manager = [SDWebImageManager sharedManager];
//                BOOL isimageCacle = [manager diskImageExistsForURL:url];
//                if(isimageCacle){
//                    NSString* key = [manager cacheKeyForURL:url];
//                    SDImageCache* cache = [SDImageCache sharedImageCache];
//                    //此方法会先从memory中取。
//                    UIImage* image = [cache imageFromDiskCacheForKey:key];
//                    [weakSelf doShare:image shareUrl:model.html];
//                }
//                else{
//                    [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                        NSLog(@"图片下载成功");
//
//                        if(finished){
//                            [weakSelf doShare:image shareUrl:model.html];
//                        }
//                        else{
//                            UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
//                            [weakSelf doShare:image shareUrl:model.html];
//                        }
//                    }];
//                }
//            }
//        }
//    }];
//}

//-(void)doShare:(UIImage*)shareImage shareUrl:(NSString*)shareUrl{
//
//    if(self.shareView){
//        [self.shareView removeFromSuperview];
//        self.shareView = nil;
//    }
//
//    NSString *description = @"致力于打造社区化的智慧家庭网上生活服务平台。围绕家庭为中心，实现对物管事务、生活需求、周边消费、邻里互动、闲置资源、家居设备、置业理财、医疗养老等居家生活管理并提供管家服务。全方位提升业主的社区内生活品质，体验便捷化、个性化的智慧生活方式。 下载地址。";
//    NSDictionary *dicParam = @{@"url":shareUrl,@"title":@"乐家慧",@"description":description};
//
//    self.shareView = [[ShareView alloc]initWithFrame:self.view.bounds];
//    self.shareView.shareUrl = [dicParam objectForKey:@"url"];
//    self.shareView.shareTitle = [dicParam objectForKey:@"title"];
//    self.shareView.friendCircleTitle = [dicParam objectForKey:@"title"];
//    self.shareView.shareDescription = [dicParam objectForKey:@"description"];
//    self.shareView.moduleType = download;
//
//    //缩略图
//    NSString *imageName = [[[[NSBundle mainBundle] infoDictionary]valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
//    UIImage *image = [UIImage imageNamed:imageName];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    self.shareView.thumbData = imageData;
//
//    UIWindow     *window = [[UIApplication sharedApplication].delegate window];
//    [window addSubview:self.shareView];
//}


#pragma mark - 设置UI
- (void)setupUi{
    
    self.view.backgroundColor = ColorThemeBackground;
    
    [self.view addSubview:self.img];
    [self.view addSubview:self.contenLabel];
    [self.view addSubview:self.companyLable];
    [self.view addSubview:self.copyrightLalel];
}



@end
