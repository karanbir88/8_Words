//
//  SettingSingleton.h
//  SpeedySpeechR
//
//  Created by Jaideep on 10/20/12.
//  Copyright (c) 2012 Yrals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingSingleton : NSObject{
    
    @public
    NSUserDefaults *userDefault;
    int value;
    bool on;
}
@property (nonatomic,retain) NSUserDefaults *userDefault;
@property (nonatomic) int value;


+ (id) sharedInstance;
-(void) loadOnOffValue;
-(void) readOnOffValue;
-(void) updateOnOffValue:(int) _onoffvalue;
-(int) returnUpdatedValue;

@end
