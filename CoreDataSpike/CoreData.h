//
//  CoreData.h
//  CoreDataSpike
//
//  Created by DNA on 7/15/16.
//  Copyright © 2016 DNA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreData : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *masterObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *fetchObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedInstance;
- (NSManagedObjectContext *)masterObjectContext;
- (NSManagedObjectContext *)backgroundObjectContext;
- (NSManagedObjectContext *)fetchObjectContext;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
