//
//  OptionView.m
//  8_Words
//
//  Created by Jaideep on 3/12/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "OptionView.h"
#import "HMCustomSwitch.h"
#import "SettingSingleton.h"
#import "WordsData.h"
#import "CustomRoundSwitch.h"
#import <QuartzCore/QuartzCore.h>

@implementation OptionView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor yellowColor]];
        wordData =[[ WordsData alloc] init];
        setting =[ SettingSingleton sharedInstance];
        
        // Initialization code
        [self initialize];
    }
    return self;
}

-(void) initialize{
    [self setUnderBackgroundimage];
    [self switchButtons];
    [self backArrowButton];
    
}



-(void) setUnderBackgroundimage{
    
    underRightImage = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ( [UIScreen mainScreen].bounds.size.height == 568)
    {
        
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"option_bgiphone5.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        underRightImage.image = image;
        
    }
    else
    {
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"option_bgiphone4.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        underRightImage.image = image;
        
        
    }
    [self addSubview:underRightImage];
}


#pragma mark-
-(void) switchButtons{
    
    
    NSLog(@"Option view View %d",[wordData getGeneralSound]);
    HMCustomSwitch *option = [[HMCustomSwitch alloc] init];
    option.frame = CGRectMake(528, 294, 144, 50);

    if ([wordData getGeneralSound] == 1)
        option.on = YES;
    else
        option.on=NO;
    
    [option addTarget:self action:@selector(optionSwitch:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:option];
    
    HMCustomSwitch *fbshare = [[HMCustomSwitch alloc] init];
    fbshare.frame = CGRectMake(528, 394, 144, 50);
    
    if ([wordData getbuttonSound] == 1)
        fbshare.on = YES;
    else
        fbshare.on=NO;
    
    [fbshare addTarget:self action:@selector(FBShareSwitch:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:fbshare];
    
    HMCustomSwitch *twittershare = [[HMCustomSwitch alloc] init];
    twittershare.frame = CGRectMake(528, 494, 144, 50);
    
    if ([wordData getLevelCompletesound] == 1)
        twittershare.on = YES;
    else
        twittershare.on=NO;
    
    [twittershare addTarget:self action:@selector(TwitterShareSwitch:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:twittershare];
    

    

}


#pragma mark-
-(void) optionSwitch:(HMCustomSwitch *) _customSwitch{
    
    NSLog(@"Sound Value %d",(int)_customSwitch.on);
    //[setting updateOnOffValue:(int)_customSwitch.on];
    
    [wordData updateGeneralSound:(int)_customSwitch.on];
    
    NSLog(@"optionSwitch=%f  on:%@",_customSwitch.value, (_customSwitch.on?@"Y":@"N"));
    
    
    
}

-(void) FBShareSwitch:(HMCustomSwitch *) _customSwitch{
    
    NSLog(@"FBShareSwitch=%f  on:%@",_customSwitch.value, (_customSwitch.on?@"Y":@"N"));
    [wordData updateButtonSound:(int)_customSwitch.on];

    
}
-(void) TwitterShareSwitch:(HMCustomSwitch *) _customSwitch{
    NSLog(@"TwitterShareSwitch=%f  on:%@",_customSwitch.value, (_customSwitch.on?@"Y":@"N"));
    [wordData updateLevelCompleteSound:(int)_customSwitch.on];
    
}


#pragma mark-
#pragma BackButton
-(void) backArrowButton{
    
    UIButton *backArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    backArrow.frame = CGRectMake(0, 0, 80, 80);
    [backArrow setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backArrow addTarget:self action:@selector(removeLavelsView) forControlEvents:UIControlEventTouchUpInside];
    
    //Adding a button to the view
    [self addSubview:backArrow];
    
}

-(void) removeLavelsView{
    [self removeFromSuperview];
    [self soundON_OFF:[wordData getGeneralSound]];
    
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





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
