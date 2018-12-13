//
//  PopViewController.m
//  CMPLjhMobile
//
//  Created by 刘欣 on 16/7/6.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableVIew;
    NSArray *_dataArray;
    NSArray *_arr1;
    NSArray *_arr2;
}

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    _arr1 = @[@"录制",@"合唱",@"本地视频",@"本地图片"];
    _arr2 = @[@"main_pop_attention",@"main_pop_scan",@"main_pop_attention",@"main_pop_scan"];
    
    
    
    _tableVIew = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableVIew.delegate = self;
    _tableVIew.dataSource = self;
    _tableVIew.scrollEnabled = YES;
    _tableVIew.backgroundColor = [UIColor whiteColor];
    _tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableVIew];
    




}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr2.count;
    
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    
    cell.textLabel.text = _arr1[indexPath.row];
    cell.textLabel.font = [UIFont defaultFontWithSize:15];
    cell.textLabel.textColor = RGBFromColor(0x464952);
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_arr2[indexPath.row]]];

    if (indexPath.row < (_arr2.count-1)) {
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(sizeScale(10),sizeScale(38), sizeScale(100),sizeScale(0.6));
        lineView.backgroundColor = RGBFromColor(0xecedf1);
        [cell.contentView addSubview:lineView];
        
    }

    
    //修改系统imgaeView的大小
//    CGSize itemSize = CGSizeMake(15, 15);
//    UIGraphicsBeginImageContext(itemSize);
//    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//    [cell.imageView.image drawInRect:imageRect];
//    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    return cell;
    
    
}


//重置本控制器的大小
-(CGSize)preferredContentSize{
    
    if (self.popoverPresentationController != nil) {
        CGSize tempSize ;
        tempSize.height = self.view.frame.size.height;
        tempSize.width  = 125;
        CGSize size = [_tableVIew sizeThatFits:tempSize];  //返回一个完美适应tableView的大小的 size
        return size;
    }else{
        return [super preferredContentSize];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(clickRow:)]) {
        [self.delegate clickRow:indexPath.row];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return sizeScale(38);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
