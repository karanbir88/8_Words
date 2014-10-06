//
//  LevelsView.h
//  8_Words
//
//  Created by Jaideep on 3/6/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleLevelView.h"

@class SingleLevelView;
@class WordsData;
@class SettingSingleton;
@class GAITrackedViewController;

@interface LevelsView : UIView <SingleLevelViewDelegate>{
    
    UIScrollView *scrlView;
    SingleLevelView *singleView;
    UIImageView *underRightImage;

    WordsData       *wordData;

    SettingSingleton *setting;
    GAITrackedViewController *gaiTracker;
    

}

@property (nonatomic) int categoryValue;
@property (nonatomic, retain)  NSMutableArray *categoryListArray;
@property (copy) NSString *userID;
@property (nonatomic, retain)  NSMutableData *webData;


- (id)initWithFrame:(CGRect)frame category:(int) _category;
@end
