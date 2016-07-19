//
//  DetailsTableViewController.h
//  CoreDataSpike
//
//  Created by DNA on 7/15/16.
//  Copyright © 2016 DNA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property UITableView *tableView;
@property NSArray *tableDataSource;
@property NSArray *tableData;

@end
