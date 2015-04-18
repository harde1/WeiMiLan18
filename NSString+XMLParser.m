//
//  NSString+XMLParser.m
//  WeiMiLan
//
//  Created by cong on 14-7-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "NSString+XMLParser.h"

@implementation NSString (XMLParser)
//xml拼接
//UTF-8
+(NSString *)startDocument:(NSString*)char_set{
    
    return [NSString stringWithFormat:@"<?xml version='1.0' encoding='%@' ?>",char_set];
}

+(NSString *)startTag:(NSString *)s{
    return [NSString stringWithFormat:@"<%@>",s];
}
+(NSString *)endTag:(NSString *)s{
    return [NSString stringWithFormat:@"</%@>",s];
}
@end
