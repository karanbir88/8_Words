//
//  ViewController.h
//  8_Words
//
//  Created by Jaideep on 3/5/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"



//forword declaration...
@class CategoryView;
@class InstructionView;
@class InfoView;
@class OptionView;
@class SettingSingleton;
@class WordsData;
@class GAITrackedViewController;

@interface ViewController : UIViewController{
    
    //All Views
    CategoryView            *categoryView;
    InstructionView         *instructionView;
    InfoView                *infoView;
    OptionView              *optionView;
    
    IBOutlet UIImageView    *underRightImage;
    SettingSingleton        *setting;
    
    WordsData               *wordData;
    
    GAITrackedViewController *gaiTracker;
    
    IBOutlet UILabel         *lblName;
    IBOutlet FBProfilePictureView *profilePic;

}
@property (nonatomic, retain) IBOutlet FBProfilePictureView *profilePic;
@property (nonatomic , retain)  NSString *stringURL;
@property (nonatomic, retain)     NSMutableData		*webData;
@property (nonatomic,retain) NSString *_User;


-(IBAction)faceBook:(id)sender;


@end
