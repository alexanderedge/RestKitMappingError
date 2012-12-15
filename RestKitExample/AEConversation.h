//
//  AEConversation.h
//  RestKitExample
//
//  Created by Alexander Edge on 19/07/2012.
//  Copyright (c) 2012 Alexander Edge Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AEMessage;

@interface AEConversation : NSManagedObject

@property (nonatomic, strong) NSString   *conversationId;
@property (nonatomic, strong) NSNumber   *unread;
@property (nonatomic, strong) AEMessage  *latestMessage;

@end
