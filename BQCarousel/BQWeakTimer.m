//
//  BQWeakTimer.m
//  ESports
//
//  Created by 时彬强 on 2017/6/8.
//  Copyright © 2017年 QQLS. All rights reserved.
//

#import "BQWeakTimer.h"

#import <UIKit/UIKit.h>

@interface BQWeakTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) BOOL stopTimer;

@end

@implementation BQWeakTimerTarget

- (void)fire:(NSTimer *)timer {
    
    if(!self.stopTimer && self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelectorOnMainThread:self.selector withObject:timer.userInfo waitUntilDone:NO];
#pragma clang diagnostic pop
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)pauseTimer {
    
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
    
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timer.timeInterval]];
}

@end

@interface BQWeakTimer ()

@property (nonatomic, weak) BQWeakTimerTarget *timerTarget;

@end

@implementation BQWeakTimer

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                        target:(id)aTarget
                                      selector:(SEL)aSelector
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats {
    
    BQWeakTimerTarget *timerTarget = [[BQWeakTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                         target:timerTarget
                                                       selector:@selector(fire:)
                                                       userInfo:userInfo
                                                        repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timerTarget.timer forMode:NSRunLoopCommonModes];
    
    BQWeakTimer *weakTimer = [[self alloc] init];
    weakTimer.timerTarget = timerTarget;
    
    return weakTimer;
}

- (void)pauseTimer {
    
    [self.timerTarget pauseTimer];
}

- (void)resumeTimer {
    
    [self.timerTarget resumeTimer];
}

- (void)stopTimer {
    
    self.timerTarget.stopTimer = YES;
}

@end
