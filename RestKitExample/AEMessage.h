//
//  AEMessage.h
//  RestKitExample
//
//  Created by Alexander Edge on 19/07/2012.
//  Copyright (c) 2012 Alexander Edge Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AEMessage : NSManagedObject

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSDate *sentAt;
@property (nonatomic, retain) NSString *messageId;
@property (nonatomic, retain) NSString *sender;
@property (nonatomic, retain) NSString *recipient;
@property (nonatomic, retain) NSString *conversationId;

@end
