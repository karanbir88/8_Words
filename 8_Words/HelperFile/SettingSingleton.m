
//  SettingSingleton.m
//  SpeedySpeechR
//
//  Created by Jaideep on 10/20/12.
//  Copyright (c) 2012 Yrals. All rights reserved.
//

#import "SettingSingleton.h"

static SettingSingleton *sharedInstance = nil;


@implementation SettingSingleton
@synthesize value,userDefault;

+(id)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[SettingSingleton alloc] init];
    }
    return sharedInstance;
}
-(id) init
{
    if ((self = [super init] )) {
        userDefault = [NSUserDefaults standardUserDefaults];
        
        [self loadOnOffValue];
        [self readOnOffValue];
    }
    
    return self;
}

-(void)loadOnOffValue
{
    //check guset mode on / off
    on = [userDefault boolForKey:[NSString stringWithFormat:@"%d",1]];
    
    //Set default always 0
    [self setDefaultValueToZero:0];
    
    NSLog(@"loadOnOffValue  ____ ");

}

-(void)setDefaultValueToZero:(int) _offvalue
{
    on = FALSE;
    [userDefault setBool:on forKey:[NSString stringWithFormat:@"%d",0]];
    
    NSLog(@"setDefaultValue  ____ %d",_offvalue);
}

-(void) readOnOffValue
{
    if (on) {
        on = TRUE;
        [userDefault integerForKey:@"1"];
        value = 1;
        
        NSLog(@"onoffValue ____ %d",value);

    
    }
    else
    {
        on = FALSE;
         [userDefault integerForKey:@"0"];
        value = 0;
        NSLog(@"onoffValue ____ %d",value);

    }

}

-(void) updateOnOffValue:(int) _value
{
    NSLog(@"updateOnOffValue_____ %d",_value);
    if (_value == 1)
    {
        
        value = 1;
        [userDefault setInteger:1 forKey:@"1"];

    }
    else
    {
        value = 0;
        [userDefault setInteger:0 forKey:@"0"];
    }
}

-(int) returnUpdatedValue
{
    
    NSLog(@"Return Updated Value %d",value);
    return value;
}














@end
