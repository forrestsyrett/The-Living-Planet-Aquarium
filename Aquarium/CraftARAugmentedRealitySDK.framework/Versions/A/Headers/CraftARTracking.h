//
//  CraftARTracking.h
//  CraftARTracking
//
//  Created by Luis Martinell Andreu on 28/07/15.
//  Copyright (c) 2015 Luis Martinell Andreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CraftARItemAR.h"


@protocol CraftARTrackingEventsProtocol;

/*
 * The CraftARTracking class allows to manage the tracking for the
 * augmented reality experience in the attached video capture.
 * It offers an interface for managing references and their contents and
 * the execution of the process to track the AR Items and produce the
 * information necessary to render the augmented scene.
 */
@interface CraftARTracking : NSObject

/**
 * Get the singleton instance of the CraftARTracking class
 */
+ (CraftARTracking*) sharedTracking;

/// The tracking delegate will receive events from the tracking (started/stop tracking an AR item)
@property (nonatomic, weak) id <CraftARTrackingEventsProtocol> delegate;

/**
 Starts tracking the added AR items.
 */
- (void) startTracking;

/**
 Starts tracking the added AR items.
 * @param timeout Maximum amount of time to wait to detect AR Items. If no item
 * is detected after this time, the trackingTimeoutOver message will be sent to the delegate.
 */
- (void) startTrackingWithTimeout: (NSTimeInterval) timeout;

/**
 Stop the tracking.
 */
- (void) stopTracking;

/**
 * Returns whether the tracking is enabled or not (startTracking has been called)
 */
- (BOOL) isTracking;

/**
 Add a CraftAR AR item to initiate a tracking augmented reality experience
 @param item to be added for tracking.
 @return CraftARError NSError indicating if there has been any problem adding the item, nil if there are no errors.
 @see CraftARItemAR
 @note This process can take some time, consider calling this method on a background queue.
 */
- (CraftARError*) addARItem:(CraftARItemAR *)item;

/**
 Remove an AR item from the augmented reality experience if the item has not been added, this method has no effect.
 @param item The item to be removed from the tracking module.
 @see CraftARItemAR
 */
- (void) removeARItem:(CraftARItemAR *)item;

/**
 Removes all items
 */
- (void)removeAllARItems;

/**
 * Check the Quality of an image for AR.
 * Tests how good the image is for tracking based on the texture it has. Calls back onSuccess with the trackability or onError if 
 * it was not possible to do the operation. Do not call this method while tracking.
 */
- (void) checkImageQuality: (UIImage*) image withOnSuccess: (void(^)(float trackability)) onSuccess andOnError: (void (^)(NSError* error)) onError;

@end

/**
 * Protocol for tracking events on AR items added to the CraftARTracking class
 */
@protocol CraftARTrackingEventsProtocol <NSObject>

/**
 * Called when an added item starts being detected and tracked by the tracking.
 */
- (void) didStartTrackingItem: (CraftARItemAR*) item;

/**
 * Called when an added item stops being detected and tracked by the tracking.
 */
- (void) didStopTrackingItem: (CraftARItemAR*) item;

@optional 
/**
 * Called when the tracking timeout is over and no item has been detected.
 */
- (void) trackingTimeoutOver;

@end


