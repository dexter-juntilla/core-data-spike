//
//  User+CoreDataProperties.h
//  CoreDataSpike
//
//  Created by DNA on 7/19/16.
//  Copyright © 2016 DNA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *user_filename;
@property (nullable, nonatomic, retain) NSString *file_path;
@property (nullable, nonatomic, retain) NSNumber *can_access_reporting_portal;
@property (nullable, nonatomic, retain) NSNumber *can_access_dashboard;
@property (nullable, nonatomic, retain) NSString *id;

@end

NS_ASSUME_NONNULL_END
