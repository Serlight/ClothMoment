//
//  FeedBackViewController.h
//  SB
//
//  Created by serlight on 12/26/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SZTextView.h>


@interface FeedBackViewController : UIViewController

@property (weak, nonatomic) IBOutlet SZTextView *feedbackTextView;

@property (weak, nonatomic) IBOutlet UIButton *commit;

@end
