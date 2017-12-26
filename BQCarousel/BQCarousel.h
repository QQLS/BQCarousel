//
//  BQCarousel.h
//  BQCarouselView
//
//  Created by QQLS on 2017/12/26.
//  Copyright © 2017年 QQLS. All rights reserved.
//

/**
 *  An infinity loop carousel view
 */
#import <UIKit/UIKit.h>

@interface BQCarousel : UIView

/** Create carousel use frame and imageURLStrings. */
+ (instancetype)carouselWithFrame:(CGRect)frame imageURLStrings:(NSArray *)imageURLStrings;

/** The callback of clicking the imageView. */
@property (nonatomic, copy) void (^didSelectedIndex) (NSInteger currentIndex);

/** The time interval between image scrolling. */
@property (nonatomic, assign) NSTimeInterval switchInterval;

/** All urls of scroll image. */
@property (nonatomic, strong) NSArray *imageURLStrings;

@end
