//
//  User+CoreDataProperties.m
//  CoreDataSpike
//
//  Created by DNA on 7/19/16.
//  Copyright © 2016 DNA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

@dynamic name;
@dynamic email;
@dynamic type;
@dynamic title;
@dynamic user_filename;
@dynamic file_path;
@dynamic can_access_reporting_portal;
@dynamic can_access_dashboard;
@dynamic id;

@end
