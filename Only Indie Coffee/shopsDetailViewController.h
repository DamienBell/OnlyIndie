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

@interface shopsDetailViewController : UIViewController

//passed from masterView
@property(strong, nonatomic) Shop *shop;
@property (nonatomic, retain) CLLocation *currentLocation;

//url properties/functions
@property (nonatomic, retain) NSMutableData *responseData;
@property (weak, nonatomic) NSURLConnection *checkFourSquareConnection;

-(void)checkFourSquareAvailable;


//view buttons/actions
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

@property (weak, nonatomic) IBOutlet UITextView *address_text;

@property (weak, nonatomic) IBOutlet UITextView *review_text;
@property (weak, nonatomic) IBOutlet UIImageView *ratings_image;
@property (weak, nonatomic) IBOutlet UILabel *num_reviews;

@property (weak, nonatomic) IBOutlet UIButton *fourSquareButton;
@property (weak, nonatomic) IBOutlet UIButton *yelp_button;
@property (weak, nonatomic) IBOutlet UIButton *foursquare_button;

- (IBAction)open_in_yelp:(id)sender;
- (IBAction)open_in_map:(id)sender;
- (IBAction)open_in_foursquare:(id)sender;


@end
