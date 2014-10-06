//
//  InstructionView.h
//  8_Words
//
//  Created by Jaideep on 3/12/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingSingleton;
@class WordsData;

@interface InstructionView : UIView{
    UIImageView *underRightImage;
    SettingSingleton *setting;
    WordsData *wordData;
    
}

@end
