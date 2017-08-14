//
//  NSString+base64.m
//  BootyCall
//
//  Created by rimi on 16/8/20.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "NSString+base64.h"

@implementation NSString (base64)

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


@end
