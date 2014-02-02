//
//  Shop.m
//  storyboard
//
//  Created by Damien Bell on 2/9/13.
//  Copyright (c) 2013 Damien Bell. All rights reserved.
//

#import "Shop.h"

@implementation Shop


-(NSComparisonResult)compareDistance:(Shop*)otherShop{
    return [self.distanceInMiles compare:otherShop.distanceInMiles];
}

-(void)openInMaps:(CLLocationCoordinate2D)from_coords{
    
    double to_long = [self.longitude doubleValue];
    double to_lat  = [self.latitude doubleValue];
    
    CLLocationCoordinate2D to_coords = CLLocationCoordinate2DMake(to_lat,to_long);
    
    Class itemClass = [MKMapItem class];
    //open IOS 6
    
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        
        MKPlacemark *placemark_to   =[[MKPlacemark alloc] initWithCoordinate:to_coords addressDictionary:nil];
        MKPlacemark *placemark_from =[[MKPlacemark alloc] initWithCoordinate:from_coords addressDictionary:nil];
        
        MKMapItem *shopLocation     = [[MKMapItem alloc] initWithPlacemark:placemark_to];
        MKMapItem *currentLocation  = [[MKMapItem alloc] initWithPlacemark:placemark_from];
        
        shopLocation.name = self.name;
        
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, shopLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                 forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
        
    }else{
        //open in maps IOS 5
        NSMutableString *mapURL = [NSMutableString stringWithString:@"http://maps.google.com/maps?"];
        [mapURL appendFormat:@"saddr=%f,%f", from_coords.latitude, from_coords.longitude];
        [mapURL appendFormat:@"&daddr=%f,%f", to_coords.latitude, to_coords.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
}

-(void)showInYelp{
    if([self isYelpInstalled]){
        NSString *app_url= [NSString stringWithFormat:@"yelp:///biz/%@", self.yelp_id];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app_url]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.yelp_reviews_url]];
    }
}

-(void)setLocalRating:(NSNumber *)rating{
    
   
    NSString *url  = [NSString stringWithFormat:@"%@.png",[rating stringValue]];
    NSLog(@"url: %@", url);
    if([UIImage imageNamed:url]){
        self.ratings_image = [UIImage imageNamed:url];
    }else{
        //empty image
       self.ratings_image =[UIImage imageNamed:@"0.png"];
    }
}
/** yelp functions **/

- (BOOL)isYelpInstalled {
    return [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"yelp4:"]];
}

/** foursquare functions **/
-(void)showInFourSquare{
    
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"foursquare:"]]){
        NSString *app_url= [NSString stringWithFormat:@"foursquare://venues/%@", self.foursquare_id];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app_url]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.foursquare_url]];
    }
}


@end
