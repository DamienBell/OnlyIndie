//
//  shopsDetailViewController.h
//  Only Indie Coffee
//
//  Created by Damien Bell on 11/23/13.
//  Copyright (c) 2013 Damien Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Shop.h"
#import "AsyncImageGallery.h"

@interface shopsDetailViewController : UIViewController

//passed from masterView
@property(strong, nonatomic) Shop *shop;
@property (nonatomic, retain) CLLocation *currentLocation;

//url properties/functions
@property (nonatomic, retain) NSMutableData *responseData;
@property (weak, nonatomic) NSURLConnection *fourSquareURLConnection;

//details view only properties

//array of jsons for gallery images
/*
 { 
 "src": "https://irs0.4sqi.net/img/general/960x720/257677_CMjdCEphgUJ_-d9QqMqgzBQuTneoN45XqVMU55tV89Y.jpg",
 "height": 720,
 "width": 960
 }
 */


-(void)checkFourSquareAvailable;

//view buttons/actions
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

@property (weak, nonatomic) IBOutlet UITextView *address_text;

@property (weak, nonatomic) IBOutlet UITextView *review_text;
@property (weak, nonatomic) IBOutlet UIImageView *ratings_image;
@property (weak, nonatomic) IBOutlet UILabel *num_reviews;

@property (weak, nonatomic) IBOutlet AsyncImageGallery *imageScroller;

@property (weak, nonatomic) IBOutlet UIButton *fourSquareButton;
@property (weak, nonatomic) IBOutlet UIButton *yelp_button;
@property (weak, nonatomic) IBOutlet UIButton *foursquare_button;
@property (weak, nonatomic) IBOutlet UIButton *twitter_button;

@property (weak, nonatomic) IBOutlet UIView *detailsBar;

- (IBAction)open_in_yelp:(id)sender;
- (IBAction)open_in_map:(id)sender;
- (IBAction)open_in_foursquare:(id)sender;
- (IBAction)initTweet:(id)sender;


@end
