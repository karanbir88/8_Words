//
//  MyAccount.m
//  8_Words HD
//
//  Created by Jaideep on 6/7/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "MyAccount.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>



@interface MyAccount ()

@end

@implementation MyAccount
@synthesize profilePic = _profilePic;
@synthesize webData,stringURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
    
    
    //set intially button hidden
    share.hidden=YES;
    request.hidden=YES;
    tweet.hidden =YES;
    self.profilePic.hidden = YES;
    lblText.hidden = NO;
    
    
    
    
    [self setUnderBackgroundimage];
    
}

-(void) setUnderBackgroundimage{
    // rightscreen_theme1_iphone.png
    
    if ( [UIScreen mainScreen].bounds.size.height == 568){
        
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"levelbg5.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        underRightImage.image = image;
        
    }else{
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"levelbg.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        underRightImage.image = image;
        
        
    }
    
    lblText.textColor = [UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0];
    lblText.font = [UIFont fontWithName:@"Dungeon" size:44.0];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        
        share.hidden=NO;
        request.hidden=NO;
        tweet.hidden=NO;
        self.profilePic.hidden = NO;
        lblText.hidden = YES;
        
        [registerbtn setTitle:@"Logout" forState:UIControlStateNormal];
        [share setTitle:@"Share" forState:UIControlStateNormal];
        [request setTitle:@"Invite friends" forState:UIControlStateNormal];
        [tweet setTitle:@"Tweet" forState:UIControlStateNormal];
        
        registerbtn.titleLabel.font = [UIFont fontWithName:@"Dungeon" size:50.0];
        share.titleLabel.font = [UIFont fontWithName:@"Dungeon" size:50.0];
        request.titleLabel.font = [UIFont fontWithName:@"Dungeon" size:50.0];
        tweet.titleLabel.font = [UIFont fontWithName:@"Dungeon" size:50.0];
        
        [registerbtn setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
        [share setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
        [request setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
        [tweet setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
        
    } else {
        share.hidden=YES;
        request.hidden=YES;
        lblName.text = @"";
        self.profilePic.hidden = YES;
        lblText.hidden=NO;
        
        [registerbtn setTitle:@"Register" forState:UIControlStateNormal];
        [registerbtn setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
        registerbtn.titleLabel.font = [UIFont fontWithName:@"Dungeon" size:28.0];;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //[FlurryAds setAdDelegate:nil];
}



- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:NO];
}

- (IBAction)sendRequest:(id)sender {
    
    AppDelegate *appDelegate =
    (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (FBSession.activeSession.isOpen) {
        [appDelegate sendRequest];
    }
}

-(IBAction)login:(id)sender{
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    // If the person is authenticated, log out when the button is clicked.
    // If the person is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The person has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
    
}
- (void)sessionStateChanged:(NSNotification*)notification {
    
    if (FBSession.activeSession.isOpen) {
        
        
        share.hidden=NO;
        request.hidden=NO;
        tweet.hidden=NO;
        self.profilePic.hidden = NO;
        lblText.hidden = YES;
        
        [registerbtn setTitle:@"Logout" forState:UIControlStateNormal];
        [share setTitle:@"Share" forState:UIControlStateNormal];
        [request setTitle:@"Invite friends" forState:UIControlStateNormal];
        [tweet setTitle:@"Tweet" forState:UIControlStateNormal];
        
        registerbtn.titleLabel.font = [UIFont fontWithName:@"Dungeon" size:50.0];
        share.titleLabel.font = [UIFont fontWithName:@"Dungeon" size:50.0];
        request.titleLabel.font = [UIFont fontWithName:@"Dungeon" size:50.0];
        tweet.titleLabel.font = [UIFont fontWithName:@"Dungeon" size:50.0];
        
        [registerbtn setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
        [share setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
        [request setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
        [tweet setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
        
        
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             if (!error) {
                 NSString *userInfo = @"";
                 
                 // Example: typed access (name)
                 // - no special permissions required
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Name: %@\n\n",
                              user.name]];
                 
                 // Example: typed access, (birthday)
                 // - requires user_birthday permission
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Birthday: %@\n\n",
                              user.birthday]];
                 
                 // Example: partially typed access, to location field,
                 // name key (location)
                 // - requires user_location permission
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Location: %@\n\n",
                              [user.location objectForKey:@"name"]]];
                 
                 // Example: access via key (locale)
                 // - no special permissions required
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Locale: %@\n\n",
                              [user objectForKey:@"locale"]]];
                 
                 // Example: access via key for array (languages)
                 // - requires user_likes permission
                 if ([user objectForKey:@"languages"]) {
                     NSArray *languages = [user objectForKey:@"languages"];
                     NSMutableArray *languageNames = [[NSMutableArray alloc] init];
                     for (int i = 0; i < [languages count]; i++) {
                         [languageNames addObject:[[languages
                                                    objectAtIndex:i]
                                                   objectForKey:@"name"]];
                     }
                     userInfo = [userInfo
                                 stringByAppendingString:
                                 [NSString stringWithFormat:@"Languages: %@\n\n",
                                  languageNames]];
                     
                     
                     
                 }
                 
                 NSLog(@"User ID %@", user.id);
                 self.profilePic.profileID = user.id;
                 
                 // Display the user info
                 userInfoTextView.text = userInfo;
                 lblName.text = [NSString stringWithFormat:@"Hello %@!",user.name];
                 lblName.font = [UIFont fontWithName:@"Dungeon" size:44.0f];
                 lblName.textColor = [UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0];
                 lblName.textAlignment = UITextAlignmentCenter;
                 
                 //Start of Post method :)
                 
                 
                 NSString *post =
                 [[NSString alloc] initWithFormat:@"profileid=%@&name=%@&birthday=%@&location=%@&locale=%@&comeFrom=%@",user.id,user.name,user.birthday,[user.location objectForKey:@"name"],[user objectForKey:@"locale"],@"iPhone"];
                 
                 
                 NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                 
                 NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
                 
                 NSURL *url = [NSURL URLWithString:@"http://social-brand.in/apps/8words_builder/uploadInfo.php"];
                 NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
                 [theRequest setHTTPMethod:@"POST"];
                 [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
                 [theRequest setHTTPBody:postData];
                 
                 
                 NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
                 
                 if( theConnection )
                 {
                     webData = [NSMutableData data];
                     NSLog(@"WebData %@",webData);
                 }
                 else
                 {
                     
                 }
                 //End of POST method
                 
                 
             }
         }];
        
    }
    
    else
        
    {
        share.hidden=YES;
        request.hidden=YES;
        tweet.hidden=YES;
        lblName.text = @"";
        self.profilePic.hidden = YES;
        lblText.hidden=NO;
        
        [registerbtn setTitle:@"Register" forState:UIControlStateNormal];
        [registerbtn setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
        registerbtn.titleLabel.font = [UIFont fontWithName:@"Dungeon" size:28.0];;
        
        
    }
    
}



/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}


- (IBAction)facebookPublish:(id)sender {
    
    // Put together the dialog parameters
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"8 Words Builder HD", @"name",
     @"Try to recall your old school lectures.", @"caption",
     @"I'm having fun with words, playing 8 Words Builder. Join me and let's have fun.", @"description",
     @"https://itunes.apple.com/in/app/8wordsbuilder/id634905411?mt=8", @"link",
     @"http://social-brand.in/test/logo.png", @"picture",
     nil];
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
                 
                 
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted story, id: %@",
                                      [urlParams valueForKey:@"post_id"]];
                     NSLog(@"%@", msg);
                     // Show the result in an alert
                     [[[UIAlertView alloc] initWithTitle:@"Successful!"
                                                 message:nil
                                                delegate:nil
                                       cancelButtonTitle:@"OK!"
                                       otherButtonTitles:nil]
                      show];
                 }
             }
         }
     }];
    
}


-(IBAction)tweet:(id)sender{
    
    
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet =
        [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:@"I'm having fun with words, playing 8 Words Builder. Join me and let's have fun"];
        [self presentModalViewController:tweetSheet animated:YES];
        [tweetSheet addImage:[UIImage imageNamed:@"iTunesArtwork.png"]];
        [tweetSheet addURL:[NSURL URLWithString:@"https://itunes.apple.com/in/app/8wordsbuilder/id634905411?mt=8"]];
        
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    
}

@end

