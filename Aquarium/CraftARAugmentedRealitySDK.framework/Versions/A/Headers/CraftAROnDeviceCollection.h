// This file is free software. You may use it under the MIT license, which is copied
// below and available at http://opensource.org/licenses/MIT
//
// Copyright (c) 2015 Catchoom Technologies S.L.
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

#import <Foundation/Foundation.h>
#import "CraftARError.h"
#import "CraftARItem.h"
#import "CraftARCollection.h"

/**
 * A collection represents the set of Items from a given
 * collection in the CraftAR database.
 */
@interface CraftAROnDeviceCollection : CraftARCollection

/**
 * Collection tokens
 */
@property (nonatomic, readonly) NSArray* tokens;

/**
 * Synchronizes a collection from the CraftAR Service.
 * @param doneBlock Executed with the synchronization is done. Passes the total number of items that needed to download resources and the number of items that failed in doing so.
 * @param errorBlock Executed with a CraftARError if the synchronization operation could not be executed.
 */
- (void) syncWithOnDone: (void (^)(CraftAROnDeviceCollection* collection, int itemDownloads, int downloadErrors))doneBlock andOnError: (void (^)(NSError* error)) errorBlock;

/**
 * Synchronizes a collection from the CraftAR Service.
 * @param progressBlock Executed with the progress completion (percentage).
 * @param doneBlock Executed with the synchronization is done. Passes the total number of items that needed to download resources and the number of items that failed in doing so.
 * @param errorBlock Executed with a CraftARError if the synchronization operation could not be executed.
 */
- (void) syncWithOnProgress: (void (^)(float progress)) progressBlock andOnDone: (void (^)(CraftAROnDeviceCollection* collection, int itemDownloads, int downloadErrors))doneBlock andOnError: (void (^)(NSError* error)) errorBlock;


/**
 * Synchronizes a collection from the CraftAR Service.
 * @param token specific token from this collection to use for synchronization.
 * @param doneBlock Executed with the synchronization is done. Passes the total number of items that needed to download resources and the number of items that failed in doing so.
 * @param errorBlock Executed with a CraftARError if the synchronization operation could not be executed.
 */
- (void) syncWithToken: (NSString*) token andOnDone: (void (^)(CraftAROnDeviceCollection* collection, int itemDownloads, int downloadErrors))doneBlock andOnError: (void (^)(NSError* error)) errorBlock;

/**
 * Synchronizes a collection from the CraftAR Service.
 * @param token specific token from this collection to use for synchronization.
 * @param progressBlock Executed with the progress completion (percentage).
 * @param doneBlock Executed with the synchronization is done. Passes the total number of items that needed to download resources and the number of items that failed in doing so.
 * @param errorBlock Executed with a CraftARError if the synchronization operation could not be executed.
 */
- (void) syncWithToken: (NSString*)token andOnProgress: (void (^)(float progress)) progressBlock andOnDone: (void (^)(CraftAROnDeviceCollection* collection, int itemDownloads, int downloadErrors))doneBlock andOnError: (void (^)(NSError* error)) errorBlock;

/**
 * Get a list of the uuids of the items in this collection
 * @return NSArray containing strings with the uuids of the items in this collection
 */
- (NSArray*) listItems;

/**
 * Get an item
 * @param itemUUID uuid from the CraftAR service of the item to get from this collection.
 * @return Returns a CraftARItem.
 */
- (CraftARItem*) getItem:(NSString *)itemUUID andError: (CraftARError**) error;

@end
