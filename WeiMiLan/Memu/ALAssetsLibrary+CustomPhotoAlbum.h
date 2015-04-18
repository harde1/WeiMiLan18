//
//  ALAssetsLibrary+CustomPhotoAlbum.h
//  WeiMiLan
//
//  Created by cong on 14-7-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
typedef void(^SaveImageCompletion)(NSError* error);
@interface ALAssetsLibrary (CustomPhotoAlbum)
-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
@end
