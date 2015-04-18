//
//  NSString+unicodeShow.m
//  KidsEduCircle
//
//  Created by cong on 14-6-19.
//  Copyright (c) 2014年 Zhang Kai Yu. All rights reserved.
//

#import "NSString+unicodeShow.h"

@implementation NSString (unicodeShow)
//unicode编码以\u开头
+ (NSString *)replaceUnicode:(NSString *)unicodeStr{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    
    
    
    NSString *tempStr3;
    if (tempStr2) {
        tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    }
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}
@end
