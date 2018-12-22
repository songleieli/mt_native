//
//  UserResponse.h
//  Douyin
//
//  Created by songleilei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import "UserResponse.h"



@interface Cover :IObjcJsonBase

@property (nonatomic , copy) NSArray            * url_list;
@property (nonatomic , copy) NSString              * uri;

@end


@interface Video :IObjcJsonBase

//@property (nonatomic , strong) Dynamic_cover              * dynamic_cover;
//@property (nonatomic , strong) Play_addr_lowbr              * play_addr_lowbr;
@property (nonatomic , assign) NSInteger              width;
@property (nonatomic , copy) NSString              * ratio;
//@property (nonatomic , strong) Play_addr              * play_addr;
@property (nonatomic , strong) Cover              * cover;
@property (nonatomic , assign) NSInteger              height;
//@property (nonatomic , copy) NSArray<Bit_rate *>              * bit_rate;
//@property (nonatomic , strong) Origin_cover              * origin_cover;
@property (nonatomic , assign) NSInteger              duration;
//@property (nonatomic , strong) Download_addr              * download_addr;
@property (nonatomic , assign) BOOL              has_watermark;


@end

@interface Statistics :IObjcJsonBase
@property (nonatomic , assign) NSInteger              digg_count;
@property (nonatomic , copy) NSString              * aweme_id;
@property (nonatomic , assign) NSInteger              share_count;
@property (nonatomic , assign) NSInteger              play_count;
@property (nonatomic , assign) NSInteger              comment_count;
@end



@interface Aweme : IObjcJsonBase

@property (nonatomic , strong) User              * author;
//@property (nonatomic , strong) Music              * music;
@property (nonatomic , assign) BOOL              cmt_swt;
//@property (nonatomic , copy) NSArray<Video_text *>              * video_text;
//@property (nonatomic , strong) Risk_infos              * risk_infos;
@property (nonatomic , assign) NSInteger              is_top;
@property (nonatomic , copy) NSString              * region;
@property (nonatomic , assign) NSInteger              user_digged;
//@property (nonatomic , copy) NSArray<Cha_list *>              * cha_list;
@property (nonatomic , assign) BOOL              is_ads;
@property (nonatomic , assign) NSInteger              bodydance_score;
@property (nonatomic , assign) BOOL              law_critical_country;
@property (nonatomic , assign) NSInteger              author_user_id;
@property (nonatomic , assign) NSInteger              create_time;
@property (nonatomic , strong) Statistics              * statistics;
//@property (nonatomic , copy) NSArray<Video_labels *>              * video_labels;
@property (nonatomic , copy) NSString              * sort_label;
//@property (nonatomic , strong) Descendants              * descendants;
//@property (nonatomic , copy) NSArray<Geofencing *>              * geofencing;
@property (nonatomic , assign) BOOL              is_relieve;
//@property (nonatomic , strong) Status              * status;
@property (nonatomic , assign) NSInteger              vr_type;
@property (nonatomic , assign) NSInteger              aweme_type;
@property (nonatomic , copy) NSString              * aweme_id;
@property (nonatomic , strong) Video              * video;
@property (nonatomic , assign) BOOL              is_pgcshow;
@property (nonatomic , copy) NSString              * desc;
@property (nonatomic , assign) NSInteger              is_hash_tag;
//@property (nonatomic , strong) Aweme_share_info              * share_info;
@property (nonatomic , copy) NSString              * share_url;
@property (nonatomic , assign) NSInteger              scenario;
//@property (nonatomic , strong) Label_top              * label_top;
@property (nonatomic , assign) NSInteger              rate;
@property (nonatomic , assign) BOOL              can_play;
@property (nonatomic , assign) BOOL              is_vr;
//@property (nonatomic , copy) NSArray<Text_extra *>              * text_extra;

@end


@interface AwemesResponse:IObjcJsonBase


@property (nonatomic , copy) NSString * code;
@property (nonatomic , copy) NSString * message;
@property (nonatomic, strong) NSArray    *data;
@property (nonatomic , strong) NSNumber   *total_count;
@property (nonatomic , strong) NSNumber   *has_more;

@end
