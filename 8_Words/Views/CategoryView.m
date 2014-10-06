//
//  CategoryView.m
//  8_Words
//
//  Created by Jaideep on 3/6/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import "CategoryView.h"
#import "LevelsView.h"
#import "OptionView.h"
#import "SettingSingleton.h"
#import "WordsData.h"
#import "Reachability.h"

#import "GAITrackedViewController.h"
#import "GAI.h"


// 1
#import "RageIAPHelper.h"
#import <StoreKit/StoreKit.h>




@implementation CategoryView
@synthesize categoryListArray,userID,webData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil//Frame:(CGRect)frame
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];//Frame:frame];
    if (self) {
        // Initialization code
        wordData = [[WordsData alloc] init];
        setting =[ SettingSingleton sharedInstance];
        _rageIAP = [[RageIAPHelper sharedInstance] init];

        category1=category2=category3=category4 = 0;
        
        [gaiTracker.tracker sendView:@"Category View"];
        
        [self initialize];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Reachabilty code
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    [reach startNotifier];
    
    
    
}


//Reachabilty method...
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //        notificationLabel.text = @"Notification Says Reachable";
        NSLog(@"Reachable");
        [self reload];
        
    }
    else
    {
        //        notificationLabel.text = @"Notification Says Unreachable";
        NSLog(@"Not Reachable");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection error!" message:@"No network available.Please enabled 3G connection or Wi-Fi." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
        
        
    }
}

-(void) initialize {

    //Read the plist file
    NSString *categorypath = [[NSBundle mainBundle] pathForResource:@"categorylist" ofType:@"plist"];
    categoryListArray = [[NSMutableArray alloc] initWithContentsOfFile:categorypath];
    
    

    [self setUnderBackgroundimage];
    [self setupCategoryButtons];
    
    NSLog(@"USER ID %@",userID);
}


-(void) setUnderBackgroundimage{
    
    underRightImage = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"levelbg.jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    underRightImage.image = image;
    [self.view addSubview:underRightImage];
    
    
    
    UILabel *categorylbl = [[UILabel alloc] initWithFrame:CGRectMake(164, 80, 440, 100)];
    categorylbl.text = @"Choose a Category";
    categorylbl.backgroundColor = [UIColor clearColor];
    categorylbl.font = [UIFont fontWithName:@"Dungeon" size:80.0f];
    categorylbl.textColor = [UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0];
    categorylbl.textAlignment = UITextAlignmentCenter;
    
    [self.view addSubview:categorylbl];
    //back arrow
    UIButton *backArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    backArrow.frame = CGRectMake(0, 0, 80, 80);
    [backArrow setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backArrow addTarget:self action:@selector(backArrow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backArrow];
    
    //Label for scroll to see more
    UILabel *scrollelbl = nil;
    scrollelbl = [[UILabel alloc] initWithFrame:CGRectMake(164, 950, 400, 40)];
    scrollelbl.text = @"Scroll to see more";
    scrollelbl.backgroundColor = [UIColor clearColor];
    scrollelbl.font = [UIFont fontWithName:@"Dungeon" size:34.0f];
    scrollelbl.textColor = [UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0];
    scrollelbl.textAlignment = UITextAlignmentCenter;
    
    [self.view addSubview:scrollelbl];


}



-(void) setupCategoryButtons{
    
    for(id view in self.view.subviews )
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            
            [view removeFromSuperview];
        }
        
        
        
    }

    
    UIButton *button = nil;
    int rows = 2;
    int cols = 10;
    float buttonWidth = 282.0f;
    float buttonHeight = 114.0f;
    
    scrlView = [[UIScrollView alloc] initWithFrame:CGRectMake(59, 200, 650, 750)];
    scrlView.pagingEnabled = NO;
    scrlView.contentSize = CGSizeMake(280, cols*buttonHeight+buttonHeight+200);
    NSLog(@"Height %f",scrlView.contentSize.height);
    
    scrlView.backgroundColor = [UIColor clearColor];
    scrlView.showsHorizontalScrollIndicator = NO;
    scrlView.showsVerticalScrollIndicator = NO;
    scrlView.scrollsToTop = YES;
    [self.view addSubview:scrlView];
    
    //restore button
    UIButton *backArrow1 = [UIButton buttonWithType:UIButtonTypeCustom];
    backArrow1.frame = CGRectMake(250,scrlView.contentSize.height-146, 140, 70);
    [backArrow1 setImage:[UIImage imageNamed:@"restore.png"] forState:UIControlStateNormal];
    [backArrow1 addTarget:self action:@selector(restoreTapped:) forControlEvents:UIControlEventTouchUpInside];
    [scrlView addSubview:backArrow1];
    

    
    
    float gridWidth = 640.0f;
    float gridHeight = scrlView.contentSize.height-200;
    
    
    float gapHorizontal = ((gridWidth - (buttonWidth * rows)) / (rows + 1));
    float gapVertical = ((gridHeight - (buttonHeight * cols)) / (cols + 1));
    
    float offsetX =0.0f;
    float offsetY = 0.0f;
    
    NSLog(@"gapHorizontal  gapVertical %f %f",gapHorizontal,gapVertical);
    
    countButton = 0;
    
    do {
        offsetX = gapHorizontal + ((countButton % rows) * (buttonWidth + gapHorizontal));
        offsetY = gapVertical + ((countButton / rows) * (buttonHeight + gapVertical));
        
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        button.frame = CGRectMake((offsetX), (offsetY), buttonWidth, buttonHeight);
        
        button.tag = countButton;
        NSLog(@"Button %d ,%@",countButton, [categoryListArray description]);
        
        NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"categorybtnbg.png"];//[NSString stringWithFormat:@"%@.png",[categoryListArray objectAtIndex:countButton]]];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        [button setTitle:[NSString stringWithFormat:@"%@",[categoryListArray objectAtIndex:countButton]] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Dungeon" size:55.0]];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [button setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bollywoodButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (countButton==15||countButton == 16||countButton == 17||countButton==18||countButton==19) {
            
            if ([wordData inAppPurchaseValue] == 0){
                
                NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"lock-icon.png"];//[NSString stringWithFormat:@"%@.png",[categoryListArray objectAtIndex:countButton]]];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                [button setBackgroundImage:image forState:UIControlStateNormal];
                
                [button setTitle:[NSString stringWithFormat:@"%@",[categoryListArray objectAtIndex:countButton]] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont fontWithName:@"Dungeon" size:55.0]];
                [button setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
                [button addTarget:self action:@selector(bollywoodButton:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"categorybtnbg.png"];//[NSString stringWithFormat:@"%@.png",[categoryListArray objectAtIndex:countButton]]];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                [button setBackgroundImage:image forState:UIControlStateNormal];
                
                [button setTitle:[NSString stringWithFormat:@"%@",[categoryListArray objectAtIndex:countButton]] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont fontWithName:@"Dungeon" size:55.0]];
                [button setTitleColor:[UIColor colorWithRed:127/256.0 green:72/256.0 blue:7/256.0 alpha:1.0] forState:UIControlStateNormal];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
                [button addTarget:self action:@selector(bollywoodButton:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
            }
            
            
        }

        [scrlView addSubview:button];
        offsetX+= buttonWidth + gapHorizontal;
        
        countButton++;
        
    } while(countButton < rows*cols);
    
    
    
    
    
}



-(void)backArrow
{
    [self soundON_OFF:[wordData getGeneralSound]];
    [self dismissModalViewControllerAnimated:NO];
}

#pragma mark-
#pragma Actions

-(IBAction)bollywoodButton:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag>= 0 && btn.tag<15)
    {
         NSLog(@"Category Tag %d",btn.tag);

        levelsview = [[LevelsView alloc] initWithFrame:[[UIScreen mainScreen] bounds] category:btn.tag];

        [self soundON_OFF:[wordData getGeneralSound]];

        [self.view addSubview:levelsview];

        [Flurry logEvent:[NSString stringWithFormat:@" %d Category buttonClicked",btn.tag]];
         [self sendRequireDataToServer:btn.tag];


    }else if (btn.tag==15||btn.tag == 16||btn.tag == 17||btn.tag==18||btn.tag==19) {
         NSLog(@"Category Tag %d",btn.tag);

            if ([wordData inAppPurchaseValue] == 1) {


                levelsview = [[LevelsView alloc] initWithFrame:[[UIScreen mainScreen] bounds] category:btn.tag];

                [self soundON_OFF:[wordData getGeneralSound]];

                [self.view addSubview:levelsview];

                [Flurry logEvent:[NSString stringWithFormat:@" %d Category buttonClicked",btn.tag]];


                [self sendRequireDataToServer:btn.tag];


            }
            else{
                [self performSelector:@selector(buyProVersion)];
                NSLog(@"_______ GET EXTRA :) _______");

            }
        }

    
}

-(void) sendRequireDataToServer:(int) categoryTag{
    // Sending a data to server...
    
    NSLog(@"UserID %@ category %d",userID,categoryTag);
    levelsview.userID = userID;
    
    if ([userID length]==0) return;
    
    NSString *post =
    [[NSString alloc] initWithFormat:@"uid=%@&catagory=%d&comeFrom=%@",userID,categoryTag+1,@"iPad"];
    
    NSLog(@"Post string %@",post);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSURL *url = [NSURL URLWithString:@"http://social-brand.in/apps/8words_builder/addCatagory.php"];
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
-(void) soundON_OFF:(int) _soundValue{
    
    if (_soundValue == 1) {
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"oneclick" ofType:@"mp3"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFilePath], &soundID);
        AudioServicesPlaySystemSound (soundID);
        
        
    }
    else
    {
        NSLog(@"Sound is desabled.");
    }
}



-(void)buyProVersion{
    
    popUp= nil;
    
    popUp = [[UIView alloc] initWithFrame:[self.view bounds]];//CGRectMake(-100, -100, 450, 720)]://[self.view bounds]];
    popUp.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [self.view addSubview:popUp];
    
    [self setInAppPurchaseView];
    [UIView animateWithDuration:0.3/1.5 animations:^{
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                popUp.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    
    
}



-(void) setInAppPurchaseView {
    
    
    UIImageView *img =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    NSString *path = [[NSString alloc]  initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"get_extrabtn.png"];
    
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    img.image = image;
    [popUp addSubview:img];

    
    
    UIButton *getEvtra = [UIButton buttonWithType:UIButtonTypeCustom];
    getEvtra.frame = CGRectMake(180, 809, 403, 71);
    //[getEvtra setImage:[UIImage imageNamed:@"get_extrabtn.png"] forState:UIControlStateNormal];
    // [getEvtra setTitle:@"Get Extra" forState:UIControlStateNormal];
    [getEvtra addTarget:self action:@selector(clickonBuyProButton) forControlEvents:UIControlEventTouchUpInside];
    
    //set buy pro button
    UIButton *backArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    backArrow.frame = CGRectMake(180, 885, 403, 71);
    // [backArrow setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backArrow addTarget:self action:@selector(removeLavelsView) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    
    //Adding a button to the view
    [popUp addSubview:backArrow];
    [popUp addSubview:getEvtra];
    
}


#pragma mark- In App Purchase
-(void) removeLavelsView{
    
    [popUp removeFromSuperview];
    
}

-(void) clickonBuyProButton{
    
    
    
    SKProduct * product = (SKProduct *) _products[0];
    //  NSLog(@"SKProducts %@",product.localizedTitle);
    
    if ([[RageIAPHelper sharedInstance] productPurchased:product.productIdentifier]) {
        [wordData inAppPuchaseValueUpdate];
    }
    else
    {
        SKProduct *product = _products[0];
        NSLog(@"Buying %@...", product.productIdentifier);
        
        if (_products[0]==nil)
            return;
        
        [[RageIAPHelper sharedInstance] buyProduct:product];
        
        if ([[RageIAPHelper sharedInstance] productPurchased:product.productIdentifier]) {
            [wordData inAppPuchaseValueUpdate];
        }
    }
    
    
    NSLog(@"Buy Pro button pressed.");
}


- (void)reload {
    
    _products = nil;
    [_rageIAP requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
     {
         if (success) {
             _products = products;
             NSLog(@"_products %@",_products);
         }
     }];
}



- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    //[self updateStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    [wordData inAppPuchaseValueUpdate];
    [self setupCategoryButtons];

    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [popUp removeFromSuperview];
            
            *stop = YES;
        }
    }];
    
    
    NSLog(@"5 Category purchased");
    [self showMessage];
}


-(void) showMessage{
    
    UILabel *lbl;
    if (message != nil) {
        [message removeFromSuperview];
        message = nil;
    }
    message = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-160,
                                                       [[UIScreen mainScreen] bounds].size.height/2-88, 320, 200)];
    [message setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    [message.layer setCornerRadius:8.0f];
    message.alpha = 0.0;
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 300, 40)];
    lbl.text = @"5 Category purchased";
    lbl.font = [UIFont fontWithName:@"American Typewriter" size:25.0];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    [message addSubview:lbl];
    [self.view addSubview:message];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    message.alpha = 1.0f;
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(removeMessage) userInfo:nil repeats:NO];
    
}

-(void)removeMessage{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    message.alpha = 0.0f;
    [UIView commitAnimations];
    
    // [message removeFromSuperview];
}
//restore transjection
// Add new method

- (IBAction)restoreTapped:(id)sender{
    
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
    
}




@end
