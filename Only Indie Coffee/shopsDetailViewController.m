//
//  shopsDetailViewController.m
//  Only Indie Coffee
//
//  Created by Damien Bell on 11/23/13.
//  Copyright (c) 2013 Damien Bell. All rights reserved.
//

#import "shopsDetailViewController.h"
#import "AsyncImageView.h"
#import <Social/Social.h>

@interface shopsDetailViewController ()
- (void)configureView;

@end

@implementation shopsDetailViewController: UIViewController{
 
}

//over ride UIViewController method to prevend autoscrolling
-(BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

@synthesize shop= _shop;

- (void)configureView
{
    
    //self.imageScroller.delegate = self;
    // Update the user interface for the detail item.
    self.navigationItem.title = _shop.name;

    [self.shopNameLabel setText:[_shop name]];
    
    NSString *address= [NSString stringWithFormat:@"%@\n", _shop.address];
    address= [address stringByAppendingString:[NSString stringWithFormat:@"%@ %@ %@\n", _shop.city, _shop.state, _shop.zip]];
    
    NSLog(@"%@", address);
    [self.address_text setText:address];
    
    [self.review_text setText:_shop.review_snippet];
    
    self.address_text.allowsEditingTextAttributes= NO;
    [self.address_text setEditable:NO];
    [self.address_text setFont:[UIFont fontWithName:@"ProximaNovaLightItalic" size:14.0f]];

    self.review_text.allowsEditingTextAttributes = NO;
    [self.address_text setEditable:NO];
    
    NSString *distance = [NSString stringWithFormat:@"%@ miles",
                          [NSString stringWithFormat:@"%.2f",[_shop.distanceInMiles doubleValue]]];
    
    UILabel *distancelabel;
    distancelabel= (UILabel *)[self.view viewWithTag:5];
    [distancelabel setText:distance];
    
    UIImage *stars= _shop.ratings_image;
    [self.ratings_image setImage:stars];
    [self.num_reviews setText:[NSString stringWithFormat:@"%@ reviews", self.shop.review_count]];
    
    [self.thumbnail setImage:_shop.image];
    [self.fourSquareButton setHidden:YES];
    
    [self checkFourSquareDetails];
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

-(void)checkFourSquareDetails{
    
    NSLog(@"checking for foursquare details");
    NSString *encoded_name = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                   (CFStringRef)self.shop.name,
                                                                                                   NULL,
                                                                                                   CFSTR(":/=,!$& '()*+;[]@#?"),
                                                                                                   kCFStringEncodingUTF8));
    
    NSString *api_query = [NSString stringWithFormat:@"http://onlyindie.herokuapp.com/api/foursquare/photos?ll=%@,%@&query=%@", self.shop.latitude, self.shop.longitude, encoded_name];
    
    NSLog(@"%@", api_query);
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:api_query]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] init];
    [self setFourSquareURLConnection:conn];
    (void)[self.fourSquareURLConnection initWithRequest:request delegate:self];
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
    [self setFourSquareURLConnection:conn];
    (void)[self.fourSquareURLConnection initWithRequest:request delegate:self];
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
    if (connection == self.fourSquareURLConnection){
        
        NSString *foursquare_id= [json objectForKey:@"id"];
        NSString *foursquare_url= [json objectForKey:@"canonicalUrl"];
        
        
        
        if(foursquare_id){
            //set foursquare details
            self.shop.foursquare_id= foursquare_id;
            self.shop.foursquare_url= foursquare_url;
            [self.imageScroller setImages:[json objectForKey:@"photos"]];
            
            /*

            }
             */
            
            //set twitter/ facebook details
            //set shop.website
            //set phone details array
            //set photos
            
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
/*
 
 BOOL available= NO;
 SLComposeViewController *socialViewController= nil;
 
 NSDictionary *details= [pageDetails objectAtIndex:currentPageNumber-1];
 NSString *title= [details objectForKey:@"title_string"];
 
 switch (buttonIndex) {
 
 case 0:
 //facebook share
 if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
 NSLog(@"facebook is available");
 available= YES;
 
 socialViewController= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
 [socialViewController setInitialText:[NSString stringWithFormat:@"Check out %@ from Dark Rye.", title]];
 [socialViewController addURL:social_link];
 [self presentViewController:socialViewController animated:YES completion:nil];
 
 }else{
 
 NSLog(@"facebook not available, link: %@", social_link);
 }
 break;
 
 case 1:
 //twitter share
 if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
 NSLog(@"compose tweet");
 available= YES;
 
 socialViewController= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
 [socialViewController setInitialText:[NSString stringWithFormat:@"Check out %@ from Dark Rye.", title]];
 [socialViewController addURL:social_link];
 
 [self presentViewController:socialViewController animated:YES completion:nil];
 
 }else{
 NSLog(@"twitter not available");
 }
 break;
 
 case 2:
 //email
 if([MFMailComposeViewController canSendMail]){
 
 available= YES;
 NSLog(@"email is available");
 
 MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
 mailViewController.mailComposeDelegate = self;
 
 [mailViewController setSubject:title];
 
 NSString *anchor_tag= [NSString stringWithFormat:@"<p>Check out this article from Dark Rye: </p><a href='%@'>%@</a>",
 [social_link absoluteString],
 title,
 nil];
 
 [mailViewController setMessageBody:anchor_tag isHTML:YES];
 [self presentViewController:mailViewController animated:YES completion:nil];
 [mailViewController release];
 
 }else{
 NSLog(@"email not available");
 }
 break;
 
 default:
 //cancelled
 //we're going to flag this as available so we don't trigger the "service not available" modal
 NSLog(@"cancelled share");
 available= YES;
 [socialViewController dismissViewControllerAnimated:YES completion:nil];
 [socialViewController release];
 
 break;
 */


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

- (IBAction)initTweet:(id)sender {
   
    SLComposeViewController *socialViewController= nil;
    
    socialViewController= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [socialViewController setInitialText:[NSString stringWithFormat:@"Check out %@ via.", _shop.name]];
    //[socialViewController addURL:social_link];
    [self presentViewController:socialViewController animated:YES completion:nil];
}
@end
