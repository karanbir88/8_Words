//
//  MyAccount.h
//  8_Words HD
//
//  Created by Jaideep on 6/7/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"


@interface MyAccount : UIViewController{
    
    IBOutlet UIImageView    *underRightImage;
    
    
    IBOutlet UITextView      *userInfoTextView;
    IBOutlet UILabel         *lblName;
    IBOutlet UILabel         *lblText;
    
    IBOutlet UIButton *registerbtn,*share,*request,*tweet,*logout;
    
    IBOutlet FBProfilePictureView *profilePic;
    
    
    
}
@property (nonatomic, retain) IBOutlet FBProfilePictureView *profilePic;
@property (nonatomic , retain)  NSString *stringURL;
@property (nonatomic, retain)     NSMutableData		*webData;



- (IBAction)login:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)sendRequest:(id)sender;

@end
