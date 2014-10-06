//
//  WordsData.h
//  8_Words
//
//  Created by Jaideep on 3/11/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordsData : NSObject

@property (nonatomic) NSInteger wordsID;
@property (nonatomic, retain) NSString *category,*levels,*questions,*answer,*options,*exist;

+(void) getInitialDataToDisplay:(NSString *)dbPath;
+(void) finalizeStatements;
-(id) initWithPrimeryKey:(NSInteger)pk;

//Get  questions according to category and level
-(NSMutableArray *) getQuestionsFromQuestionTable:(NSString *) _categoryQuestion levelsQuestion:(NSString *) _levelQuestion;


//Get options of questions accoerding to category and level
-(NSMutableArray *) getOptionsFromOptionTable:(NSString *) _categoryOption levelsOption:(NSString *) _levelOption;


//Get answer from Answer table
-(NSMutableArray *) getAnswerFromAnswerTable:(NSString *) _categoryAnswer levelsAnswer:(NSString *) _levelAnswer guessText:(NSString *) _guessText;


//update option table
-(void) updateOptionTavble:(int) _sroption;
-(void) resetAllTableToZero:(NSString *) _categoryOption levelsOption:(NSString *) _levelOption;

//unlock levels
-(int) unlockTheNextLevel:(NSString *) _category  levels:(NSString *) _level;
-(void) updateUnlockedLevelTable:(NSString *) _category levels:(int) _level;
-(int) getUnlockedNextLevel:(NSString *) _category;


-(int) getGeneralSound;
-(void) updateGeneralSound:(int) _value;

-(int) getbuttonSound;
-(void) updateButtonSound:(int) _value;

-(int) getLevelCompletesound;
-(void) updateLevelCompleteSound:(int) _value;

//In App purchase
-(int) inAppPurchaseValue;
-(void) inAppPuchaseValueUpdate;

@end
