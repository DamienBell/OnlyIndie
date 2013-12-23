//
//  shopsDetailViewController.m
//  Only Indie Coffee
//
//  Created by Damien Bell on 11/23/13.
//  Copyright (c) 2013 Damien Bell. All rights reserved.
//

#import "shopsDetailViewController.h"

@interface shopsDetailViewController ()
- (void)configureView;

@end

@implementation shopsDetailViewController: UIViewController{
    //IBOutlet UIImageView *ratings_image;
}

//over ride UIViewController method to prevend autoscrolling
-(BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

@synthesize shop= _shop;

- (void)configureView
{
    // Update the user interface for the detail item.
    self.navigationItem.title = _shop.name;

    NSString *address= [NSString stringWithFormat:@"%@\n\n", _shop.name];
    address= [address stringByAppendingString:[NSString stringWithFormat:@"%@\n", _shop.address]];
    address= [address stringByAppendingString:[NSString stringWithFormat:@"%@ %@ %@\n", _shop.city, _shop.state, _shop.zip]];
    
    [self.address_text setText:address];
    [self.review_text setText:_shop.review_snippet];
    
    self.address_text.allowsEditingTextAttributes= NO;
    [self.address_text setEditable:NO];
    
    UIImage *stars= _shop.ratings_image;
    [self.ratings_image setImage:stars];
    [self.num_reviews setText:[NSString stringWithFormat:@"%@ reviews", self.shop.review_count]];
    
    [self.fourSquareButton setHidden:YES];
    
    [self checkFourSquareAvailable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)checkFourSquareAvailable{
    
    NSLog(@"checking for foursquare");
    NSString *encoded_name = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                   (CFStringRef)self.shop.name,
                                                                                                   NULL,
                                                                                                   CFSTR(":/=,!$& '()*+;[]@#?"),
                                                                                                   kCFStringEncodingUTF8));
    
    NSString *api_query = [NSString stringWithFormat:@"http://onlyindie.herokuapp.com/api/foursquare/isavailable?ll=%@,%@&query=%@", self.shop.latitude, self.shop.longitude, encoded_name];
    
    NSLog(@"%@", api_query);
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:api_query]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] init];
    [self setCheckFourSquareConnection:conn];
    (void)[self.checkFourSquareConnection initWithRequest:request delegate:self];
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"connectionDidFinishLoading");
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:nil];
    if (connection == self.checkFourSquareConnection){
        
        NSString *foursquare_id= [json objectForKey:@"id"];
        NSString *foursquare_url= [json objectForKey:@"canonicalUrl"];
        
        if(foursquare_id){
            self.shop.foursquare_id= foursquare_id;
            self.shop.foursquare_url= foursquare_url;
            [self.fourSquareButton setHidden:NO];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Connection Error"
                                                   message: @"Problem connecting to the interwebs... bummer"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK",nil];
    
    [alert show];
}
/** end nsurl delegate **/

//actions
- (IBAction)open_in_yelp:(id)sender {
    [self.shop showInYelp];
}

- (IBAction)open_in_map:(id)sender {
 
    [self.shop openInMaps:[self.currentLocation coordinate]];
}

- (IBAction)open_in_foursquare:(id)sender {
    [self.shop showInFourSquare];
}

@end
