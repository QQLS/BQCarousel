//
//  ViewController.m
//  BQCarouselDemo
//
//  Created by QQLS on 2017/12/26.
//  Copyright © 2017年 QQLS. All rights reserved.
//

#import "ViewController.h"

#import "BQCarousel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BQCarousel *carousel = [BQCarousel carouselWithFrame:CGRectMake(0, 0, 300, 300) imageURLStrings:nil];
    carousel.center = self.view.center;
    carousel.imageURLStrings = @[
                                 @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1514279043&di=48bc57a0ecbd79f523b5c4dea915b9c4&src=http://pic1.ooopic.com/uploadfilepic/ziku/2008-08-10/OOOPIC_vipvip_200808101002115e5eef369a6b407e55.jpg",
                                 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1514289474310&di=d3be6a200bc4d77e726dec1cdff70af2&imgtype=0&src=http%3A%2F%2Fpic1.ooopic.com%2Fuploadfilepic%2Fziku%2F2008-08-10%2FOOOPIC_vipvip_200808101001324953a8bbbf0376fe35.jpg",
                                 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1514289474310&di=610b5bfe85a7d4bd6121f9676664a479&imgtype=0&src=http%3A%2F%2Fbcs.91.com%2Fpcsuite-dev%2Fimg%2F0%2F480_800%2F127fce02941255fce977c719bdb20d40.jpeg" ];
    carousel.didSelectedIndex = ^(NSInteger index) {
        NSLog(@"curIndex: %ld", index);
    };
    [self.view addSubview:carousel];
}

@end


