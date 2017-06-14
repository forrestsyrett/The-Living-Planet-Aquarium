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

#import "CraftARTRackingContent.h"
#import <UIKit/UIKit.h>

/**
 Provided content that allows to draw an image on top of the reference
 */
@interface CraftARTrackingContentImage : CraftARTrackingContent

/**
 Initialize an image content using an image from the main bundle.
 @param imageName Name of the image to load.
 @param type Extension of the image to load.
 */
- (id) initWithImageNamed: (NSString*) imageName ofType: (NSString*) type;

/**
 Initialize a image content from a URL.
 @param imageURL URL of the image content to load.
 @note Content will not be ready until the image has finished downloading.
 */
- (id) initWithImageFromURL: (NSURL*) imageUrl;

/**
 Initialize an image content using an image from the main bundle, colorizes the image.
 @param imageName Name of the image to load.
 @param type Extension of the image to load.
 @param color Image pixels will be multiplied by this color.
 */
- (id) initWithImageNamed: (NSString*) imageName ofType: (NSString*) type withColor: (UIColor*) color;

// Initialize this content using an image from an url (content will not be ready
// until the image has finished downloading.
/**
 Initialize a image content from a URL, colorizes the image.
 @param imageURL URL of the image content to load.
 @param color Image pixels will be multiplied by this color.
 @note Content will not be ready until the image has finished downloading.
 */
- (id) initWithImageFromURL: (NSURL*) imageUrl withColor: (UIColor*) color;

@end
