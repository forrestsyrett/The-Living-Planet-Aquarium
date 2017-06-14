// This file is free software. You may use it under the MIT license, which is copied
// below and available at http://opensource.org/licenses/MIT
//
// Copyright (c) 2014 Catchoom Technologies S.L.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

#import "CraftARTRackingContentImage.h"

/**
 Interactive content. A button that can be pressed, an action can be associated to it.
 @note This content must be extended to add some behaviour.
 */
@interface CraftARTrackingContentImageButton : CraftARTrackingContent

/// Image content to be drawn when the content is not pressed
@property (nonatomic, readwrite) CraftARTrackingContentImage *imageNormal;
/// Image content to be drawn when the content is pressed
@property (nonatomic, readwrite) CraftARTrackingContentImage *imagePressed;
/// Action to perform (open url) when the content is clicked
@property (nonatomic, readwrite) NSURL* actionURL;
/// Perform the default action (open url) when clicked, NO by default
/**
 @note this option is set to true automatically when the button is loaded from
 a scene description item.
 */
@property (nonatomic, readwrite) Boolean performDefaultAction;

/**
 Initialize content with one image from the main bundle.
 @param imageName Name of the image to use as imageNormal
 @param imageType Type of the image to load
 @param actionURL URL of the action to perform on clicked.
 @note When the button is pressed the image will be colorized to give feedback.
 */
- (id) initWithImage: (NSString*) imageName ofType: (NSString*) imageType andActionURL: (NSURL*) actionURL;

/**
 Initialize content with one image from a URL.
 @param imageURL URL of the image to use as imageNormal
 @param actionURL URL of the action to perform on clicked.
 @note When the button is pressed the image will be colorized to give feedback.
 */
- (id) initWithImageURL: (NSURL*) imageURL andActionURL: (NSURL*) actionURL;


/**
 Initialize content with two images from the main bundle.
 @param imageName Name of the image to use as imageNormal
 @param imageType Type of the image to load
 @param pressedImageName Name of the image to use as imagePressed
 @param pressedImageType Type of the image to load
 @param actionURL URL of the action to perform on clicked.
 */
- (id) initWithImage: (NSString*) imageName ofType: (NSString*) imageType andPressedImage: (NSString *)pressedImageName ofType: (NSString*) pressedImageType andActionURL: (NSURL*) actionURL;

/**
 Initialize content with two images URLs.
 @param imageURL URL of the image to use as imageNormal
 @param pressedImageURL URL of the image to use as imagePressed
 @param actionURL URL of the action to perform on clicked.
 */
- (id) initWithImageURL: (NSURL*) imageURL andPressedImageURL: (NSURL*) pressedImageURL andActionURL: (NSURL*) actionURL;

@end
