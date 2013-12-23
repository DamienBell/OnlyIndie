//
//  shopsMasterViewController.h
//  Only Indie Coffee
//
//  Created by Damien Bell on 11/23/13.
//  Copyright (c) 2013 Damien Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Shop.h"
#import "shopsDetailViewController.h"

@interface shopsMasterViewController : UITableViewController < CLLocationManagerDelegate, UITableViewDelegate>

@property (nonatomic, retain) CLLocationManager *location;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSMutableArray *shops;
@property (nonatomic) int offset;
@property (nonatomic) int total_available;

//we want to let the locationManager fire didUpdateLocations a few times
//for a better reading before we turn it off. This is just to keep track of how many times we fired it.
@property (nonatomic) int locationUpdates;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *num_reviews;
@property (nonatomic) BOOL loading_more_shops;

@property (weak, nonatomic) IBOutlet UIButton *map_button;
@property (weak, nonatomic) IBOutlet UIButton *yelp_button;

- (void)loadShops;
- (void)handleEnterForeground:(NSNotification*)sender;



@end
