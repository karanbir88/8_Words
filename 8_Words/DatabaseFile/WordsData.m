//
//  WordsData.m
//  8_Words
//
//  Created by Jaideep on 3/11/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "WordsData.h"
#import "AppDelegate.h"
#import <sqlite3.h>

//Declaring the statment which to be performed
static sqlite3 *database = nil;
static sqlite3_stmt *detailStmt = nil;
static sqlite3_stmt *updateStmt = nil;


@implementation WordsData
@synthesize wordsID,category,levels,questions,options,answer,exist;


+(void) getInitialDataToDisplay:(NSString *)dbPath{
    
    //Call the AppDelagte File
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //first check the path open or not...
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        const char *sql1 = "PRAGMA foreign_keys = ON";
        void *v;
        char *errmsg;
        if (sqlite3_exec(database,sql1 , 0, v, &errmsg))
        {
            NSLog(@"failed to set the foreign_key pragma");
        }
        
        //if path open
        //Declare sql query to get the data from database...
        const char *sql = "SELECT Sr,Category,Levels,Questions FROM Question";
        sqlite3_stmt *selectStmt;
        
        if (sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(selectStmt) == SQLITE_ROW) {
                
                NSInteger primaryKey = sqlite3_column_int(selectStmt, 0);
                WordsData *wordObject = [[WordsData alloc] initWithPrimeryKey:primaryKey];
                
                wordObject.wordsID =sqlite3_column_int(selectStmt, 0);
                wordObject.category = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 1)];
                wordObject.levels = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 2)];
                wordObject.questions = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 3)];
                
                //Add the Student to the array...
                [appDelegate.wordsArray addObject:wordObject];
                
                NSLog(@"getInitialDataToDisplay____ %@",appDelegate.wordsArray);
                
            }
        }
    }
    else
        sqlite3_close(database);
    //Even though the open call failed, close the database connection to release all the memory.
    

}
+(void) finalizeStatements{
    
    if (database) sqlite3_close(database);
	if (detailStmt) sqlite3_finalize(detailStmt);
	if (updateStmt) sqlite3_finalize(updateStmt);
    
}
-(id) initWithPrimeryKey:(NSInteger)pk{
 
    self = [super init];
    wordsID = pk;
    return self;
}

#pragma mark-
#pragma Get all Questions and Options

//Get  questions according to category and level
-(NSMutableArray *) getQuestionsFromQuestionTable:(NSString *) _categoryQuestion levelsQuestion:(NSString *) _levelQuestion{
    
    
    NSMutableArray *questionArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSString *string = @"";
    string = [NSString stringWithFormat:@"SELECT Sr,Question,Letters,Answer FROM Question WHERE Category = '%@' AND Level = '%@'",
              _categoryQuestion,_levelQuestion];
    
    NSLog(@"String ____ %@",string);
    
    const char *sql= [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
    
	while (sqlite3_step(detailStmt) == SQLITE_ROW){
        
        
        
        NSUInteger countQuestion = sqlite3_column_int(detailStmt, 0);
        NSLog(@"Number___ %d",countQuestion);
        NSMutableString *countQuestionString = [NSMutableString stringWithFormat:@"%d",countQuestion];
        

        
        NSMutableString *question = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(detailStmt, 1)];
        NSLog(@"quest ______ %@",question);
        
        
        NSUInteger letters = sqlite3_column_int(detailStmt, 2);
        NSLog(@"Number___ %d",letters);
        NSMutableString *numString = [NSMutableString stringWithFormat:@"%d",letters];
        
        
        
        NSMutableString *ans = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(detailStmt, 3)];
        NSLog(@"quest ______ %@",ans);
        
        

        
        if (![ans isEqualToString:@"0"]) {
            
            [dict setValue:question forKey:@"question"];
            [dict setValue:ans forKey:@"answer"];
        }
        else{
            [dict setValue:question forKey:@"question"];
            [dict setValue:numString forKey:@"answer"];
        }
        
        
        [dict setValue:countQuestionString forKey:@"questionsr"];
        
        [questionArray addObject:[dict copy]];
       
	}
    NSLog(@"Questions from questiontable %@",[questionArray description]);
    
	//Reset the detail statement.
	sqlite3_reset(detailStmt);

    return questionArray;
}



-(void) resetAllTableToZero:(NSString *) _categoryOption levelsOption:(NSString *) _levelOption{
    
    
    //Reset Question table...
    NSString *string1 = @"";
    string1 = [NSString stringWithFormat:@"Update Question SET Answer = '0' WHERE Category='%@' AND Level = '%@'",_categoryOption,_levelOption];
    
    const char *sql1 = [string1 cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (sqlite3_prepare_v2(database, sql1, -1, &updateStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
    
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(updateStmt);
    
    
    
    //Reset Option Table...
    NSString *string2 = @"";
    string2 = [NSString stringWithFormat:@"Update Option SET Count = 0 WHERE Category='%@' AND Levels = '%@'",_categoryOption,_levelOption];
    
    const char *sql2 = [string2 cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (sqlite3_prepare_v2(database, sql2, -1, &updateStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
    
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(updateStmt);
    
    
    //Reset Answer Table
    NSString *string3 = @"";
    string3 = [NSString stringWithFormat:@"Update Answer SET Exist = '0' WHERE Category='%@' AND Levels = '%@'",_categoryOption,_levelOption];
    
    const char *sql3 = [string3 cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (sqlite3_prepare_v2(database, sql3, -1, &updateStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
    
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(updateStmt);



}

//Get options of questions accoerding to category and level
-(NSMutableArray *) getOptionsFromOptionTable:(NSString *) _categoryOption levelsOption:(NSString *) _levelOption{
    
    
    NSMutableArray *optionArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    NSString *string = @"";
    
    string = [NSString stringWithFormat:@"SELECT Sr,Option,Count FROM Option WHERE Category = '%@' AND Levels = '%@' AND Count = 0 ",_categoryOption,_levelOption];
    
    NSLog(@"String ____ %@",string);
    
    const char *sql= [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
    
	while (sqlite3_step(detailStmt) == SQLITE_ROW){
        
        
        
        
            
        
        NSUInteger sr = sqlite3_column_int(detailStmt, 0);
        NSLog(@"Number___ %d",sr);
        
        NSMutableString *srString = [NSMutableString stringWithFormat:@"%d",sr];
        
        NSMutableString *option = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(detailStmt, 1)];
        NSLog(@"quest ______ %@",option);
        
        NSUInteger optionCount = sqlite3_column_int(detailStmt, 2);
        NSLog(@"Number___ %d",optionCount);
        
        NSMutableString *optionCountString = [NSMutableString stringWithFormat:@"%d",optionCount];
        
        

        [dict setObject:srString forKey:@"optionsr"];
        [dict setObject:option forKey:@"option"];
        [dict setObject:optionCountString forKey:@"optioncount"];
        
        [optionArray addObject:[dict copy]];
        
        
	}
    NSLog(@"Options from optiontable %@",optionArray);
    
	//Reset the detail statement.
	sqlite3_reset(detailStmt);
    
    return optionArray;

    
}

-(NSMutableArray *) getAnswerFromAnswerTable:(NSString *) _categoryAnswer levelsAnswer:(NSString *) _levelAnswer guessText:(NSString *) _guessText
{
    
    NSMutableArray *answerArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    
    NSString *string = @"";
    
    string = [NSString stringWithFormat:@"SELECT Sr,Answer FROM Answer WHERE Category = '%@' AND Levels = '%@' AND Answer = '%@' AND Exist = '0'",_categoryAnswer,_levelAnswer,_guessText];
    
    NSLog(@"String ____ %@",string);
    
    const char *sql= [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
    
    
	while (sqlite3_step(detailStmt) == SQLITE_ROW){
        
        NSUInteger sr = sqlite3_column_int(detailStmt, 0);
        NSLog(@"Number___ %d",sr);
        
        NSMutableString *srString = [NSMutableString stringWithFormat:@"%d",sr];
        
        NSMutableString *ans = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(detailStmt, 1)];
        NSLog(@"quest ______ %@",ans);
        
        [dict setObject:srString forKey:@"answersr"];
        [dict setObject:ans forKey:@"ans"];
        
        [answerArray addObject:[dict copy]];

        
    }
    
    if ([answerArray count] == 1)
            NSLog(@"Answer %@ Sr %d",[[answerArray objectAtIndex:0] objectForKey:@"ans"],[[[answerArray objectAtIndex:0] objectForKey:@"answersr"] integerValue]);
    
    
    if ([answerArray count] == 1) {
        
        //First update Anwer Table with exixst
        NSString *string1 = @"";
        string1 = [NSString stringWithFormat:@"Update Answer SET Exist = '1' WHERE Sr = %d",[[[answerArray objectAtIndex:0] objectForKey:@"answersr"] integerValue]];
        
        const char *sql2 = [string1 cStringUsingEncoding:NSUTF8StringEncoding];
        
        
        if (sqlite3_prepare_v2(database, sql2, -1, &updateStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
        
        
        if(SQLITE_DONE != sqlite3_step(updateStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
        
        sqlite3_reset(updateStmt);
        
        
        //Update Question table with Answer
        
        NSString *string2 = @"";
        string2 = [NSString stringWithFormat:@"Update Question SET Answer = '%@' WHERE Sr = %d",[[answerArray objectAtIndex:0] objectForKey:@"ans"],[[[answerArray objectAtIndex:0] objectForKey:@"answersr"] integerValue]];
        
        const char *sql3 = [string2 cStringUsingEncoding:NSUTF8StringEncoding];
        
        
        if (sqlite3_prepare_v2(database, sql3, -1, &updateStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
        
        
        if(SQLITE_DONE != sqlite3_step(updateStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
        
        sqlite3_reset(updateStmt);

    }
    
    
    sqlite3_reset(detailStmt);
    
    return answerArray;

}


-(void) updateOptionTavble:(int) _sroption{
    
    
    NSString *string2 = @"";
    string2 = [NSString stringWithFormat:@"Update Option SET Count = 1 WHERE Sr = %d",_sroption];
    
    const char *sql3 = [string2 cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (sqlite3_prepare_v2(database, sql3, -1, &updateStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
    
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(updateStmt);

}

//check the single level is over or not...
-(int) unlockTheNextLevel:(NSString *) _category  levels:(NSString *) _level{
    
   // SELECT count(*) Exist FROM Answer WHERE Category = '1' AND Levels ='1' AND Exist ='1'
    int count = 0;
    NSString *string2 = @"";
    string2 = [NSString stringWithFormat:@"SELECT count(*) Exist FROM Answer WHERE Category = '%@' AND Levels ='%@' AND Exist ='1'",_category,_level];
    const char *sql = [string2 cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL))
        NSAssert1(0, @"Error while creating delete statement. '%s'",sqlite3_errmsg(database));
    
    while (sqlite3_step(detailStmt) == SQLITE_ROW)
        count = sqlite3_column_int(detailStmt, 0);
    NSLog(@"CountAB___ %d",count);
    
    return count;

}

-(void) updateUnlockedLevelTable:(NSString *) _category levels:(int) _level {
    
    NSString *string2 = @"";
    string2 = [NSString stringWithFormat:@"Update Unlockedlevel Set Unlocked = %d WHERE Category = '%@'",_level,_category];
    
    const char *sql3 = [string2 cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (sqlite3_prepare_v2(database, sql3, -1, &updateStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
    
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(updateStmt);
}

//update unlocked table
-(int) getUnlockedNextLevel:(NSString *) _category{
    
    int count = 0;
    NSString *string2 = @"";
    string2 = [NSString stringWithFormat:@"SELECT Unlocked FROM UnlockedLevel WHERE Category = '%@'",_category];
    const char *sql = [string2 cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL))
        NSAssert1(0, @"Error while creating delete statement. '%s'",sqlite3_errmsg(database));
    
    while (sqlite3_step(detailStmt) == SQLITE_ROW)
        count = sqlite3_column_int(detailStmt, 0);
    

    NSLog(@"CountAB___ %d",count);
    
    return count;
}



#pragma mark-Sounds

-(int) getGeneralSound{
    
    int count = 0;
    const char *sql = "SELECT Value FROM Settings Where Sr =1";
    
    if (sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL))
        NSAssert1(0, @"Error while creating detail statement. '%s'",sqlite3_errmsg(database));
    
    while (sqlite3_step(detailStmt) == SQLITE_ROW)
    {
        count = sqlite3_column_int(detailStmt, 0);
    }
    
    NSLog(@"Conrrect Ans %d",count);
    
    return count;
    

}
-(void) updateGeneralSound:(int) _value{
    
    NSString *string1 =@"";
    string1 = [NSString stringWithFormat:@"UPDATE Settings SET Value = %d WHERE Sr=1",_value];
    
    
    const char *sql1 = [string1 cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (sqlite3_prepare_v2(database, sql1, -1, &updateStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
    
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(updateStmt);
}

-(int) getbuttonSound{
    
    
    int count = 0;
    const char *sql = "SELECT Value FROM Settings Where Sr =2";
    
    if (sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL))
        NSAssert1(0, @"Error while creating delete statement. '%s'",sqlite3_errmsg(database));
    
    while (sqlite3_step(detailStmt) == SQLITE_ROW)
        count = sqlite3_column_int(detailStmt, 0);
    NSLog(@"Conrrect Ans %d",count);
    
    return count;
    

}
-(void) updateButtonSound:(int) _value{
    
    NSString *string1 =@"";
    string1 = [NSString stringWithFormat:@"UPDATE Settings SET Value = %d WHERE Sr=2",_value];
    
    
    const char *sql1 = [string1 cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (sqlite3_prepare_v2(database, sql1, -1, &updateStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
    
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(updateStmt);
}

-(int) getLevelCompletesound{
    
    
    int count = 0;
    const char *sql = "SELECT Value FROM Settings Where Sr =3";
    
    if (sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL))
        NSAssert1(0, @"Error while creating delete statement. '%s'",sqlite3_errmsg(database));
    
    while (sqlite3_step(detailStmt) == SQLITE_ROW)
        count = sqlite3_column_int(detailStmt, 0);
    NSLog(@"Conrrect Ans %d",count);
    
    return count;
    

}
-(void) updateLevelCompleteSound:(int) _value{
    
    NSString *string1 =@"";
    string1 = [NSString stringWithFormat:@"UPDATE Settings SET Value = %d WHERE Sr =3",_value];
    
    
    const char *sql1 = [string1 cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (sqlite3_prepare_v2(database, sql1, -1, &updateStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
    
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(updateStmt);

}




-(int) inAppPurchaseValue{
    
    int count = 0;
    const char *sql = "SELECT Value FROM Defaults Where Parameter ='InApp'";
    
    if (sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL))
        NSAssert1(0, @"Error while creating select statement. '%s'",sqlite3_errmsg(database));
    
    while (sqlite3_step(detailStmt) == SQLITE_ROW)
        count = sqlite3_column_int(detailStmt, 0);
    NSLog(@"Conrrect Ans %d",count);
    
    return count;
    
}



-(void) inAppPuchaseValueUpdate{
    
    NSString *string1 =@"";
    string1 = [NSString stringWithFormat:@"UPDATE Defaults SET Value = 1 WHERE Parameter ='InApp'"];
    
    
    const char *sql1 = [string1 cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (sqlite3_prepare_v2(database, sql1, -1, &updateStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
    
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(updateStmt);
    
    
}





@end
