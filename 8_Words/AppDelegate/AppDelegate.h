//
//  AppDelegate.h
//  8_Words
//
//  Created by Jaideep on 3/5/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <FacebookSDK/FacebookSDK.h>
 extern NSString *const FBSessionStateChangedNotification;


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property NetworkStatus internetConnectionStatus;

@property (nonatomic, retain) NSMutableArray *wordsArray;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;


- (void)reachabilityChanged:(NSNotification *)note;
- (void)updateStatus;


- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;

- (void) sendRequest;



@end
