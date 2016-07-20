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
#import <CoreData/CoreData.h>
#import "CoreData.h"
#import "User.h"
#import "Project.h"
#import "Element.h"
#import "Visit.h"

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
                      @"Project",
                      @"Element",
                      @"Visit", nil];
    
    tableRequestList = [[NSArray alloc] initWithObjects:requestGetUser,
                        requestGetProjects,
                        requestGetElements,
                        requestGetVisits, nil];
    
    UIBarButtonItem *deleteData = [[UIBarButtonItem alloc] initWithTitle: @"Delete Data" style:UIBarButtonItemStylePlain target: self action:@selector(leftBarButtonPressed)];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationItem setLeftBarButtonItem:deleteData];
    
    UIBarButtonItem *requestData = [[UIBarButtonItem alloc] initWithTitle: @"Get Data" style:UIBarButtonItemStylePlain target: self action:@selector(rightBarButtonPressed)];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationItem setRightBarButtonItem:requestData];
}

- (void) leftBarButtonPressed {
    [self dropAll];
}

- (void) rightBarButtonPressed {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = [[self view] center];
    spinner.hidesWhenStopped = YES;
    [[self view] addSubview:spinner];
    [spinner startAnimating];
    
    [self requestData];
    
    [spinner stopAnimating];
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
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[[self tableLabelList] objectAtIndex:[indexPath row]]];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[[self tableLabelList] objectAtIndex:[indexPath row]] inManagedObjectContext:[[CoreData sharedInstance] masterObjectContext]];
    [fetchRequest setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *result = [[[[CoreData sharedInstance] masterObjectContext] executeRequest:fetchRequest error:&error] finalResult];
    NSMutableArray *attributeNames = [[NSMutableArray alloc] init];
    
    if ([result count] > 1) {
        for (int i=0; i<[result count]; i++) {
            NSString *id = [[result objectAtIndex:i] valueForKey:@"id"];
            NSLog(@"id = %@", id);
            [attributeNames addObject:id];
        }
        detailsTableViewController.tableData = result;
        detailsTableViewController.tableDataSource = attributeNames;
    }
    else if ([result count] == 1) {
        NSDictionary *attributes = [entityDescription attributesByName];
        for (NSString *attribute in attributes) {
            id value = [[result objectAtIndex:0] valueForKey: attribute];
            NSLog(@"attribute %@ = %@", attribute, value);
            [attributeNames addObject:attribute];
        }
        detailsTableViewController.tableData = result;
        detailsTableViewController.tableDataSource = attributeNames;
    }
    
    detailsTableViewController.modelType = [[self tableLabelList] objectAtIndex:[indexPath row]];
    [[self navigationController] pushViewController:detailsTableViewController animated:YES];
}

- (void)dropAll {
    for (NSString *entityName in [self tableLabelList]) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
        NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
        
        NSError *deleteError = nil;
        [[[CoreData sharedInstance] persistentStoreCoordinator] executeRequest:delete withContext:[[CoreData sharedInstance] masterObjectContext] error:&deleteError];
        [[CoreData sharedInstance] saveContext];
    }
}

- (void)requestData {
    for (NSString *urlString in [self tableRequestList]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, urlString]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                if ([urlString isEqualToString:requestGetUser]) {
                    NSError *error = nil;
                    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[[CoreData sharedInstance] backgroundObjectContext]];
                    User *user = [[User alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[[CoreData sharedInstance] backgroundObjectContext]];
                    
                    if ([responseObject objectForKey:@"email"]) {
                        NSDictionary *email = [responseObject objectForKey:@"email"];
                        if ([email objectForKey:@"main"]) {
                            user.email = [email objectForKey:@"main"];
                        }
                    }
                    if ([responseObject objectForKey:@"name"]){
                        user.name = [responseObject objectForKey:@"name"];
                    }
                    if ([responseObject objectForKey:@"type"]){
                        user.type = [responseObject objectForKey:@"type"];
                    }
                    if ([responseObject objectForKey:@"title"]){
                        user.title = [responseObject objectForKey:@"title"];
                    }
                    if ([responseObject objectForKey:@"user_filename"]){
                        user.user_filename = [responseObject objectForKey:@"user_filename"];
                    }
                    if ([responseObject objectForKey:@"file_path"]){
                        user.file_path = [responseObject objectForKey:@"file_path"];
                    }
                    if ([responseObject objectForKey:@"can_access_reporting_portal"]){
                        user.can_access_reporting_portal = [responseObject objectForKey:@"can_access_reporting_portal"];
                    }
                    if ([responseObject objectForKey:@"can_access_dashboard"]){
                        user.can_access_dashboard = [responseObject objectForKey:@"can_access_dashboard"];
                    }
                    if ([responseObject objectForKey:@"id"]){
                        user.id = [responseObject objectForKey:@"id"];
                    }
                    
                    [[CoreData sharedInstance] saveContext];
                    if (error) {
                        NSLog(@"%@", error);
                    }
                }
                else if ([urlString isEqualToString:requestGetProjects]) {
                    for (NSDictionary *obj in responseObject) {
                        NSError *error = nil;
                        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:[[CoreData sharedInstance] backgroundObjectContext]];
                        Project *project = [[Project alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[[CoreData sharedInstance] backgroundObjectContext]];
                        
                        if ([obj objectForKey:@"client_id"]) {
                            project.client_id = [obj objectForKey:@"client_id"];
                        }
                        if ([obj objectForKey:@"project_name"]) {
                            project.project_name = [obj objectForKey:@"project_name"];
                        }
                        if ([obj objectForKey:@"project_type"]) {
                            project.project_type = [obj objectForKey:@"project_type"];
                        }
                        if ([obj objectForKey:@"project_number"]) {
                            project.project_number = [obj objectForKey:@"project_number"];
                        }
                        if ([obj objectForKey:@"status"]) {
                            project.status = [obj objectForKey:@"status"];
                        }
                        if ([obj objectForKey:@"phases"]) {
                            project.phases = [obj objectForKey:@"phases"];
                        }
                        if ([obj objectForKey:@"visits"]) {
                            project.visits = [obj objectForKey:@"visits"];
                        }
                        if ([obj objectForKey:@"type"]) {
                            project.type = [obj objectForKey:@"type"];
                        }
                        if ([obj objectForKey:@"id"]) {
                            project.id = [obj objectForKey:@"id"];
                        }
                        if ([obj objectForKey:@"project_filename"]) {
                            project.project_filename = [obj objectForKey:@"project_filename"];
                        }
                        if ([obj objectForKey:@"file_path"]) {
                            project.file_path = [obj objectForKey:@"file_path"];
                        }
                        if ([obj objectForKey:@"single_reporting"]) {
                            project.single_reporting = [obj objectForKey:@"single_reporting"];
                        }
                        
                        [[CoreData sharedInstance] saveContext];
                        if (error) {
                            NSLog(@"%@", error);
                        }
                        
                    }
                }
                else if ([urlString isEqualToString:requestGetElements]) {
                    for (NSDictionary *obj in responseObject) {
                        NSError *error = nil;
                        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Element" inManagedObjectContext:[[CoreData sharedInstance] backgroundObjectContext]];
                        Element *element = [[Element alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[[CoreData sharedInstance] backgroundObjectContext]];
                        
                        if ([obj objectForKey:@"element_name"]) {
                            element.element_name = [obj objectForKey:@"element_name"];
                        }
                        if ([obj objectForKey:@"createdAt"]) {
                            element.createdAt = [obj objectForKey:@"createdAt"];
                        }
                        if ([obj objectForKey:@"updatedAt"]) {
                            element.updatedAt = [obj objectForKey:@"updatedAt"];
                        }
                        if ([obj objectForKey:@"id"]) {
                            element.id = [obj objectForKey:@"id"];
                        }
                        
                        [[CoreData sharedInstance] saveContext];
                        if (error) {
                            NSLog(@"%@", error);
                        }
                    }
                }
                else if ([urlString isEqualToString:requestGetVisits]) {
                    for (NSDictionary *obj in responseObject) {
                        NSError *error = nil;
                        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:[[CoreData sharedInstance] backgroundObjectContext]];
                        Visit *visit = [[Visit alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[[CoreData sharedInstance] backgroundObjectContext]];
                        
                        if ([obj objectForKey:@"visits"]) {
                            visit.visits = [obj objectForKey:@"visits"];
                        }
                        if ([obj objectForKey:@"time"]) {
                            visit.time = [obj objectForKey:@"time"];
                        }
                        if ([obj objectForKey:@"phase"]) {
                            visit.phase = [obj objectForKey:@"phase"];
                        }
                        if ([obj objectForKey:@"user_id"]) {
                            visit.user_id = [obj objectForKey:@"user_id"];
                        }
                        if ([obj objectForKey:@"date"]) {
                            visit.date = [obj objectForKey:@"date"];
                        }
                        if ([obj objectForKey:@"project_id"]) {
                            visit.project_id = [obj objectForKey:@"project_id"];
                        }
                        if ([obj objectForKey:@"client_id"]) {
                            visit.client_id = [obj objectForKey:@"client_id"];
                        }
                        if ([obj objectForKey:@"status"]) {
                            visit.status = [obj objectForKey:@"status"];
                        }
                        if ([obj objectForKey:@"on_site_detail"]) {
                            visit.on_site_detail = [obj objectForKey:@"on_site_detail"];
                        }
                        if ([obj objectForKey:@"actual_visit_date"]) {
                            visit.actual_visit_date = [obj objectForKey:@"actual_visit_date"];
                        }
                        if ([obj objectForKey:@"last_visit_update"]) {
                            visit.last_visit_update = [obj objectForKey:@"last_visit_update"];
                        }
                        if ([obj objectForKey:@"details"]) {
                            visit.details = [obj objectForKey:@"details"];
                        }
                        if ([obj objectForKey:@"ios_version"]) {
                            visit.ios_version = [obj objectForKey:@"ios_version"];
                        }
                        if ([obj objectForKey:@"file_path"]) {
                            visit.file_path = [obj objectForKey:@"file_path"];
                        }
                        if ([obj objectForKey:@"report_name"]) {
                            visit.report_name = [obj objectForKey:@"report_name"];
                        }
                        if ([obj objectForKey:@"timezone_offset"]) {
                            visit.timezone_offset = [obj objectForKey:@"timezone_offset"];
                        }
                        if ([obj objectForKey:@"closedAt"]) {
                            visit.closedAt = [obj objectForKey:@"closedAt"];
                        }
                        if ([obj objectForKey:@"updated_visit_document"]) {
                            visit.updated_visit_document = [obj objectForKey:@"updated_visit_document"];
                        }
                        if ([obj objectForKey:@"photo_uploaded"]) {
                            visit.photo_uploaded = [obj objectForKey:@"photo_uploaded"];
                        }
                        if ([obj objectForKey:@"photo_upload_completed"]) {
                            visit.photo_upload_completed = [obj objectForKey:@"photo_upload_completed"];
                        }
                        if ([obj objectForKey:@"app_version"]) {
                            visit.app_version = [obj objectForKey:@"app_version"];
                        }
                        if ([obj objectForKey:@"id"]) {
                            visit.id = [obj objectForKey:@"id"];
                        }
                        
                        [[CoreData sharedInstance] saveContext];
                        if (error) {
                            NSLog(@"%@", error);
                        }
                    }
                }
            }
        }];
        [dataTask resume];
    }
}

@end
