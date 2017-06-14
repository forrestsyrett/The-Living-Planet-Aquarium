//
//  CraftARItemAR.h
//  CraftARTracking
//
//  Created by Luis Martinell Andreu on 28/07/15.
//  Copyright (c) 2015 Luis Martinell Andreu. All rights reserved.
//

#import "CraftARItem.h"
#import "CraftARCollection.h"
#import "CraftARTrackingContent.h"
#import "Quaternion.h"

@interface CraftARItemAR : CraftARItem

/**
 * True when the CraftARItemAR is being tracked
 * This property is KVO-compliant and can be observed using observeValueForKeyPath
 */
@property (nonatomic, readonly) BOOL isTracked;

/**
 * Specifies the translation applied to the item in the rendering scene
 */
@property (nonatomic, readwrite) CATransform3D itemTranslation;

/**
 * Specifies the rotation applied to the item in the rendering scene
 */
@property (nonatomic, readwrite) Quaternion* itemRotation;

/**
 * Size of the reference image for this AR item
 */
@property (nonatomic, readonly) CGSize referenceSize;

/**
 * Specifies whether the item contents have to be drawn in the scene even if the item is not being tracked.
 * False by default
 */
@property (nonatomic, readwrite) Boolean drawOffTracking;

/**
 * Parent collection.
 */
@property (nonatomic, readonly) CraftARCollection* parentCollection;

/**
 Add content to the AR item
 @param content an instance of CraftARTrackingContent to be displayed on top ot the item's image
 */
-(void) addContent: (CraftARTrackingContent *) content;

/**
 Remove a content from the AR item
 @param content a content that has been previously added to the AR item.
 */
-(void) removeContent: (CraftARTrackingContent *) content;

/**
 Called by the SDK when the item's tracking starts
 */
-(void) trackingStarted;

/**
 Called by the SDK when the item's tracking is lost
 */
-(void) trackingLost;

/**
 Get all contents for this AR item
 */
-(NSArray*) allContents;

@end
