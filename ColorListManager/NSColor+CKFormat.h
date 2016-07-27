//
//  NSColor+CKFormat.h
//  ColorListManager
//
//  Created by LiJieming on 16/7/4.
//  Copyright © 2016年 CK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (CKFormat)

+ (NSColor *)ck_colorWithFormatSting:(NSString *)formatString;
- (NSString *)ck_formatString;

@end
