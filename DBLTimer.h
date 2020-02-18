//
//  DBLTimer.h
//  GCD定时器
//
//  Created by dbl on 2020/2/18.
//  Copyright © 2020 dbl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBLTimer : NSObject

/// 定时器类方法 返回一个定时器标识字符串
/// @param task 任务
/// @param start 开始时间
/// @param interval 间隔
/// @param repeats 是否重复
/// @param async 是否在子线程
+ (NSString *)execTask:(void (^)(void))task
           start:(NSTimeInterval)start
        interval:(NSTimeInterval)interval
         repeats:(BOOL)repeats async:(BOOL)async;


/// 取消定时
/// @param name 定时器唯一标识
+ (void)cancelTask:(NSString *)name;

@end

