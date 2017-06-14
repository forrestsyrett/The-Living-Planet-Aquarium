//
//  CraftARSDK_AR.h
//  CraftARSDK_AR
//
//  Created by Luis Martinell Andreu on 28/07/15.
//  Copyright (c) 2015 Luis Martinell Andreu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CraftARProtocols.h"
#import "CraftARTrackingContent.h"
#import "CraftARCamera.h"


@protocol CraftARSDKProtocol;
@protocol CraftARContentEventsProtocol;

/**
 * The CraftARSDK class is the main controller for managing the camera capture and
 * the visual search operations (Single shot and Finder Mode search)
 */
@interface CraftARSDK : NSObject

/// Delegate that will receive SDK's callbacks
@property (nonatomic, weak) id <CraftARSDKProtocol, CraftARContentEventsProtocol> delegate;

/**
 * Delegate that will receive messages to perform visual search based on the
 * SDK commands (singleShotSearch, startFinder, stopFinder).
 */
@property (nonatomic, weak) id <CameraSearchController> searchControllerDelegate;

/**
 * Get the shared instance of the CraftARSDK for image recognition.
 */
+ (CraftARSDK*) sharedCraftARSDK;

/**
 * Initialize a camera capture for a given UIView.
 * @param previewView View where the camera preview will be shown. The SDK will draw the capture preview.
 * Any other contents added to this view will be ignored.
 */
- (void) startCaptureWithView: (UIView*) previewView;

/**
 * Stop the camera video capture.
 * The camera will stop generating didReceivePreviewFrame events, all the camera resources will be released.
 * Call this method when closing the View controller that opens the camera (on viewWillDisappear is recommended).
 */
- (void) stopCapture;

/**
 * Stop the camera video capture.
 * The camera will stop generating didReceivePreviewFrame events, all the camera resources will be released.
 * Call this method when closing the View controller that opens the camera (on viewWillDisappear is recommended).
 * The completionBlock is called when the capture has stopped.
 */
- (void) stopCapture: (void (^)(void)) completionBlock;



/**
 * Takes a picture and performs a visual search using the searchControllerDelegate
 */
- (void) singleShotSearch;

/**
 * Starts a visual search session in Finder Mode passing the camera capture frames
 * to the searchControllerDelegate.
 */
- (void) startFinder;

/**
 * Starts a visual search session in Finder Mode passing the camera capture frames
 * to the searchControllerDelegate. The Finder stops after timeoutSeconds and the
 * [delegate didGetFinderTimeout] message is sent to the delegate.
 * Calling stopFinder cancels the notification.
 */
- (void) startFinderWithTimeout: (NSTimeInterval) timeoutSeconds;

/**
 * Stops the visual search session if started.
 */
- (void) stopFinder;

/**
 * Returns whether the SDK's Finder mode search is running
 */
- (BOOL) isFinding;

/**
 * Returns the CraftAR camera object that provides access to camera level operations.
 */
- (CraftARCamera*) getCamera;


/**
 Take a snapshot or the AR Scene
 @param successBlock will be called with the image captured.
 */
- (void) takeSceneCaptureWithOnSuccess: (void(^)(UIImage* capture)) successBlock;


@end



@protocol CraftARSDKProtocol <NSObject>

/**
 * Sent by the SDK after the video capture and preview have started.
 */
- (void) didStartCapture;

@optional
/**
 * Sent by the SDK when the Finder timeout is received.
 */
- (void) didGetFinderTimeout;

@end


@protocol CraftARContentEventsProtocol <NSObject>

@optional
- (void) didGetTouchEvent: (CraftARContentTouchEvent) event forContent: (CraftARTrackingContent*)content;

@end
