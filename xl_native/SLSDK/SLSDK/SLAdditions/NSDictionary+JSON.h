//
//  NSDictionary+JSON.h
//  VShang
//
//  Created by zs2 on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  @author liuhui

#import <Foundation/Foundation.h>
/**
 * 扩展 NSDictionary, 为JSON提供支持方法.
 */
@interface NSDictionary(JSON)
/**
 * 忽略NSNull对象，将NSNull转化为nil。
 */
- (id)objectForKeyIgnoreNull:(id)aKey;
/**
 * 按照指定key获取String类型值
 */
-(NSString *) stringForKey:(NSString *) key;
/**
 * 按照指定key获取int类型值
 */

-(int) intForKey:(NSString *) key;
/**
 * 按照指定key获取long类型值
 */
-(long long) longForKey:(NSString *) key;
/**
 * 按照指定key获取double类型值
 */
-(double) doubleForKey: (NSString *) key;
/**
 * 按照指定key获取bool类型值
 */
-(BOOL) boolForKey:(NSString *) key;
/**
 * 按照指定key获取Array类型值
 */
-(NSArray *) arrayForKey:(NSString *) key;

@end

