//
//  Shop.h
//  storyboard
//
//  Created by Damien Bell on 2/9/13.
//  Copyright (c) 2013 Damien Bell. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Shop : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSData   *jsonAsData;
@property (nonatomic, strong) NSString *jsonAsString;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) CLLocation *location;
@property           CLLocationDistance *distanceInMeters;
@property(nonatomic, strong) NSNumber *distanceInMiles;

@property (nonatomic, strong) NSString *yelp_image_url;
@property (nonatomic, strong) NSString *yelp_reviews_url;
@property (nonatomic, strong) NSString *yelp_id;
@property (nonatomic, strong) UIImage *ratings_image;
@property (nonatomic, strong) NSString *review_snippet;
@property (nonatomic, strong) NSString *review_count;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *foursquare_id;
@property (nonatomic, strong) NSString *foursquare_url;

@property (nonatomic, strong) NSMutableArray *images;

-(NSComparisonResult)compareDistance:(Shop*)otherObject;

-(void)openInMaps:(CLLocationCoordinate2D)from_coords;
-(void)showInYelp;
-(void)showInFourSquare;
-(BOOL)isYelpInstalled;

@end
