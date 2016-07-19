//
//  DetailsTableViewController.m
//  CoreDataSpike
//
//  Created by DNA on 7/15/16.
//  Copyright © 2016 DNA. All rights reserved.
//

#import "DetailsTableViewController.h"
#import "Helper.h"
#import <CoreData/CoreData.h>
#import "CoreData.h"
#import "User.h"

@interface DetailsTableViewController ()

@end

@implementation DetailsTableViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [Helper getScreenWidth], [Helper getScreenHeight]) style:UITableViewStylePlain];
    [self tableView].delegate = self;
    [self tableView].dataSource = self;
    [[self tableView] reloadData];
    [[self tableView] registerClass:[UITableViewCell self] forCellReuseIdentifier:@"CellIdentifier"];
    [[self view] addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self tableDataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier"];
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [[self tableDataSource] objectAtIndex:[indexPath row]];

    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, [[cell contentView] bounds].size.height - 1, [Helper getScreenWidth], 1)];
    
    bottomLine.backgroundColor = [UIColor grayColor];
    [[cell contentView] addSubview:bottomLine];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self tableData] count] > 1) {
        DetailsTableViewController *detailsTableViewController = [[DetailsTableViewController alloc] init];
        NSArray *keys = [[[[[self tableData] objectAtIndex:[indexPath row]] entity] attributesByName] allKeys];
//      NSDictionary *obj = [[[self tableData] objectAtIndex:[indexPath row]] dictionaryWithValuesForKeys:keys];
        
        NSArray *tableData = [[NSArray alloc] initWithObjects:[[self tableData] objectAtIndex:[indexPath row]], nil];
        detailsTableViewController.tableData = tableData;
        detailsTableViewController.tableDataSource = keys;
        [[self navigationController] pushViewController:detailsTableViewController animated:YES];
    }
    else {
        NSDictionary *obj = [[[self tableData] objectAtIndex:0] dictionaryWithValuesForKeys:[self tableDataSource]];
        NSLog(@"%@", [obj objectForKey:[[self tableDataSource] objectAtIndex:[indexPath row]]]);
    }
}

@end
