//
//  LFCGzipUtility.h
//  WeiMiLan
//
//  Created by cong on 14-7-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zlib.h"
@interface LFCGzipUtility : NSObject
{
    
}

+(NSData*) gzipData:(NSData*)pUncompressedData;  //压缩
+(NSData*) ungzipData:(NSData *)compressedData;  //解压缩


@end
