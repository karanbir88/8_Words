//
//  ViewController.m
//  8_Words
//
//  Created by Jaideep on 3/5/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "ViewController.h"
#import "CategoryView.h"
#import "LevelsView.h"
#import "SingleLevelView.h"
#import "InstructionView.h"
#import "InfoView.h"
#import "OptionView.h"
#import "SettingSingleton.h"
#import "WordsData.h"

#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "InfoViewController.h"
#import "MyAccount.h"



#import "GAITrackedViewController.h"
#import "GAI.h"

@interface ViewController ()

@end

@implementation ViewController


@synthesize profilePic = _profilePic;
@synthesize webData,stringURL,_User;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
    

    
    [self initialize];
    [Flurry logEvent:@"Home View"];
    gaiTracker.trackedViewName = @"Home View";
    [gaiTracker.tracker sendView:@"Home View"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
       self.profilePic.hidden = NO;
        categoryView.userID = _User;


        
    } else
    {
        self.profilePic.hidden = YES;
            lblName.text=@"";
    }

    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[FlurryAds setAdDelegate:nil];
}

#pragma mark- Initialize
//Initialize the all views
-(void) initialize{
    
    setting = [SettingSingleton sharedInstance];
    wordData = [[WordsData alloc] init];
    
  //  categoryView  = [[CategoryView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    instructionView = [[InstructionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    infoView  = [[InfoView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    optionView  = [[OptionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setUnderBackgroundimage];
    
    
}

#pragma mark-Actions

-(IBAction)play:(id)sender{
    NSLog(@" optionView.soundValue %d",[setting returnUpdatedValue]);
    
    [self soundON_OFF:[wordData getGeneralSound]];

    categoryView = [[CategoryView alloc] init];
    [self presentModalViewController:categoryView animated:NO];

    [Flurry logEvent:@"Play buttonCliked"];
    
    if ([_User length] !=0) {
        NSLog(@"User %@",_User);
        categoryView.userID = _User;
    }

    
}

-(IBAction)instruction:(id)sender{
    
    [self soundON_OFF:[wordData getGeneralSound]];

    [self.view addSubview:instructionView];
    [Flurry logEvent:@"Instruction buttonCliked"];

}

-(IBAction)info:(id)sender{
    [self soundON_OFF:[wordData getGeneralSound]];

    //[self.view addSubview:infoView];
    
    InfoViewController *_info = [[InfoViewController alloc] init];
    [self presentModalViewController:_info animated:NO];
    
    [Flurry logEvent:@"Info buttonClicked"];

    
}

-(IBAction)option:(id)sender{
    
    optionView  = [[OptionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self soundON_OFF:[wordData getGeneralSound]];
    [self.view addSubview:optionView];
    [Flurry logEvent:@"Option buttonCliked"];

}

-(IBAction) myAccountPage{
    MyAccount *_info = [[MyAccount alloc] init];
    [self presentModalViewController:_info animated:NO];
    
    

}


-(void) soundON_OFF:(int) _soundValue{
    
    if (_soundValue == 1) {
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"oneclick" ofType:@"mp3"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFilePath], &soundID);
        AudioServicesPlaySystemSound (soundID);


    }
    else{
        NSLog(@"Sound is desabled.");
    }
}

-(void) setUnderBackgroundimage{
    // rightscreen_theme1_iphone.png
    
        
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"levelbg.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        underRightImage.image = image;
        
    
}



- (void)sessionStateChanged:(NSNotification*)notification {
    
    if (FBSession.activeSession.isOpen) {
        //[fac setTitle:@"Logout" forState:UIControlStateNormal];
        
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
                 //userInfoTextView.text = userInfo;
                categoryView.userID = user.id;
                 _User=user.id;
                 
                 lblName.text = [NSString stringWithFormat:@"Hello %@!",user.name];
                 lblName.font = [UIFont fontWithName:@"Dungeon" size:22.0f];
                 lblName.textColor = [UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0];
                 
                 //Start of Post method :)
                // comeFrom = @"iPhone"
                 
                 NSString *post =
                 [[NSString alloc] initWithFormat:@"profileid=%@&name=%@&birthday=%@&location=%@&locale=%@&comeFrom=%@",user.id,user.name,user.birthday,[user.location objectForKey:@"name"],[user objectForKey:@"locale"],@"iPad"];
                 
                 
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
        // [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
        
        
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

-(IBAction)faceBook:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.facebook.com/8WordsBuilder"]];    
}
- (IBAction)tweetTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://m.twitter.com/8WordsBuilder"]];

}





@end
