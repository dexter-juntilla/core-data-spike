//
//  CoreData.m
//  CoreDataSpike
//
//  Created by DNA on 7/15/16.
//  Copyright © 2016 DNA. All rights reserved.
//

#import "CoreData.h"

@implementation CoreData

@synthesize masterObjectContext = _masterObjectContext;
@synthesize backgroundObjectContext = _backgroundObjectContext;
@synthesize fetchObjectContext = _fetchObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedInstance {
    static dispatch_once_t once;
    static CoreData *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.drumbi.CoreDataSpike" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataSpike" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataSpike.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)masterObjectContext {
    if (_masterObjectContext != nil) {
        return _masterObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    
    NSManagedObjectContext *storageBackgroundObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [storageBackgroundObjectContext setPersistentStoreCoordinator:coordinator];
    
    _masterObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_masterObjectContext setParentContext:storageBackgroundObjectContext];
    return _masterObjectContext;
}

- (NSManagedObjectContext *)backgroundObjectContext {
    if (_backgroundObjectContext != nil) {
        return _backgroundObjectContext;
    }
    
    _backgroundObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_backgroundObjectContext performBlockAndWait:^{
        [_backgroundObjectContext setParentContext:[self masterObjectContext]];
    }];
    
    return _backgroundObjectContext;
}

-(NSManagedObjectContext *)fetchObjectContext {
    if (_fetchObjectContext != nil) {
        return _fetchObjectContext;
    }
    
    _fetchObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_fetchObjectContext performBlock:^{
        [_fetchObjectContext setParentContext:[self masterObjectContext]];
    }];
    
    return _fetchObjectContext;
}

- (void)saveContext {
    [[self backgroundObjectContext] performBlock:^{
        [[self backgroundObjectContext] save:nil];
        
        [[self masterObjectContext] performBlock:^{
            [[self masterObjectContext] save:nil];
            
            [[[self masterObjectContext] parentContext] performBlock:^{
                [[[self masterObjectContext] parentContext] save:nil];
            }];
        }];
    }];
}
@end
