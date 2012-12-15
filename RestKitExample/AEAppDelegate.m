//
//  AEAppDelegate.m
//  RestKitExample
//
//  Created by Alexander G Edge on 15/12/2012.
//  Copyright (c) 2012 Alexander G Edge. All rights reserved.
//

#import "AEAppDelegate.h"




@implementation AEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self setUpRestKit];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setUpRestKit{
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://127.0.0.1:4567"]];
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    manager.managedObjectStore = managedObjectStore;
    
    // Message objects
    
    RKEntityMapping *messageMapping = [RKEntityMapping mappingForEntityForName:@"AEMessage" inManagedObjectStore:managedObjectStore];
    messageMapping.identificationAttributes = @[ @"messageId" ];
    [messageMapping addAttributeMappingsFromDictionary:@{
     @"_id" : @"messageId",
     @"content" : @"content",
     @"sentAt" : @"sentAt",
     @"conversationId" : @"conversationId",
     @"sender" : @"sender"
     }];
    
    // Register our mappings with the provider
    
    [manager addResponseDescriptorsFromArray:@[
     
     [RKResponseDescriptor responseDescriptorWithMapping:messageMapping
                                             pathPattern:@"/messages"
                                                 keyPath:@"messages"
                                             statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]
     ]];
    
    [manager addRequestDescriptorsFromArray:@[
     
     [RKRequestDescriptor requestDescriptorWithMapping:[messageMapping inverseMapping] objectClass:[AEMessage class] rootKeyPath:nil]
     
     ]];
    
    
   
    // Conversation objects
    
    RKEntityMapping *conversationMapping = [RKEntityMapping mappingForEntityForName:@"AEConversation" inManagedObjectStore:managedObjectStore];
    conversationMapping.identificationAttributes = @[ @"conversationId" ];
    [conversationMapping addAttributeMappingsFromDictionary:@{
     @"_id" : @"conversationId",
     @"unread":@"unread"
     }];
    
    [conversationMapping addRelationshipMappingWithSourceKeyPath:@"latestMessage" mapping:messageMapping];
    
    [manager addResponseDescriptorsFromArray:@[
     
     [RKResponseDescriptor responseDescriptorWithMapping:conversationMapping
                                             pathPattern:@"/conversations"
                                                 keyPath:@"conversations"
                                             statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]
     ]];
    
    
    
    
    [manager addRequestDescriptorsFromArray:@[
     
     [RKRequestDescriptor requestDescriptorWithMapping:[conversationMapping inverseMapping] objectClass:[AEConversation class] rootKeyPath:nil]
     
     ]];
    
    // Pagination
    
    RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
    
    [paginationMapping addAttributeMappingsFromDictionary:@{
     @"currentPage" : @"currentPage",
     @"perPage" : @"perPage",
     @"objectCount" : @"objectCount"}];
    
    
    [[RKObjectManager sharedManager] setPaginationMapping:paginationMapping];
    
    // set the date parser up
    
    [RKObjectMapping addDefaultDateFormatterForString:@"yyyy-MMMM-d'T'HH:mm'Z'" inTimeZone:nil];
    
    
    
    
    [[RKObjectManager sharedManager].router.routeSet addRoute:[RKRoute
                                                               routeWithClass:[AEConversation class]
                                                               pathPattern:@"/conversations"
                                                               method:RKRequestMethodPOST]];
    
    [[RKObjectManager sharedManager].router.routeSet addRoute:[RKRoute
                                                               routeWithClass:[AEMessage class]
                                                               pathPattern:@"/messages"
                                                               method:RKRequestMethodAny]];
    
    
    
    
    
    
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    
    /**
     Complete Core Data stack initialization
     */
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"RestKitExample.sqlite"];
    
    NSError *error;
    
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    
}

@end
