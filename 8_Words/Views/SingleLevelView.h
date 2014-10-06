//
//  SingleLevelView.h
//  8_Words
//
//  Created by Jaideep on 3/6/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WordsData;
@class SettingSingleton;
@class GAITrackedViewController;


@protocol SingleLevelViewDelegate <NSObject>
//Defining a delegate
-(void) unlockNextLevel;
@end


@interface SingleLevelView : UIView{
    
    
    WordsData       *wordData;

    int             category,levels,countButton;
    //TextField
    UITextField     *txtField;
    UIButton        *crossButton;
    UIButton        *guessButton,*shuffleButton;
    UILabel         *clueLabel1,*clueLabel2 ,*clueLabel3,*clueLabel4,*clueLabel5,*clueLabel6,*clueLabel7,*clueLabel8;
    UILabel         *solutionLabel1,*solutionLabel2,*solutionLabel3,*solutionLabel4,*solutionLabel5,*solutionLabel6,*solutionLabel7,*solutionLabel8;
    
    NSMutableArray  *countTag;
    
    
    //clue array and solution array
    NSMutableArray      *clueArray,*comboLetterArray,*solutionArray,*answerArray,*suffledArray;
    NSMutableDictionary *info;
    UIImageView *underRightImage;
    
    
    SettingSingleton *setting;
    UIImageView *_underRightImage;

    NSMutableArray *tagArray;
    
    GAITrackedViewController *gaiTracker;
    BOOL levelcompleteSound;
    
}
@property (nonatomic) int category,levels,countButton;
@property (nonatomic, retain) UITextField     *txtField;
@property (nonatomic, retain) UIButton        *crossButton;
@property (nonatomic, retain) UIButton        *guessButton;
@property (nonatomic, retain) id <SingleLevelViewDelegate> delegate;
@property (nonatomic, retain)  NSMutableArray *categoryListArray;
@property (copy) NSString *userID;



- (id)initWithFrame:(CGRect)frame category :(int) _category levels:(int) _levels;

@end
