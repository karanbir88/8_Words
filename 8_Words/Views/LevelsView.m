//
//  LevelsView.m
//  8_Words
//
//  Created by Jaideep on 3/6/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "LevelsView.h"
#import "SingleLevelView.h"
#import "WordsData.h"
#import "SettingSingleton.h"
#import "GAITrackedViewController.h"
#import "GAI.h"


@implementation LevelsView
@synthesize userID,categoryValue,categoryListArray,webData;


- (id)initWithFrame:(CGRect)frame category:(int) _category
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor greenColor]];
        setting=[SettingSingleton sharedInstance];
        
        categoryValue = _category;
        [gaiTracker.tracker sendView:[NSString stringWithFormat:@"Level View of Category %d",_category]];
        
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
    
    NSLog(@"CaegoryValue  %d",categoryValue);
    
    
    //Read the plist file
    NSString *categorypath = [[NSBundle mainBundle] pathForResource:@"categorylist" ofType:@"plist"];
    categoryListArray = [[NSMutableArray alloc] initWithContentsOfFile:categorypath];
    

    
    [self setBackgroundsOfLevelView:categoryValue];
    [self genrateListOfButtons];
    [self backLevelsButton];

}


-(void) setBackgroundsOfLevelView:(int) _category{
    
    NSLog(@"_____Level category %d",_category);
    underRightImage = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"levelbg.jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    underRightImage.image = image;
    [self addSubview:underRightImage];
    
    
    
    UILabel *categorylbl = [[UILabel alloc] initWithFrame:CGRectMake(164, 80, 440, 100)];
    categorylbl.text = [NSString stringWithFormat:@"%@",[categoryListArray objectAtIndex:_category] ];
    categorylbl.backgroundColor = [UIColor clearColor];
    categorylbl.font = [UIFont fontWithName:@"Dungeon" size:80.0f];
    categorylbl.textColor = [UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0];
    categorylbl.textAlignment = UITextAlignmentCenter;
    
    [self addSubview:categorylbl];

}



#pragma mark-
#pragma UIButtons_Creations

-(void) genrateListOfButtons{
    
    for(id view in self.subviews )
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            
            [view removeFromSuperview];
        }
        
        
        
    }
    [self backLevelsButton];
    
    int rows = 0;
    int cols = 0;
    NSLog(@"Category Value %d",categoryValue+1);
    
    if (6<=categoryValue+1 && categoryValue+1<=16) {
        rows = 2;
        cols = 3;
        
    }
    else{
        
        rows = 2;
        cols = 5;
        
    }
    float buttonWidth = 200.0;
    float buttonHeight = 200.0;
    
    scrlView = [[UIScrollView alloc] initWithFrame:CGRectMake(59, 200, 650, 750)];
    scrlView.pagingEnabled = NO;
    scrlView.contentSize = CGSizeMake(280, cols*buttonHeight+buttonHeight);
    NSLog(@"Height %f",scrlView.contentSize.height);
    
    scrlView.backgroundColor = [UIColor clearColor];
    scrlView.showsHorizontalScrollIndicator = NO;
    scrlView.showsVerticalScrollIndicator = NO;
    scrlView.scrollsToTop = YES;
    [self addSubview:scrlView];
    
    
    
    
    float gridWidth = 640.0f;
    float gridHeight = scrlView.contentSize.height;

    
   
    float gapHorizontal = (gridWidth - (buttonWidth * rows)) / (rows + 1);
    float gapVertical = (gridHeight - (buttonHeight * cols)) / (cols + 1);
    
    float offsetX;
    float offsetY;
    

    int count = 0;
    wordData = nil;
    wordData = [[WordsData alloc] init];
    int unlockCount = [wordData getUnlockedNextLevel:[NSString stringWithFormat:@"%d",categoryValue+1]];
    NSLog(@"Unlocked Value %d",unlockCount);
    
    do {
        offsetX = gapHorizontal + ((count % rows) * (buttonWidth + gapHorizontal));
        offsetY = gapVertical + ((count / rows) * (buttonHeight + gapVertical));
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(offsetX, offsetY, buttonWidth, buttonHeight);
        button.tag = count;
        
        
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"unlock.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [button addTarget:self action:@selector(buttonclicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [button setTitle:[NSString stringWithFormat:@"%d",count+1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Futura" size:50.0];
        
        
        NSLog(@"______%d____",categoryValue);
        if ([wordData unlockTheNextLevel:[NSString stringWithFormat:@"%d",categoryValue+1] levels:[NSString stringWithFormat:@"%d",count+1]] == 8) {
            
            NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"unlock.png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [button addTarget:self action:@selector(buttonclicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
            [button setTitle:[NSString stringWithFormat:@"%d",count+1] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:@"Futura" size:50.0];
            unlockCount--;

 
        }
        else if ([wordData unlockTheNextLevel:[NSString stringWithFormat:@"%d",categoryValue+1] levels:[NSString stringWithFormat:@"%d",count+1]] < 8
        && [wordData unlockTheNextLevel:[NSString stringWithFormat:@"%d",categoryValue+1] levels:[NSString stringWithFormat:@"%d",count+1]] >=1){
            
            NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"dots.png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [button addTarget:self action:@selector(buttonclicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
            [button setTitle:[NSString stringWithFormat:@"%d",count+1] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:@"Futura" size:50.0];
            unlockCount--;
        }
        else
        {
            
            NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"lock.png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
           button.titleLabel.font = [UIFont fontWithName:@"Futura" size:50.0];
            
        }
        
       [scrlView addSubview:button];
        
        offsetX+= buttonWidth + gapHorizontal;
        count++;
        
    } while(count < rows * cols);
    
    [Flurry logEvent:[NSString stringWithFormat:@" InLevelView, Category %d and Level %d", categoryValue+1,count]];
 
}

-(IBAction)buttonclicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"Button Tag %d",btn.tag);
    
    [self soundON_OFF:[wordData getGeneralSound]];
    
    singleView = [[SingleLevelView alloc] initWithFrame:[[UIScreen mainScreen] bounds] category:categoryValue levels:btn.tag];
    singleView.delegate = self;
    [self addSubview:singleView];
    
    
    //sending a data to server to
    
    NSLog(@"UID %@ category %d,level %d",userID,categoryValue,btn.tag);
    singleView.userID = userID;
    
    if ([userID length]==0) return;

    NSString *post =
    [[NSString alloc] initWithFormat:@"uid=%@&catagory=%d&level=%d&comeFrom=%@",userID,categoryValue+1,btn.tag+1,@"iPad"];
    NSLog(@"Post string %@",post);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSURL *url = [NSURL URLWithString:@"http://social-brand.in/apps/8words_builder/addlevels.php"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:postData];
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        webData = [NSMutableData data];
        NSLog(@"Data %@",webData);
        
    }
    else
    {
        
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
    
    [self removeFromSuperview];
    
}

#pragma mark- Delegate

-(void)unlockNextLevel{
    
    [self genrateListOfButtons];
    NSLog(@"Next level unlocked");
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





@end
