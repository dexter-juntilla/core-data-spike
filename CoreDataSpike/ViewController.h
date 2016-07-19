//
//  ViewController.h
//  CoreDataSpike
//
//  Created by DNA on 7/15/16.
//  Copyright © 2016 DNA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property UITableView *tableView;
@property NSArray *tableLabelList;
@property NSArray *tableRequestList;

- (void)leftBarButtonPressed;
- (void)rightBarButtonPressed;
- (void)requestData;
- (void)dropAll;

@end

