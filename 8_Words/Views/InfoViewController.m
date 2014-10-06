//
//  InfoViewController.m
//  8_Words
//
//  Created by Jaideep on 4/11/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "InfoViewController.h"
#import "WordsData.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>

@interface InfoViewController ()

@end

@implementation InfoViewController

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
    wordData = [[WordsData alloc] init];
    
    [self setUnderBackgroundimage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setUnderBackgroundimage{
    // rightscreen_theme1_iphone.png
    
    if ( [UIScreen mainScreen].bounds.size.height == 568){
        
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"info_iphone5.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        underRightImage.image = image;
        
    }else{
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"info_iphone4.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        underRightImage.image = image;
        
        
    }
    
}
-(IBAction)back:(id)sender{
    
    [self dismissModalViewControllerAnimated:NO];
}
-(IBAction)sendFeedback:(id)sender{
    
//    
//    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//    mc.mailComposeDelegate = self;
//    
//    // Email Subject
//    NSString *emailTitle = @"8 Words builder";
//    // Email Content
//    NSString *messageBody = @"I'm having fun with words, playing 8 Words Builder. Join me and let's have fun.\n\n https://itunes.apple.com/in/app/8wordsbuilder/id634905411?mt=8"; // Change the message body to HTML
//    // To address
//    NSArray *toRecipents = [NSArray arrayWithObject:@"8wordsbuilder@gmail.com"];
//
//    
//    [mc setSubject:emailTitle];
//    [mc setMessageBody:messageBody isHTML:YES];
//    [mc setToRecipients:toRecipents];
//    
//    // Present mail view controller on screen
//    [self presentViewController:mc animated:YES completion:nil];
//
  
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        
            // Email Subject
            NSString *emailTitle = @"8 Words builder";
            // Email Content
            NSString *messageBody = @"I'm having fun with words, playing 8 Words Builder HD. Join me and let's have fun.\n\n https://itunes.apple.com/us/app/8-words-builder-hd/id641535883?ls=1&mt=8"; // Change the message body to HTML
            // To address
            NSArray *toRecipents = [NSArray arrayWithObject:@"8wordsbuilder@gmail.com"];


            [mailComposeViewController setSubject:emailTitle];
            [mailComposeViewController setMessageBody:messageBody isHTML:YES];
            [mailComposeViewController setToRecipients:toRecipents];
            mailComposeViewController.mailComposeDelegate = self;
         
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
        
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"e-Mail Sending Alert"
                                                        message:@"You can't send a mail.Please configure it."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)shareonFacebook:(id)sender{
    
    
    NSLog(@"System Version is %@",[[UIDevice currentDevice] systemVersion]);
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float < 6.0)
        
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Update iOS to iOS 6.0" message:@"To share it requires iOS 6.0" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:@"I'm having fun with words, playing 8 Words Builder HD. Join me and let's have fun"];
        
        //Adding the URL to the facebook post value from iOS
        
        [controller addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/8-words-builder-hd/id641535883?ls=1&mt=8"]];
        
        //Adding the Image to the facebook post value from iOS
        
        [controller addImage:[UIImage imageNamed:@"iTunesArtwork.png"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    else
    {
        NSLog(@"UnAvailable");
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a post to facebook right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    
    [Flurry logEvent:@"Facebook buttonCliked"];
    

}
-(IBAction)shareonTwitter:(id)sender{
    
    
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet =
        [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:@"I'm having fun with words, playing 8 Words Builder HD. Join me and let's have fun"];
        [self presentModalViewController:tweetSheet animated:YES];
        [tweetSheet addImage:[UIImage imageNamed:@"iTunesArtwork.png"]];
        [tweetSheet addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/8-words-builder-hd/id641535883?ls=1&mt=8"]];
        
        
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

   [Flurry logEvent:@"Twitter buttonCliked"];


}

-(void) soundON_OFF:(int) _soundValue{
    
    if (_soundValue == 1) {
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"oneclick" ofType:@"mp3"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFilePath], &soundID);
        AudioServicesPlaySystemSound (soundID);
        
    }
    else
    {
        NSLog(@"Sound is desabled.");
    }
}



@end
