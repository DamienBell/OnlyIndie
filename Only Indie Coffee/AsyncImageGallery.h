//
//  AsyncImageGallery.h
//  Only Indie Coffee
//
//  Created by Damien Bell on 2/15/14.
//  Copyright (c) 2014 Damien Bell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncImageGallery : UIScrollView  <UIScrollViewDelegate>


@property (nonatomic, strong) NSMutableArray *imgs;
@property NSUInteger loaded_count;
@property NSUInteger index;
@property float framewidth;
@property (nonatomic, assign) CGFloat lastContentOffset;
-(void)setImages:(NSMutableArray *)images;
-(void)loadNext;
@end
