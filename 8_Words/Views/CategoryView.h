//
//  CategoryView.h
//  8_Words
//
//  Created by Jaideep on 3/6/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LevelsView;
@class OptionView;
@class SettingSingleton;
@class WordsData;
@class GAITrackedViewController;
@class RageIAPHelper;

@interface CategoryView : UIViewController{
    
    int             countButton;
    UIScrollView *scrlView;

    LevelsView *levelsview;
    NSMutableArray *categoryListArray;
    int category1,category2,category3,category4;
    UIImageView *underRightImage;
    OptionView *optionView;
    WordsData *wordData;
    SettingSingleton *setting;
    GAITrackedViewController *gaiTracker;
    
    //In App purchase
    //NSArray *_products;
    RageIAPHelper *_rageIAP;
    NSArray *_products;
    UIView       *popUp;
    UIView *message;
    

    
}
@property (copy) NSString *userID;

@property (nonatomic, retain)  NSMutableArray *categoryListArray;
@property (nonatomic, retain)  NSMutableData *webData;


@end
