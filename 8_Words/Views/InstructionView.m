//
//  InstructionView.m
//  8_Words
//
//  Created by Jaideep on 3/12/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "InstructionView.h"
#import "SettingSingleton.h"
#import "WordsData.h"


@implementation InstructionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        setting=[SettingSingleton sharedInstance];
        wordData = [[WordsData alloc] init];
        [self initialize];
    }
    return self;
}

-(void) initialize {
    
    [self setUnderBackgroundimage];
    [self backArrowButton];
}


-(void) setUnderBackgroundimage{
    
    underRightImage = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ( [UIScreen mainScreen].bounds.size.height == 568){
        
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"instruction_iphone5.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        underRightImage.image = image;
        
    }else{
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"instruction_iphone4.jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        underRightImage.image = image;
        
        
    }
    [self addSubview:underRightImage];
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
