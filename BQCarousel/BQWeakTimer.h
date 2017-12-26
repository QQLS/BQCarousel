//
//  BQWeakTimer.h
//  ESports
//
//  Created by 时彬强 on 2017/6/8.
//  Copyright © 2017年 QQLS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQWeakTimer : NSObject

/**
 *  Create a timer that doesn't cause circular references.
 */
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                        target:(id)aTarget
                                      selector:(SEL)aSelector
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats;


/**
 *  Pause the timer.
 */
- (void)pauseTimer;

/**
 *  Resume the timer.
 */
- (void)resumeTimer;

/**
 *  Stop the timer.
 */
- (void)stopTimer;

@end
