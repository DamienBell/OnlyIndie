//
//  AsyncImageGallery.m
//  Only Indie Coffee
//
//  Created by Damien Bell on 2/15/14.
//  Copyright (c) 2014 Damien Bell. All rights reserved.
//

#import "AsyncImageView.h"
#import "AsyncImageGallery.h"

@implementation AsyncImageGallery


typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

-(void)setUp{
    
    self.pagingEnabled=YES;
    self.index = 0;
    self.loaded_count = 0;
    self.framewidth = 320.00;
    self.delegate = self;
    NSLog(@"%f, %f",self.framewidth, self.frame.size.height);
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
}
- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"asyncImageGallery initWithFrame");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
      NSLog(@"asyncImageGallery initWithCoder");
    if ((self = [super initWithCoder:coder])) {
        [self setUp];
    }
    return self;
}

-(void)setImages:(NSMutableArray *)images{
    self.imgs = images;
    [self loadNext];
}

-(BOOL)hasNextImage{

    if(self.index < [self.imgs count]){
        return YES;
    }
   // NSLog(@"no more images %lu %lu",(unsigned long)self.index, (unsigned long)[self.imgs count]);
    return NO;
}
-(BOOL)isIndexLoaded{
    return NO;
}
//is there a next image?
 //

-(void)loadNext{
    NSLog(@"load next %lu", (unsigned long)self.index);
    
    if([self hasNextImage]){
        //do a check to ensure photo is not already loaded
        NSLog(@"loading an image");
        NSDictionary *photo_object = [self.imgs objectAtIndex:self.index];
        NSURL *img_url= [[NSURL alloc] initWithString:[photo_object objectForKey:@"src"]];
        
        AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(self.index * 320.0f, 0.0f, 325.0f, 125.0f)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setImageURL:img_url];
        [self addSubview:imageView];
       
        self.index++;
        
        if([self hasNextImage]){
            //increase content size to accomodate next image
            float width = self.contentSize.width + self.framewidth;
            
            //if the image is loaded quickly then the contentSize.width will be 0. We already know there's another
            //image so we'll go ahead and set it to accomodate two images
            if(width <= self.framewidth){
                width = self.framewidth * 2;
            }
            self.contentSize = CGSizeMake(width, self.frame.size.height);
        }
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    ScrollDirection scrollDirection;
    
    if (self.lastContentOffset > self.contentOffset.x){
        scrollDirection = ScrollDirectionRight;
        
    }else if(self.lastContentOffset < self.contentOffset.x){
        scrollDirection = ScrollDirectionLeft;
    }else{
        scrollDirection = ScrollDirectionNone;
    }
    
    self.lastContentOffset = self.contentOffset.x;
    //check index if appropriate
    
    if(scrollDirection == ScrollDirectionLeft){
        [self loadNext];
    }
    
}


@end
