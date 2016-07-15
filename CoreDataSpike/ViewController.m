//
//  ViewController.m
//  CoreDataSpike
//
//  Created by DNA on 7/15/16.
//  Copyright © 2016 DNA. All rights reserved.
//

#import "Header.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "Helper.h"
#import "DetailsTableViewController.h"
#import <UIKit/UIKit.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableView;
@synthesize tableLabelList;
@synthesize tableRequestList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [Helper getScreenWidth], [Helper getScreenHeight]) style:UITableViewStylePlain];
    [self tableView].delegate = self;
    [self tableView].dataSource = self;
    [[self tableView] reloadData];
    [[self tableView] registerClass:[UITableViewCell self] forCellReuseIdentifier:@"CellIdentifier"];
    [[self view] addSubview:tableView];

    tableLabelList = [[NSArray alloc] initWithObjects:@"User",
                      @"Projects",
                      @"Elements",
                      @"Visits", nil];
    
    tableRequestList = [[NSArray alloc] initWithObjects:requestGetUser,
                        requestGetProjects,
                        requestGetElements,
                        requestGetVisits, nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self tableLabelList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier"];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    else {
        for (UIView *view in [[cell contentView] subviews]) {
            [view removeFromSuperview];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell textLabel].text = [[self tableLabelList] objectAtIndex:[indexPath row]];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, [[cell contentView] bounds].size.height - 1, [Helper getScreenWidth], 1)];
    
    bottomLine.backgroundColor = [UIColor grayColor];
    [[cell contentView] addSubview:bottomLine];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsTableViewController *detailsTableViewController = [[DetailsTableViewController alloc] init];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://10.1.1.254:1337/%@", [[self tableRequestList] objectAtIndex:[indexPath row]]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"%@", [(NSDictionary *)responseObject allKeys]);
                detailsTableViewController.tableDataSource = [(NSDictionary *)responseObject allKeys];
                [[self navigationController] pushViewController:detailsTableViewController animated:YES];
            }
            else if ([responseObject isKindOfClass:[NSArray class]]){
                NSMutableArray *arrayIds = [[NSMutableArray alloc] init];
                for (NSDictionary *obj in responseObject) {
                    if([obj objectForKey:@"id"]) {
                        [arrayIds addObject:[obj objectForKey:@"id"]];
                    }
                }
                detailsTableViewController.tableDataSource = arrayIds;
                [[self navigationController] pushViewController:detailsTableViewController animated:YES];
                NSLog(@"%@", arrayIds);
            }
        }
    }];
    [dataTask resume];
}
@end
