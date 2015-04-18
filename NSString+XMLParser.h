//
//  NSString+XMLParser.h
//  WeiMiLan
//
//  Created by cong on 14-7-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XMLParser)
//xml拼接
//UTF-8
+(NSString *)startDocument:(NSString*)char_set;

+(NSString *)startTag:(NSString *)s;

+(NSString *)endTag:(NSString *)s;


@end
