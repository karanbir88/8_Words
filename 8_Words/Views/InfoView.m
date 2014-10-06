//
//  InfoView.m
//  8_Words
//
//  Created by Jaideep on 3/12/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "InfoView.h"
#import "SettingSingleton.h"


@implementation InfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor purpleColor]];
        setting    =[SettingSingleton sharedInstance];
        
        [self initialize];
    }
    return self;
}

-(void) initialize{
    [self setUnderBackgroundimage];
    [self backArrowButton];
    [self contactus];
    
}



-(void) setUnderBackgroundimage{
    
    underRightImage = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ( [UIScreen mainScreen].bounds.size.height == 568){
        
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"info_iphone5.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        underRightImage.image = image;
        
    }else{
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"info_iphone4.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        underRightImage.image = image;
        
        
    }
    [self addSubview:underRightImage];
}

-(void) contactus{
    
    UIButton *backArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    backArrow.frame = CGRectMake(90, 273, 137, 41);
    [backArrow setImage:[UIImage imageNamed:@"contactus.png"] forState:UIControlStateNormal];
    [backArrow addTarget:self action:@selector(contactuspage) forControlEvents:UIControlEventTouchUpInside];
    
    //Adding a button to the view
    [self addSubview:backArrow];

}

-(void) contactuspage{
    
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://yrals.com"]];
    
//    // Email Subject
//    NSString *emailTitle = @"Test Email";
//    // Email Content
//    NSString *messageBody = @"<h1>Learning iOS Programming!</h1>"; // Change the message body to HTML
//    // To address
//    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
//    
//    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//    mc.mailComposeDelegate = self;
//    [mc setSubject:emailTitle];
//    [mc setMessageBody:messageBody isHTML:YES];
//    [mc setToRecipients:toRecipents];
//    
//    // Present mail view controller on screen
//    [self.window.rootViewController presentViewController:mc animated:YES completion:NULL];
//
    
    
}


#pragma mark-
#pragma BackButton
-(void) backArrowButton{
    
    UIButton *backArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    backArrow.frame = CGRectMake(0, 0, 40, 40);
    [backArrow setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backArrow addTarget:self action:@selector(removeLavelsView) forControlEvents:UIControlEventTouchUpInside];
    
    //Adding a button to the view
    [self addSubview:backArrow];
    
}

-(void) removeLavelsView{
    
    [self soundON_OFF:[setting returnUpdatedValue]];
    [self removeFromSuperview];
    
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
