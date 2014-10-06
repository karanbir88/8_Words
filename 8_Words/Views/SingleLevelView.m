//
//  SingleLevelView.m
//  8_Words
//
//  Created by Jaideep on 3/6/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "SingleLevelView.h"
#import "WordsData.h"
#import "SettingSingleton.h"
#import <Twitter/Twitter.h>
#import "GAITrackedViewController.h"
#import "GAI.h"


@implementation SingleLevelView
@synthesize category,levels,countButton;
@synthesize txtField,crossButton,guessButton;
@synthesize userID,delegate = _delegate,categoryListArray;

- (id)initWithFrame:(CGRect)frame category :(int) _category levels:(int) _levels
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor orangeColor]];
        
        setting = [SettingSingleton sharedInstance];
        
        category = _category;
        levels   = _levels;
        
        txtField = nil;
        crossButton = nil;
        guessButton = nil;
        
        clueLabel1 = nil;
        clueLabel2 = nil;
        clueLabel3 = nil;
        clueLabel4 = nil;
        clueLabel5 = nil;
        clueLabel6 = nil;
        clueLabel7 = nil;
        clueLabel8 = nil;
        
        solutionLabel1 = nil;
        solutionLabel2 = nil;
        solutionLabel3 = nil;
        solutionLabel4 = nil;
        solutionLabel5 = nil;
        solutionLabel6 = nil;
        solutionLabel7 = nil;
        solutionLabel8 = nil;
        
        levelcompleteSound = NO;
        
        [gaiTracker.tracker sendView:[NSString stringWithFormat:@"Playable Game Area with Category %d and Level %d",_category,_levels]];
        
        // Initialization code
        [self initialize];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void) initialize{
    
    
    
    NSLog(@"Single Level View category %d level %d",category,levels);
    //Read the plist file
    NSString *categorypath = [[NSBundle mainBundle] pathForResource:@"categorylist" ofType:@"plist"];
    categoryListArray = [[NSMutableArray alloc] initWithContentsOfFile:categorypath];
    

    [self setGameplaybackground:category];
    [self generate_Line];
    [self initializeArray];
    [self setQuestionAndSolutions];
    [self genrate_Clue_Labels];
    [self genrate_Solution_Labels];
    [self genrate_TextField_CrossButton_And_GuessButton];
    [self genrationOfComboLetters];
    [self backLevelsButton];
    [self resetData];
    [self levelcompletedShowlevelOver_];
}

-(void) initializeArray{
    
    wordData = [[WordsData alloc] init];
    clueArray = [[NSMutableArray alloc] init];
    comboLetterArray = [[NSMutableArray alloc] init];
    answerArray = [[NSMutableArray alloc] init];
    countTag = [[NSMutableArray alloc] init];
    suffledArray = [[NSMutableArray alloc] init];
    solutionArray = [[NSMutableArray alloc]init];
    _underRightImage = [[UIImageView alloc] init];

    tagArray = [[NSMutableArray alloc] init];

}



-(void) setQuestionAndSolutions{
    
    clueArray = [wordData getQuestionsFromQuestionTable:[NSString stringWithFormat:@"%d",category+1]
                                         levelsQuestion:[NSString stringWithFormat:@"%d",levels+1]];
    
    NSLog(@"Clue Array Fron Question Table %@",[clueArray description]);
    
    comboLetterArray = [wordData getOptionsFromOptionTable:[NSString stringWithFormat:@"%d",category+1]
                                              levelsOption:[NSString stringWithFormat:@"%d",levels+1]];
    
    NSLog(@"Combination of laters from Option Table %@",[comboLetterArray description]);
    

}

-(void) levelcompletedShowlevelOver{
    
    // if level compltetes set congratulation image...
    if ([wordData unlockTheNextLevel:[NSString stringWithFormat:@"%d",category+1] levels:[NSString stringWithFormat:@"%d",levels+1]] == 8) {
        
        
            NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"levelover.png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            _underRightImage.image = image;
            _underRightImage.frame = CGRectMake(181, 646, 411, 264);
        
        [self addSubview:_underRightImage];
        [self soundON_OFF_LevelComplete:[wordData getLevelCompletesound]];

        
    }

}

-(void) levelcompletedShowlevelOver_{
    
    // if level compltetes set congratulation image...
    if ([wordData unlockTheNextLevel:[NSString stringWithFormat:@"%d",category+1] levels:[NSString stringWithFormat:@"%d",levels+1]] == 8) {
        
        
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"levelover.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        _underRightImage.image = image;
        _underRightImage.frame = CGRectMake(181, 646, 411, 264);
        
        [self addSubview:_underRightImage];
        
        
    }
    
}

#pragma mark-

-(void) setGameplaybackground:(int)_category{
    
    underRightImage = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"levelbg.jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    underRightImage.image = image;
    [self addSubview:underRightImage];
    
    
    
    UILabel *categorylbl = [[UILabel alloc] initWithFrame:CGRectMake(164, 10, 440, 100)];
    categorylbl.text = [NSString stringWithFormat:@"%@",[categoryListArray objectAtIndex:_category] ];
    categorylbl.backgroundColor = [UIColor clearColor];
    categorylbl.font = [UIFont fontWithName:@"Dungeon" size:80.0f];
    categorylbl.textColor = [UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0];
    categorylbl.textAlignment = UITextAlignmentCenter;
    
    [self addSubview:categorylbl];

}


#pragma mark- Generate line
-(void) generate_Line{
    
    UILabel *clue = [[UILabel alloc] initWithFrame:CGRectMake(59, 91, 150, 30)];
    clue.text = @"Clue";
    clue.font = [UIFont fontWithName:@"Futura" size:26.0];
    clue.font = [UIFont boldSystemFontOfSize:26.0];
    [clue setBackgroundColor:[UIColor clearColor]];
    [self addSubview:clue];
    
    
    
    UILabel *solutions = [[UILabel alloc] initWithFrame:CGRectMake(559, 91, 150, 30)];
    solutions.text = @"Solutions";
    
    solutions.font = [UIFont fontWithName:@"Futura" size:26.0];
    solutions.font = [UIFont boldSystemFontOfSize:26.0];
    [solutions setBackgroundColor:[UIColor clearColor]];
    [self addSubview:solutions];
    
    
    int y = 0;
    NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"line.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    for (int i=0; i<9; i++) {
        UIImageView *lineimage = [[UIImageView alloc] init];
        lineimage.image = image;
        lineimage.frame = CGRectMake(59, 129+y, 650, 1.0);
        y +=48;
        
        [self addSubview:lineimage];
        
    }
    
    
}



#pragma mark-
#pragma Clue
-(void) genrate_Clue_Labels{
    
    
    if (clueLabel1 != nil || clueLabel2 != nil || clueLabel3 != nil || clueLabel4 != nil || clueLabel5 != nil || clueLabel6 != nil || clueLabel7 != nil || clueLabel8 != nil ) {
        
        [clueLabel1 removeFromSuperview];
        [clueLabel2 removeFromSuperview];
        [clueLabel3 removeFromSuperview];
        [clueLabel4 removeFromSuperview];
        [clueLabel5 removeFromSuperview];
        [clueLabel6 removeFromSuperview];
        [clueLabel7 removeFromSuperview];
        [clueLabel8 removeFromSuperview];
        
    }
    
    //Labels
    clueLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(59, 139, 440, 30)];
    clueLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(59, 187, 440, 30)];
    clueLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(59, 235, 440, 30)];
    clueLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(59, 283, 440, 30)];
    clueLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(59, 331, 440, 30)];
    clueLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(59, 379, 440, 30)];
    clueLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(59, 427, 440, 30)];
    clueLabel8 = [[UILabel alloc] initWithFrame:CGRectMake(59, 475, 440, 30)];
    
    clueLabel1.font = [UIFont fontWithName:@"Futura" size:22.0];
    clueLabel2.font = [UIFont fontWithName:@"Futura" size:22.0];
    clueLabel3.font = [UIFont fontWithName:@"Futura" size:22.0];
    clueLabel4.font = [UIFont fontWithName:@"Futura" size:22.0];
    clueLabel5.font = [UIFont fontWithName:@"Futura" size:22.0];
    clueLabel6.font = [UIFont fontWithName:@"Futura" size:22.0];
    clueLabel7.font = [UIFont fontWithName:@"Futura" size:22.0];
    clueLabel8.font = [UIFont fontWithName:@"Futura" size:22.0];
    
    
    
    //Set Clue
    clueLabel1.text = [[clueArray objectAtIndex:0] objectForKey:@"question"];
    clueLabel2.text = [[clueArray objectAtIndex:1] objectForKey:@"question"];
    clueLabel3.text = [[clueArray objectAtIndex:2] objectForKey:@"question"];
    clueLabel4.text = [[clueArray objectAtIndex:3] objectForKey:@"question"];
    clueLabel5.text = [[clueArray objectAtIndex:4] objectForKey:@"question"];
    clueLabel6.text = [[clueArray objectAtIndex:5] objectForKey:@"question"];
    clueLabel7.text = [[clueArray objectAtIndex:6] objectForKey:@"question"];
    clueLabel8.text = [[clueArray objectAtIndex:7] objectForKey:@"question"];
    
    clueLabel1.textColor = [UIColor grayColor];
    clueLabel2.textColor = [UIColor grayColor];
    clueLabel3.textColor = [UIColor grayColor];
    clueLabel4.textColor = [UIColor grayColor];
    clueLabel5.textColor = [UIColor grayColor];
    clueLabel6.textColor = [UIColor grayColor];
    clueLabel7.textColor = [UIColor grayColor];
    clueLabel8.textColor = [UIColor grayColor];

    
    [clueLabel1 setBackgroundColor:[UIColor clearColor]] ;
    [clueLabel2 setBackgroundColor:[UIColor clearColor]] ;
    [clueLabel3 setBackgroundColor:[UIColor clearColor]] ;
    [clueLabel4 setBackgroundColor:[UIColor clearColor]] ;
    [clueLabel5 setBackgroundColor:[UIColor clearColor]] ;
    [clueLabel6 setBackgroundColor:[UIColor clearColor]] ;
    [clueLabel7 setBackgroundColor:[UIColor clearColor]] ;
    [clueLabel8 setBackgroundColor:[UIColor clearColor]] ;
    
    //Add     labels

    [self addSubview:clueLabel1];
    [self addSubview:clueLabel2];
    [self addSubview:clueLabel3];
    [self addSubview:clueLabel4];
    [self addSubview:clueLabel5];
    [self addSubview:clueLabel6];
    [self addSubview:clueLabel7];
    [self addSubview:clueLabel8];
    
   
}

#pragma mark-
#pragma Solutions
-(void) genrate_Solution_Labels{
    
    
    if (solutionLabel1 != nil || solutionLabel2 != nil || solutionLabel3 != nil || solutionLabel4 != nil || solutionLabel5 != nil || solutionLabel6 != nil  || solutionLabel7 != nil || solutionLabel8 != nil ) {
        
        [solutionLabel1 removeFromSuperview];
        [solutionLabel2 removeFromSuperview];
        [solutionLabel3 removeFromSuperview];
        [solutionLabel4 removeFromSuperview];
        [solutionLabel5 removeFromSuperview];
        [solutionLabel6 removeFromSuperview];
        [solutionLabel7 removeFromSuperview];
        [solutionLabel8 removeFromSuperview];
        
    }

    
    
    solutionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(559, 139,  200, 30)];
    solutionLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(559, 187,  200, 30)];
    solutionLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(559, 235, 200, 30)];
    solutionLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(559, 283, 200, 30)];
    solutionLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(559, 331, 200, 30)];
    solutionLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(559, 379, 200, 30)];
    solutionLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(559, 427, 200, 30)];
    solutionLabel8 = [[UILabel alloc] initWithFrame:CGRectMake(559, 475, 200, 30)];
    
    solutionLabel1.font = [UIFont fontWithName:@"Futura" size:22.0];
    solutionLabel2.font = [UIFont fontWithName:@"Futura" size:22.0];
    solutionLabel3.font = [UIFont fontWithName:@"Futura" size:22.0];
    solutionLabel4.font = [UIFont fontWithName:@"Futura" size:22.0];
    solutionLabel5.font = [UIFont fontWithName:@"Futura" size:22.0];
    solutionLabel6.font = [UIFont fontWithName:@"Futura" size:22.0];
    solutionLabel7.font = [UIFont fontWithName:@"Futura" size:22.0];
    solutionLabel8.font = [UIFont fontWithName:@"Futura" size:22.0];
    
    [solutionLabel1 setBackgroundColor:[UIColor clearColor]] ;
    [solutionLabel2 setBackgroundColor:[UIColor clearColor]] ;
    [solutionLabel3 setBackgroundColor:[UIColor clearColor]] ;
    [solutionLabel4 setBackgroundColor:[UIColor clearColor]] ;
    [solutionLabel5 setBackgroundColor:[UIColor clearColor]] ;
    [solutionLabel6 setBackgroundColor:[UIColor clearColor]] ;
    [solutionLabel7 setBackgroundColor:[UIColor clearColor]] ;
    [solutionLabel8 setBackgroundColor:[UIColor clearColor]] ;
    

    
    if ([[[clueArray objectAtIndex:0] objectForKey:@"answer"] integerValue])
    {
        solutionLabel1.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:0] objectForKey:@"answer"]];
        solutionLabel1.textColor = [UIColor grayColor];
        
    }
    else{
        solutionLabel1.text = [NSString stringWithFormat:@"%@",[[clueArray objectAtIndex:0] objectForKey:@"answer"]];
        solutionLabel1.font = [UIFont boldSystemFontOfSize:22.0] ;
        solutionLabel1.textColor = [UIColor blackColor];
    }
    
    if ([[[clueArray objectAtIndex:1] objectForKey:@"answer"] integerValue])
    {
        solutionLabel2.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:1] objectForKey:@"answer"]];
        solutionLabel2.textColor = [UIColor grayColor];
    }
    else{
        solutionLabel2.text = [NSString stringWithFormat:@"%@",[[clueArray objectAtIndex:1] objectForKey:@"answer"]];
        solutionLabel2.font = [UIFont boldSystemFontOfSize:22.0] ;
        solutionLabel2.textColor = [UIColor blackColor];
    }
    
    
    
    if ([[[clueArray objectAtIndex:2] objectForKey:@"answer"] integerValue])
    {
        solutionLabel3.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:2] objectForKey:@"answer"]];
        solutionLabel3.textColor = [UIColor grayColor];
    }
    else
    {
        solutionLabel3.text = [NSString stringWithFormat:@"%@",[[clueArray objectAtIndex:2] objectForKey:@"answer"]];
        solutionLabel3.font = [UIFont boldSystemFontOfSize:22.0] ;
         solutionLabel3.textColor = [UIColor blackColor];
    }
    
    
    
    if ([[[clueArray objectAtIndex:3] objectForKey:@"answer"] integerValue])
    {
        solutionLabel4.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:3] objectForKey:@"answer"]];
        solutionLabel4.textColor = [UIColor grayColor];
    }
    else
    {
        solutionLabel4.text = [NSString stringWithFormat:@"%@",[[clueArray objectAtIndex:3] objectForKey:@"answer"]];
        solutionLabel4.font = [UIFont boldSystemFontOfSize:22.0] ;
        solutionLabel4.textColor = [UIColor blackColor];
    }
    
    
    if ([[[clueArray objectAtIndex:4] objectForKey:@"answer"] integerValue])
    {
        solutionLabel5.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:4] objectForKey:@"answer"]];
        solutionLabel5.textColor = [UIColor grayColor];
    }
    else
    {
        solutionLabel5.text = [NSString stringWithFormat:@"%@",[[clueArray objectAtIndex:4] objectForKey:@"answer"]];
        solutionLabel5.font = [UIFont boldSystemFontOfSize:22.0] ;
        solutionLabel5.textColor = [UIColor blackColor];
    }
    
    
    
    
    if ([[[clueArray objectAtIndex:5] objectForKey:@"answer"] integerValue])
    {
        solutionLabel6.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:5] objectForKey:@"answer"]];
        solutionLabel6.textColor = [UIColor grayColor];
    }
    else
    {
        solutionLabel6.text = [NSString stringWithFormat:@"%@",[[clueArray objectAtIndex:5] objectForKey:@"answer"]];
        solutionLabel6.font = [UIFont boldSystemFontOfSize:22.0] ;
        solutionLabel6.textColor = [UIColor blackColor];
    }
    
    
    if ([[[clueArray objectAtIndex:6] objectForKey:@"answer"] integerValue])
    {
        solutionLabel7.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:6] objectForKey:@"answer"]];
        solutionLabel7.textColor = [UIColor grayColor];
    }
    else
    {
        solutionLabel7.text = [NSString stringWithFormat:@"%@",[[clueArray objectAtIndex:6] objectForKey:@"answer"]];
        solutionLabel7.font = [UIFont boldSystemFontOfSize:22.0] ;
        solutionLabel7.textColor = [UIColor blackColor];
    }
    
    
    
    if ([[[clueArray objectAtIndex:7] objectForKey:@"answer"] integerValue])
    {
        solutionLabel8.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:7] objectForKey:@"answer"]];
        solutionLabel8.textColor = [UIColor grayColor];
    }
    else{
        solutionLabel8.text = [NSString stringWithFormat:@"%@",[[clueArray objectAtIndex:7] objectForKey:@"answer"]];
        solutionLabel8.font = [UIFont boldSystemFontOfSize:22.0] ;
        solutionLabel8.textColor = [UIColor blackColor];
        
    }

    
    
//    
//    //Set Clue
//    
//    solutionLabel2.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:1] objectForKey:@"answer"]];
//    solutionLabel3.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:2] objectForKey:@"answer"]];
//    solutionLabel4.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:3] objectForKey:@"answer"]];
//    solutionLabel5.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:4] objectForKey:@"answer"]];
//    solutionLabel6.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:5] objectForKey:@"answer"]];
//    solutionLabel7.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:6] objectForKey:@"answer"]];
//    solutionLabel8.text = [NSString stringWithFormat:@"%@ letters",[[clueArray objectAtIndex:7] objectForKey:@"answer"]];
//    
    
    //Add
    [self addSubview:solutionLabel1];
    [self addSubview:solutionLabel2];
    [self addSubview:solutionLabel3];
    [self addSubview:solutionLabel4];
    [self addSubview:solutionLabel5];
    [self addSubview:solutionLabel6];
    [self addSubview:solutionLabel7];
    [self addSubview:solutionLabel8];
    
    
}


#pragma mark-
#pragma Genrate_TextField_CrossButton_And_GuessButton
-(void) genrate_TextField_CrossButton_And_GuessButton
{
    
    if (txtField != nil) {
        [txtField removeFromSuperview];
    }
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(59, 535, 460, 72)];
            
    NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"textbox.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    img.image = image;
    [self addSubview:img];

    
    //textfield
    txtField = [[UITextField alloc] initWithFrame:CGRectMake(65,535, 380, 70)];
    txtField.borderStyle = UITextBorderStyleNone;
    txtField.userInteractionEnabled = NO;
    txtField.font = [UIFont fontWithName:@"Futura" size:50.0];
    
    
    //cross button
    crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crossButton.frame = CGRectMake(451, 540, 60, 60);
    [crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [crossButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    
    guessButton = [UIButton buttonWithType:UIButtonTypeCustom];
    guessButton.frame = CGRectMake(569, 535, 140, 70);
    [guessButton setImage:[UIImage imageNamed:@"guess.png"] forState:UIControlStateNormal];
    [guessButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [guessButton setHidden:YES];
    
    
    shuffleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shuffleButton.frame = CGRectMake(569, 535, 140, 70);
    [shuffleButton setImage:[UIImage imageNamed:@"shuffle.png"] forState:UIControlStateNormal];
    [shuffleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    

    

    //Actions
    [crossButton addTarget:self action:@selector(crossButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [guessButton addTarget:self action:@selector(guessButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [shuffleButton addTarget:self action:@selector(shuffleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //Add subviews
    [self addSubview:txtField];
    [self addSubview:crossButton];
    [self addSubview:guessButton];
    [self addSubview:shuffleButton];
}



#pragma Mark-
#pragma Actions of Buttons
-(IBAction)crossButtonAction:(id)sender
{
    
    NSLog(@"crossButton clicked");
    
    [self soundON_OFF:[wordData getGeneralSound]];
    
    txtField.text = @"";
    //[self genrationOfComboLetters];
    [guessButton setHidden:YES];
    [shuffleButton setHidden:NO];
    [self showTouchedButton];
    [countTag removeAllObjects];
    [tagArray removeAllObjects];


}

-(IBAction)guessButtonAction:(id)sender
{
    NSLog(@"guessButton clicked");
    
    [self backLevelsButton];
    
    NSMutableArray *tempArr = nil;
    NSMutableString *string = nil;
    
    
    tempArr = [[NSMutableArray alloc] init];
    string = [[NSMutableString alloc] init];
    
    
    for (int i = 0; i<[countTag count]; i++) {
        
        [string appendString:[NSString stringWithFormat:@"%@", [[countTag objectAtIndex:i] objectForKey:@"option"]]];
        
    }
    NSLog(@"Total String %@",string);
    
    
    
    tempArr=[wordData getAnswerFromAnswerTable:[NSString stringWithFormat:@"%d",category+1] levelsAnswer:[NSString stringWithFormat:@"%d",levels+1] guessText:string];
    
    NSLog(@"ReturnValue  %d",[tempArr count]);
    
    if ([tempArr count] == 1) {
        NSLog(@"______ Value found");
        
        //We suhould update option table also
        
        for (int i = 0; i<[countTag count]; i++) {
            NSLog(@"Option Serial numer %d",[[[countTag objectAtIndex:i] objectForKey:@"optionsr"] integerValue]);
            [wordData updateOptionTavble:[[[countTag objectAtIndex:i] objectForKey:@"optionsr"] integerValue]];
        }
        
        [self setQuestionAndSolutions];
        [self genrate_Clue_Labels];
        [self genrate_Solution_Labels];
        [guessButton setHidden:YES];
        [shuffleButton setHidden:NO];
        [self soundON_OFF_Correct:[wordData getbuttonSound]];
        
        
    }
    else
    {
        [self soundIncorrect:[wordData getbuttonSound]];
        [self showTouchedButton];
        [guessButton setHidden:YES];
        [shuffleButton setHidden:NO];
        [tagArray removeAllObjects];
        [countTag removeAllObjects];
        NSLog(@"______ Value is not found");
    }
    
    // if level compltetes set congratulation image...
    [self levelcompletedShowlevelOver];
    
    txtField.text = @"";
    [tagArray removeAllObjects];
    [countTag removeAllObjects];

}

-(IBAction)shuffleButtonAction:(id)sender
{
    [self soundON_OFF:[wordData getGeneralSound]];
    [self genrationOfComboLetters];
}

#pragma mark-
#pragma genrationOfComboLetters

-(NSMutableArray *) shuffleTheArray{
    
        NSMutableArray *shuffle;
        NSMutableArray *indexes = [[NSMutableArray alloc] initWithCapacity:[comboLetterArray count]];
        for (int i=0; i<[comboLetterArray count]; i++)
            [indexes addObject:[comboLetterArray objectAtIndex:i]];
        
        shuffle = [[NSMutableArray alloc] initWithCapacity:[comboLetterArray count]];
        
        while ([indexes count])
        {
            int index1 = arc4random() % [indexes count];
            [shuffle addObject:[indexes objectAtIndex:index1]];
            
            [indexes removeObjectAtIndex:index1];
        }
        
        suffledArray = shuffle;
        NSLog(@"Suffle Array %@", suffledArray);
        
        return shuffle;
        
}

-(void) genrationOfComboLetters{
   
    NSMutableArray *tempArray = nil;
    UIButton *button = nil;
    
    
    for(id view in self.subviews )
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            
            [view removeFromSuperview];
          }
            
        
        
    }
    
    [self genrate_TextField_CrossButton_And_GuessButton];
    [self backLevelsButton];
    [self resetData];
    
    tempArray = [[NSMutableArray alloc] init];
    tempArray = [self shuffleTheArray];
    
    NSLog(@"ComboLetters Count %d",[tempArray count]);
    
    if ([tempArray count] == 0) {
        NSLog(@"No option are in database");
    }
    else
    {
        int rows = 4;
        int cols = 5;
        
        float gridWidth = 640.0f;
        float gridHeight = 600.0f;
        
        float buttonWidth = 140.0f;
        float buttonHeight = 70.0f;
        
        float gapHorizontal = ((gridWidth - (buttonWidth * rows)) / (rows + 1)+12.0000);
        float gapVertical = ((gridHeight - (buttonHeight * cols)) / (cols + 1)-31.6666668);
        
        float offsetX =0.0f;
        float offsetY = 0.0f;
        
        NSLog(@"gapHorizontal  gapVertical %f %f",gapHorizontal,gapVertical);
        
        countButton = 0;
        
        do {
            offsetX = gapHorizontal + ((countButton % rows) * (buttonWidth + gapHorizontal));
            offsetY = gapVertical + ((countButton / rows) * (buttonHeight + gapVertical));
            
            
            
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((offsetX+29), (offsetY+615), buttonWidth, buttonHeight);
            button.tag = countButton;
            
            
            NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"gamepalybutton.png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:[[tempArray objectAtIndex:countButton] objectForKey:@"option"] forState:UIControlStateNormal];
           // txtField.font = [UIFont fontWithName:@"Futura" size:25.0];

            [button setFont:[UIFont fontWithName:@"Futura" size:32.0]];
            [button addTarget:self action:@selector(comboLetterButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            
            
            offsetX+= buttonWidth + gapHorizontal;
            
            countButton++;
            
        } while(countButton < [tempArray count]);
        

        
    }
        
    
}

-(void) comboLetterButtonclicked:(id) sender{
    
    UIButton *btn = (UIButton *)sender;
    NSLog(@"Button Tag %d",btn.tag);

    [countTag addObject:[suffledArray objectAtIndex:btn.tag]];
    [tagArray addObject:[NSString stringWithFormat:@"%d",btn.tag]];
    
    
   // NSLog(@"CombinationOfText  %@",[[countTag objectAtIndex:btn.tag] objectForKey:@"option"]);
    
    
    NSMutableString *string = [[NSMutableString alloc] init];
    
    for (int i = 0; i<[countTag count]; i++) {
        
        [string appendString:[NSString stringWithFormat:@"%@", [[countTag objectAtIndex:i] objectForKey:@"option"]]];
        
    }
    NSLog(@"Total String %@",string);
    txtField.text = string;
    
    
    //Set sound
    [self soundON_OFF:[wordData getGeneralSound]];
    
    
    [btn setHidden:YES];
    
    [guessButton setHidden:NO];
    [shuffleButton setHidden:YES];

}

//Call When there is no answer found... Means back to original place. 
-(void) showTouchedButton{
    
//    NSLog(@"TagArray %@",[tagArray description]);
//    
//    for (int i = 0; i<[countTag count]; i++) {
//        
//        NSLog(@"CombinationOfText  %@",[[countTag objectAtIndex:i] objectForKey:@"option"]);
//        NSLog(@"COuntTag %d",[[tagArray objectAtIndex:i] intValue]);
//        UIButton *btn = (UIButton *)[self viewWithTag:[[tagArray objectAtIndex:i] intValue]];
//        [btn setHidden:NO];
//        NSLog(@"Count Button Tag %d",[[tagArray objectAtIndex:i] intValue]);
//
//        
//    }

    UIButton *btn = nil;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            
            NSLog(@"CountTag %d",[countTag count]);
            for (int i = 0; i<[countTag count]; i++)
            {
                NSLog(@"COuntTag %d",[[tagArray objectAtIndex:i] intValue]);
                btn = (UIButton *)[view viewWithTag:[[tagArray objectAtIndex:i] intValue]];
                [btn setHidden:NO];

                    
            }
        }
    }
}


#pragma mark-
#pragma BackButton
-(void) backLevelsButton{
    
    UIButton *backArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    backArrow.frame = CGRectMake(0, 0, 80, 80);
    [backArrow setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backArrow addTarget:self action:@selector(removeLavelsView) forControlEvents:UIControlEventTouchUpInside];
    
    //Adding a button to the view
    [self addSubview:backArrow];
    
}

-(void) removeLavelsView{
    
    [self soundON_OFF:[wordData getGeneralSound]];
    
    //check if all value are given or not
    if ([wordData unlockTheNextLevel:[NSString stringWithFormat:@"%d",category+1] levels:[NSString stringWithFormat:@"%d",levels+1]] == 8) {
        
        //update next level in database...
        [wordData updateUnlockedLevelTable:[NSString stringWithFormat:@"%d",category+1] levels:levels+2];
        
        
        //reset the category buttons using delegate.
        
        [_delegate unlockNextLevel];
    }
    else{
        
        [_delegate unlockNextLevel];
        NSLog(@"Level is still to complete");
        
    }
    //[_delegate unlockNextLevel];
    [self removeFromSuperview];
    
}
#pragma mark- ResetData
-(void) resetData{
    
    
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeCustom];
    reset.frame = CGRectMake(688, 0, 80, 80);
    [reset setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
   // [reset setTitle:@"reset" forState:UIControlStateNormal];
    [reset addTarget:self action:@selector(resetAllValuesForPerticularLevel) forControlEvents:UIControlEventTouchUpInside];
    
    //Adding a button to the view
    [self addSubview:reset];
    


}
-(void) resetAllValuesForPerticularLevel{
    
    [self soundON_OFF:[wordData getGeneralSound]];
    
    [wordData resetAllTableToZero:[NSString stringWithFormat:@"%d",category+1] levelsOption:[NSString stringWithFormat:@"%d",levels+1]];
    [self setQuestionAndSolutions];
    [self genrate_Clue_Labels];
    [self genrate_Solution_Labels];
    [self genrate_TextField_CrossButton_And_GuessButton];
    [self genrationOfComboLetters];
    
    
    [_underRightImage removeFromSuperview];
    
    if ([userID length]==0) return;

    //reset data
    NSString *post =
    [[NSString alloc] initWithFormat:@"uid=%@&catagory=%d&level=%d&comeFrom=%@",userID,category+1,levels+1,@"iPad"];
    NSLog(@"Post string %@",post);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSURL *url = [NSURL URLWithString:@"http://social-brand.in/apps/8words_builder/deletelevels.php"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:postData];
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        NSMutableData *webData = [NSMutableData data];
        NSLog(@"Data %@",webData);
        
    }
    else
    {
        
    }

    
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

-(void) soundON_OFF_Correct:(int) _soundValue{
    
    if (_soundValue == 1) {
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"tickmark" ofType:@"mp3"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFilePath], &soundID);
        AudioServicesPlaySystemSound (soundID);
        
        
    }
    else{
        NSLog(@"Sound is desabled.");
    }
}
-(void) soundON_OFF_LevelComplete:(int) _soundValue{
    
    if (_soundValue == 1) {
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"tickmark" ofType:@"mp3"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFilePath], &soundID);
        AudioServicesPlaySystemSound (soundID);
        
        
    }
    else{
        NSLog(@"Sound is desabled.");
    }
}

-(void) soundIncorrect:(int) _soundValue{
    
    if (_soundValue == 1) {
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"crossmark" ofType:@"mp3"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFilePath], &soundID);
        AudioServicesPlaySystemSound (soundID);
        
        
    }
    else{
        NSLog(@"Sound is desabled.");
    }
}


@end
