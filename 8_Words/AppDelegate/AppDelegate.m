//
//  AppDelegate.m
//  8_Words
//
//  Created by Jaideep on 3/5/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "WordsData.h"

//Google Analytics
#import "GAI.h"



NSString *const FBSessionStateChangedNotification = @"com.yrals.8wodrsbuilderhd:FBSessionStateChangedNotification";



@interface AppDelegate () <UIAlertViewDelegate>
@property (nonatomic, assign) BOOL appUsageCheckEnabled;
@end

@implementation AppDelegate
@synthesize  wordsArray = _wordsArray;
@synthesize appUsageCheckEnabled = _appUsageCheckEnabled;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    
    
    //initialize array
    NSMutableArray *tempArray =[[NSMutableArray alloc] init];
    _wordsArray = tempArray;
    
    //Copy database to the user's phone if needed.
    [self copyDatabaseIfNeeded];
    [WordsData getInitialDataToDisplay:[self getDBPath]];

    
    //Flurry initiate...
    [Flurry startSession:FlurryID];
    [FlurryAds initialize:self.window.rootViewController];
    
    
    
    
    
    //Google Analytics
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-40464944-1"];

    [tracker sendEventWithCategory:@"didFinishLaunchingWithOptions"
                        withAction:@"Application Launched" withLabel:@"AppDelegate" withValue:[NSNumber numberWithInt:101]];
    
    
    
    
    
    //sending a request
    // We will remember the user's setting if they do not wish to
    // send any more invites.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.appUsageCheckEnabled = YES;
    if ([defaults objectForKey:@"AppUsageCheck"]) {
        self.appUsageCheckEnabled = [defaults boolForKey:@"AppUsageCheck"];
    }
    
    
    [FBProfilePictureView class];
    

    
    
    return YES;
}






#pragma Mark-
#pragma DATABASE READ

-(void)copyDatabaseIfNeeded{
    
    //We are using file manager for file system manager...
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    
    BOOL success = [fileManger fileExistsAtPath:dbPath];
    
    if (!success) {
        NSString *defaultDBPAth =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"8_Words.sqlite"];
        success = [fileManger copyItemAtPath:defaultDBPAth toPath:dbPath error:&error];
        
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with messsage '%@'.", [error localizedDescription]);
            
        }
    }
    
    NSLog(@"I am in --> copyDatabaseIfNeeded");
}

-(NSString *)getDBPath{
    
    //Searching a standard documents using NSSearchPathForDirectoriesInDomains
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDir = [paths objectAtIndex:0];
    NSLog(@"I am in --> getDBPath");
    return [documentDir stringByAppendingPathComponent:@"8_Words.sqlite"];
    
    
    
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Check the flag for enabling any prompts. If that flag is on
    // check the app active counter
    if (self.appUsageCheckEnabled && [self checkAppUsageTrigger]) {
        // If the user should be prompter to invite friends, show
        // an alert with the choices.
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invite Friends"
                              message:@"If you enjoy using this app, would you mind taking a moment to invite a few friends that you think will also like it?"
                              delegate:self
                              cancelButtonTitle:@"No Thanks"
                              otherButtonTitles:@"Tell Friends!", @"Remind Me Later", nil];
        [alert show];
    }
    
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}


/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    //    return [FBSession openActiveSessionWithReadPermissions:nil
    //                                              allowLoginUI:allowLoginUI
    //                                         completionHandler:^(FBSession *session,
    //                                                             FBSessionState state,
    //                                                             NSError *error) {
    //                                             [self sessionStateChanged:session
    //                                                                 state:state
    //                                                                 error:error];
    //                                         }];
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_location",
                            @"user_birthday",
                            @"user_likes",
                            nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}


- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}




//Invitiing a friends
/*
 * This private method will be used to check the app
 * usage counter, update it as necessary, and return
 * back an indication on whether the user should be
 * shown the prompt to invite friends
 */
- (BOOL) checkAppUsageTrigger {
    // Initialize the app active count
    NSInteger appActiveCount = 0;
    // Read the stored value of the counter, if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"AppUsedCounter"]) {
        appActiveCount = [defaults integerForKey:@"AppUsedCounter"];
    }
    
    // Increment the counter
    appActiveCount++;
    BOOL trigger = NO;
    // Only trigger the prompt if the facebook session is valid and
    // the counter is greater than a certain value, 3 in this sample
    if (FBSession.activeSession.isOpen && (appActiveCount >= 3)) {
        trigger = YES;
        appActiveCount = 0;
    }
    // Save the updated counter
    [defaults setInteger:appActiveCount forKey:@"AppUsedCounter"];
    [defaults synchronize];
    return trigger;
}


/*
 * When the alert is dismissed check which button was clicked so
 * you can take appropriate action, such as displaying the request
 * dialog, or setting a flag not to prompt the user again.
 */

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // User has clicked on the No Thanks button, do not ask again
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"AppUsageCheck"];
        [defaults synchronize];
        self.appUsageCheckEnabled = NO;
    } else if (buttonIndex == 1) {
        // User has clicked on the Tell Friends button
        [self performSelector:@selector(sendRequest)
                   withObject:nil afterDelay:0.5];
    }
}



////send request
//- (void)sendRequest {
//    // Display the requests dialog
//    [FBWebDialogs
//     presentRequestsDialogModallyWithSession:nil
//     message:@"Learn how to make your iOS apps social."
//     title:nil
//     parameters:nil
//     handler:nil];
//}

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

/*
 * Send a user to user request
 */
- (void)sendRequest {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:@{
                        @"social_karma": @"5",
                        @"badge_of_awesomeness": @"1"}
                        options:0
                        error:&error];
    if (!jsonData) {
        NSLog(@"JSON error: %@", error);
        return;
    }
    NSString *giftStr = [[NSString alloc]
                         initWithData:jsonData
                         encoding:NSUTF8StringEncoding];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   giftStr, @"data",
                                   nil];
    
    // Display the requests dialog
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:@"Learn how to make your iOS apps social."
     title:nil
     parameters:params
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
             } else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 } else {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                 }
             }
         }
     }];
}


@end
