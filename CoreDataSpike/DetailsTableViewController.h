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
@property NSString *modelType;
@property NSMutableArray *tableDataSource;
@property NSMutableArray *tableData;

@end
