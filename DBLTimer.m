//
//  DBLTimer.m
//  GCD定时器
//
//  Created by dbl on 2020/2/18.
//  Copyright © 2020 dbl. All rights reserved.
//

#import "DBLTimer.h"

@implementation DBLTimer

static NSMutableDictionary *timers;
dispatch_semaphore_t semaphore;
//确保timers只创建一次
+ (void)initialize {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers = [NSMutableDictionary dictionary];
        semaphore = dispatch_semaphore_create(1);
    });
    
}

+ (NSString *)execTask:(void (^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async {
    
    if (!task || start < 0 || (interval <= 0 && repeats)) return nil;
    
    dispatch_queue_t queue = async ? dispatch_queue_create("timer", DISPATCH_QUEUE_SERIAL) : dispatch_get_main_queue();
    
    //创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //设置开始时间和间隔
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    //加锁
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //定时器的唯一标志
    NSString *name = [NSString stringWithFormat:@"%zd", timers.count];
    //存放到到字典中
    timers[name] = timer;
    dispatch_semaphore_signal(semaphore);
    
    //设置回调
    dispatch_source_set_event_handler(timer, ^{
        
        task();
        
        if (!repeats) {
            [self cancelTask:name];
        }
    });
    
    //启动定时器
    dispatch_resume(timer);
    
    return name;
}

+ (void)cancelTask:(NSString *)name {
    if (name.length == 0) {
        return;
    }
    
    //加锁
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_source_t timer = timers[name];
    if (timer) {
        dispatch_source_cancel(timers[name]);
        //从字典中移除
        [timers removeObjectForKey:name];
    }
    
    dispatch_semaphore_signal(semaphore);
}

@end
