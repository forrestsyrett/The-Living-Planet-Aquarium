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

/**
 Load a 3d model into the scene on top of the tracked reference.
 @note 3d Models are loaded using Assimp Model Loader, for supported
 formats see http://assimp.sourceforge.net/main_features_formats.html
 @note model animations are supported.
 */
@interface CraftARTrackingContent3dModel : CraftARTrackingContent

/**
 Load model from the main bundle.
 @param modelName Name of the model to load.
 @param type Type of the model.
 */
- (id) initWithModelNamed: (NSString*) modelName ofType: (NSString*) type;

/**
 Load model from the main bundle using the specified textures.
 @param modelName Name of the model to load.
 @param type Type of the model.
 @param textures dictionary containing NSStrings keys and values for the models textures.
 Keys identify the texture inside the model file (name or path). Values specify the local or
 remote url where the actual texture image has to be loaded from.
 */
- (id) initWithModelNamed: (NSString*) modelName ofType: (NSString*) type andTextures: (NSDictionary*) textures;

/**
 Load model from a url using the specified textures.
 @param modelURL URL of the model to load.
 @param textures dictionary containing NSStrings keys and values for the models textures.
 Keys identify the texture inside the model file (name or path). Values specify the local or
 remote url where the actual texture image has to be loaded from.
 */
- (id) initWithModelFromUrl: (NSURL*) modelURL andTextures: (NSDictionary *) textures;

/**
 Cancel model download to speed up its removal
 */
- (void) cancelModeLoad;

@end
