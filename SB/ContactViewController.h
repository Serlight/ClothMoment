//
//  ContactViewController.h
//  SB
//
//  Created by serlight on 12/5/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *friendSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (weak, nonatomic) IBOutlet UITableView *contactView;

@end
