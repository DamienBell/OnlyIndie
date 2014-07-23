//
//  shopsMasterViewController.m
//  Only Indie Coffee
//
//  Created by Damien Bell on 11/23/13.
//  Copyright (c) 2013 Damien Bell. All rights reserved.
//

#import "shopsMasterViewController.h"
#import "shopsDetailViewController.h"

@interface shopsMasterViewController ()

@end

@implementation shopsMasterViewController

@synthesize currentLocation = _currentLocation;
@synthesize location = _location;
@synthesize locationUpdates= _locationUpdates;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    [self.loadingIndicator startAnimating];
    
    [self loadShops];
    self.locationUpdates = 0;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor =  [UIColor colorWithRed:26.0f/255.0f green:188.0f/255.0f blue:156.0f/255.0f alpha:1.0f];
    [refreshControl addTarget:self action:@selector(reloadShops) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnterForeground:)
                                                 name: @"UIApplicationWillEnterForegroundNotification"
                                               object: nil];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShopCell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Shop *current= [self.shops objectAtIndex:indexPath.row];
    
    NSString *distance = [NSString stringWithFormat:@"%@ miles",
                          [NSString stringWithFormat:@"%.2f",[current.distanceInMiles doubleValue]]];
    

    UILabel *namelabel;
    namelabel = (UILabel *)[cell viewWithTag:1];
    namelabel.text= [current name];
    
    UILabel *streetlabel;
    streetlabel= (UILabel *)[cell viewWithTag:2];
    streetlabel.text = [current address];
    [streetlabel setFont:[UIFont fontWithName:@"ProximaNovaLightItalic" size:14.0f]];
    
    UILabel *distancelabel;
    distancelabel= (UILabel *)[cell viewWithTag:5];
    distancelabel.text= distance;
    
    UIImageView *ratingsImage;
    
    ratingsImage = (UIImageView *)[cell viewWithTag:3];

    ratingsImage.image= [current ratings_image];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //uncomment beloew for manual seque trigger
    //[self performSegueWithIdentifier:@"showDetail" sender:nil];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    shopsDetailViewController *dvc= [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Shop *s = [self.shops objectAtIndex:path.row];
   
    [dvc setShop:s];
    [dvc setCurrentLocation:self.currentLocation];
}



/**************** Methods ************************/
-(void)loadShops{
    NSLog(@"loading shops");
    self.shops = [[NSMutableArray alloc] init];
    
    //max number of shops before we stop hitting the api
    self.total_available = 50;
    self.offset= 0;
    self.loading_more_shops = YES;
    
    [self.shops removeAllObjects];
    [self.tableView reloadData];
    
    self.location= [CLLocationManager new];
    
    [self.location setDelegate:self];
    [self.location setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.location setDistanceFilter:kCLDistanceFilterNone];
    [self.location startUpdatingLocation];
}

-(void)fetchShops{
    
    /** get shops from api **/
    NSString *api_query = [NSString stringWithFormat:@"http://onlyindie.herokuapp.com/api/coffee?lat=%f&lng=%f&offset=%d", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude, self.offset];
    NSLog(@"%@", api_query);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: api_query]];
    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    
}

-(void)fetchedData:(NSData *)responseData{
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *businesses = [json objectForKey:@"businesses"];
    self.offset += (int)[businesses count];
    
    if(![businesses count]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Where's the shops?"
                                                       message: @"Didn't find any shops in your area. Suck. Try pulling to refresh"
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
        
        [alert show];
    }
   
    for(id key in businesses){
        
        Shop *shop= [[Shop alloc] init];
        [shop setName:[key objectForKey:@"name"]];
        
        NSDictionary *location= [key objectForKey:@"location"];
        NSDictionary *coordinates= [location objectForKey:@"coordinate"];
        
        NSMutableArray *addressArray= [location objectForKey:@"address"];
        
        [shop setLatitude:[coordinates objectForKey:@"latitude"]];
        [shop setLongitude:[coordinates objectForKey:@"longitude"]];
        
        [shop setState: [location objectForKey:@"state_code"]];
        [shop setCity: [location objectForKey:@"city"]];
        [shop setZip: [location objectForKey:@"postal_code"]];
        
        //display address is an array
        NSString *location_as_text = @"";
        
        for(NSString *addressline in addressArray){
            location_as_text = [location_as_text stringByAppendingString:addressline];
            location_as_text = [location_as_text stringByAppendingString:@" "];
        }
        
        [shop setAddress: location_as_text];
        [shop setImage_url: [key objectForKey:@"image_url"]];
        [shop setReview_snippet:[key objectForKey:@"snippet_text"]];
        [shop setYelp_reviews_url:[key objectForKey:@"url"]];
        [shop setReview_count:[key objectForKey:@"review_count"]];
        [shop setPhone:[key objectForKey:@"phone"]];
        [shop setYelp_id:[key objectForKey:@"id"]];
        
        [shop setJsonAsData:key];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:key
                                                           options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [shop setJsonAsString:jsonString];
        
        CLLocation *locationA = [[CLLocation alloc] initWithLatitude:[shop.latitude doubleValue] longitude:[shop.longitude doubleValue]];
        
        CLLocationDistance distanceInMeters = [locationA distanceFromLocation: _currentLocation];
        
        [shop setDistanceInMeters:&distanceInMeters];
        
        NSNumber *miles =[[NSNumber alloc] initWithDouble:distanceInMeters * 0.000621371];
        
        [shop setDistanceInMiles:miles];
        
        //cache images in shop obj
        
        id path = shop.image_url;
        NSURL *url = [NSURL URLWithString:path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        
        if(img){
            [shop setImage:img];
        }else{
            [shop setImage:[UIImage imageNamed:@"noimage.png"]];
        }
      
        NSNumber *rating= [key objectForKey:@"rating"];
        
        [shop setLocalRating:rating];
        
        [self.shops addObject:shop];
    }
     
    
    NSArray *sortShops = [self.shops sortedArrayUsingSelector:@selector(compareDistance:)];
    self.shops = [NSMutableArray arrayWithArray:sortShops];
    
    [self.tableView reloadData];
    self.loading_more_shops = NO;
    [self.refreshControl endRefreshing];
    
    [self.loadingIndicator stopAnimating];
    self.loadingIndicator.hidden= YES;
}
- (void)handleEnterForeground:(NSNotification*)sender{
    NSLog(@"handleEnterForeground");
}

-(void)reloadShops{
    [self loadShops];
}

/************** locationManager Methods *******************/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"updating location %d", self.locationUpdates);
    
    if([locations count] > 0) {
        self.locationUpdates++;
    }
    
    if(self.locationUpdates >= 3){
        
        [self setCurrentLocation: [locations lastObject]];
        [[self location] stopUpdatingLocation];
        [self fetchShops];
    }
}




@end
