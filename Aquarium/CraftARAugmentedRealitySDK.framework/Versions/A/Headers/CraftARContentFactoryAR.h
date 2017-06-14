//
//  CraftARContentFactory.h
//  CraftARSDK_AR
//
//  Created by Luis Martinell Andreu on 08/09/15.
//  Copyright (c) 2015 Luis Martinell Andreu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CraftARTRackingContent.h"
#import "CraftARContentFactory.h"

#define SCENE_DESC_KEY_TYPE @"type"

#define SCENE_DESC_TYPE_IMAGE @"image"
#define SCENE_DESC_TYPE_VIDEO @"video"
#define SCENE_DESC_TYPE_3DMODEL @"3dmodel"
#define SCENE_DESC_TYPE_IMAGE_BUTTON @"image_button"

/**
 * Factory to create CraftAR contents from the scene description of an AR item.
 * Extend this class to customize AR content creation and set the factory using the superclass.
 */
@interface CraftARContentFactoryAR : CraftARContentFactory

@end
