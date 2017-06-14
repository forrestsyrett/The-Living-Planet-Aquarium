//
//  CraftARitemFactoryAR.h
//  CraftARSDK_AR
//
//  Created by Luis Martinell Andreu on 27/08/15.
//  Copyright (c) 2015 Luis Martinell Andreu. All rights reserved.
//

#import "CraftARItemFactory.h"

#import "CraftARItemAR.h"

/**
 * This class is used by the SDK to create items and AR items.
 */
@interface CraftARitemFactoryAR : CraftARItemFactory

/**
 * Set the AR Item class for the factory to create items of this class.
 * Useful for customizing items.
 * @param itemClass subclass of CarftARItemAR
 */
- (void) setARItemClass: (Class) itemClass;

@end
