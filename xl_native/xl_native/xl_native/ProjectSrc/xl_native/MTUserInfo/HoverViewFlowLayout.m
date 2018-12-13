//
//  HoverViewFlowLayout.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "HoverViewFlowLayout.h"

@implementation HoverViewFlowLayout

- (instancetype)initWithTopHeight:(CGFloat)height{
    self = [super init];
    if (self){
        self.topHeight = height;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    //获取当前在屏幕rect中显示的元素属性
    NSMutableArray<UICollectionViewLayoutAttributes *> *superArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    //移除掉所有Header和Footer类型的元素，因为抖音个人主页中只有第一个section包含Header和Footer类型元素，
    //即移除需要固定的Header和Footer，因为后续会单独添加，为了避免重复处理。
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [superArray removeObject:attributes];
        }
    }
    
    //单独添加上一步移除的Header和Footer，单独添加是因为第一步只能获取当前在屏幕rect中显示的元素属性，当第一个Sectioin移除屏幕便无法获取Header和Footer，
    //这是需要单独添加Header和Footer以及第二部单独移除Header和Footer的原因。
    [superArray addObject:[super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
  
    //循环当前获取的元素
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
         //判断是否是第一个section
        if(attributes.indexPath.section == 0) {
            
            if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]){
                
                //获取Header的Frame
                CGRect rect = attributes.frame;
                //判断Header的bottom是否滑动到导航栏下方
                if(self.collectionView.contentOffset.y + self.topHeight - rect.size.height > rect.origin.y) {
                    //修改Header frame的y值
                    rect.origin.y =  self.collectionView.contentOffset.y + self.topHeight - rect.size.height;
                    attributes.frame = rect;
                }
                //设施Header层级，保证Header显示时不被其它cell覆盖
                attributes.zIndex = 5;
            }
        }
        
    }
    return [superArray copy];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

@end
