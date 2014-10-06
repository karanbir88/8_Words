//
//  InfoView.h
//  8_Words
//
//  Created by Jaideep on 3/12/13.
//  Copyright (c) 2013 Anil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@class SettingSingleton;
@interface InfoView : UIView<MFMailComposeViewControllerDelegate>
{
    UIImageView *underRightImage;
    SettingSingleton *setting;

}
@end
