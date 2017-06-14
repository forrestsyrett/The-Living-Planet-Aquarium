//
//  CraftARContentFactory.h
//  CraftARSDK_AR
//
//  Created by Luis Martinell Andreu on 08/09/15.
//  Copyright (c) 2015 Luis Martinell Andreu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CraftARTRackingContent.h"


/**
 * Factory to create CraftAR contents from the scene description of an AR item.
 * This class is abstract.
 */
@interface CraftARContentFactory : NSObject

/**
 * Returns the current items factory
 */
+ (CraftARContentFactory*) factory;

/*
 * Set the factory
 */
+ (void) setFactory: (CraftARContentFactory*) factory;


/**
 * Set the content class for a specific content type. This is useful for
 * extending contents. You would call it like this: [[CraftARContentFactory factory] setContentClass: [MyCustomImageContent class] fortype: @"image_custom"].
 * @param contentClass Class object for the custom CraftARTrackingContent subclass.
 * @param tyoe String that identifies a type of content from the CraftAR service or a custom type.
 */
- (void) setContentClass: (id) contentClass fortype: (NSString*) type;

- (CraftARTrackingContent *) contentFromSceneDescriptionItem: (NSDictionary *) sceneItem withContentVersion: (int) version withError: (NSError*__autoreleasing*) error;

@end
