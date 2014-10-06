//
//  InfoViewController.h
//  8_Words
//
//  Created by Jaideep on 4/11/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WordsData.h"

@class WordsData;

@interface InfoViewController : ViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>{

}

-(IBAction)back:(id)sender;
-(IBAction)sendFeedback:(id)sender;
-(IBAction)shareonFacebook:(id)sender;
-(IBAction)shareonTwitter:(id)sender;


@end
