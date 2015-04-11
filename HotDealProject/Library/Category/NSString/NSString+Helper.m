//
//  NSString+Helper.m
//  PromptuApp
//
//  Created by Brandon Millman on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Helper.h"
#import "NSData+Helper.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Helper)

- (NSString*)substringFrom:(NSInteger)a to:(NSInteger)b {
	NSRange r;
	r.location = a;
	r.length = b - a;
	return [self substringWithRange:r];
}
-(NSString *)normalizeVietnameseString:(NSString *)str {
    NSMutableString *originStr = [NSMutableString stringWithString:str];
    CFStringNormalize((CFMutableStringRef)originStr, kCFStringNormalizationFormD);
    
    CFStringFold((CFMutableStringRef)originStr, kCFCompareDiacriticInsensitive, NULL);
    
    NSString *finalString1 = [originStr stringByReplacingOccurrencesOfString:@"u0111"withString:@"d"];
     finalString1 = [originStr stringByReplacingOccurrencesOfString:@"đ"withString:@"d"];
    
    NSString *finalString2 = [finalString1 stringByReplacingOccurrencesOfString:@"u0110"withString:@"d"];
    finalString2 = [finalString1 stringByReplacingOccurrencesOfString:@"Đ"withString:@"d"];
    
    return finalString2;
}
-(NSString *)convertPercentage:(NSString *)str {
    if ([str containsString:@"%"]) {
        str = [str stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
    }
    return str;
}
- (NSInteger)indexOf:(NSString*)substring from:(NSInteger)starts {
	NSRange r;
	r.location = starts;
	r.length = [self length] - r.location;

	NSRange index = [self rangeOfString:substring options:NSLiteralSearch range:r];
	if (index.location == NSNotFound) {
		return -1;
	}
	return index.location + index.length;
}

- (NSString*)trim {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)startsWith:(NSString*)s {
	if([self length] < [s length]) return NO;
	return [s isEqualToString:[self substringFrom:0 to:[s length]]];
}

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString *)urlEncode
{
	NSString* encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
										  NULL,
										  (CFStringRef) self,
										  NULL,
										  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
										  kCFStringEncodingUTF8 ));
	return encodedString ;
}

- (NSString *)sha1 {
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
	CC_SHA1(data.bytes, data.length, digest);
	NSData *d = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
	return [d hexString];
}

- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}


@end
