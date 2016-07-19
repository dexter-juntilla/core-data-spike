//
//  Element+CoreDataProperties.h
//  CoreDataSpike
//
//  Created by DNA on 7/19/16.
//  Copyright © 2016 DNA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Element.h"

NS_ASSUME_NONNULL_BEGIN

@interface Element (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *updatedAt;
@property (nullable, nonatomic, retain) NSString *createdAt;
@property (nullable, nonatomic, retain) NSString *element_name;

@end

NS_ASSUME_NONNULL_END
