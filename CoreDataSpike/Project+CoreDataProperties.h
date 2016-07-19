//
//  Project+CoreDataProperties.h
//  CoreDataSpike
//
//  Created by DNA on 7/19/16.
//  Copyright © 2016 DNA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Project.h"

NS_ASSUME_NONNULL_BEGIN

@interface Project (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *client_id;
@property (nullable, nonatomic, retain) NSString *project_name;
@property (nullable, nonatomic, retain) NSString *project_type;
@property (nullable, nonatomic, retain) NSString *project_number;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *visits;
@property (nullable, nonatomic, retain) NSString *phases;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *project_filename;
@property (nullable, nonatomic, retain) NSString *file_path;
@property (nullable, nonatomic, retain) NSNumber *single_reporting;

@end

NS_ASSUME_NONNULL_END
