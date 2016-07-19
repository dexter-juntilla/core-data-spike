//
//  Visit+CoreDataProperties.h
//  CoreDataSpike
//
//  Created by DNA on 7/19/16.
//  Copyright © 2016 DNA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Visit.h"

NS_ASSUME_NONNULL_BEGIN

@interface Visit (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *visits;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSString *phase;
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *project_id;
@property (nullable, nonatomic, retain) NSString *client_id;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *on_site_detail;
@property (nullable, nonatomic, retain) NSString *actual_visit_date;
@property (nullable, nonatomic, retain) NSString *last_visit_update;
@property (nullable, nonatomic, retain) NSString *details;
@property (nullable, nonatomic, retain) NSString *ios_version;
@property (nullable, nonatomic, retain) NSDate *file_path;
@property (nullable, nonatomic, retain) NSString *report_name;
@property (nullable, nonatomic, retain) NSString *timezone_offset;
@property (nullable, nonatomic, retain) NSString *closedAt;
@property (nullable, nonatomic, retain) NSString *updated_visit_document;
@property (nullable, nonatomic, retain) NSNumber *photo_uploaded;
@property (nullable, nonatomic, retain) NSNumber *photo_taken;
@property (nullable, nonatomic, retain) NSNumber *photo_upload_completed;
@property (nullable, nonatomic, retain) NSString *app_version;
@property (nullable, nonatomic, retain) NSString *id;

@end

NS_ASSUME_NONNULL_END
