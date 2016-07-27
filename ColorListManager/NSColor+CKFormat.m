//
//  NSColor+CKFormat.m
//  ColorListManager
//
//  Created by LiJieming on 16/7/4.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "NSColor+CKFormat.h"

@implementation NSColor (CKFormat)

+ (NSColor *)ck_colorWithFormatSting:(NSString *)formatString {
    NSString *colorRedString = [formatString substringWithRange:NSMakeRange(0, 2)];
    NSString *colorGreenString = [formatString substringWithRange:NSMakeRange(2, 2)];
    NSString *colorBlueString = [formatString substringWithRange:NSMakeRange(4, 2)];
    
    unsigned int colorRedValue = 0;
    unsigned int colorGreenValue = 0;
    unsigned int colorBlueValue = 0;
    
    [[NSScanner scannerWithString:colorRedString] scanHexInt:&colorRedValue];
    [[NSScanner scannerWithString:colorGreenString] scanHexInt:&colorGreenValue];
    [[NSScanner scannerWithString:colorBlueString] scanHexInt:&colorBlueValue];
    
    CGFloat colorRed = colorRedValue / 255.0;
    CGFloat colorGreen = colorGreenValue / 255.0;
    CGFloat colorBlue = colorBlueValue / 255.0;
    
    CGFloat colorComponents[4] = {colorRed, colorGreen, colorBlue, 1.0};
    return [NSColor colorWithColorSpace:[NSColorSpace genericRGBColorSpace] components:colorComponents count:4];
}

- (NSString *)ck_formatString {
    if ([self.colorSpaceName isEqualToString:@"NSCalibratedRGBColorSpace"]) {
        CGFloat colorRed = 0.0;
        CGFloat colorGreen = 0.0;
        CGFloat colorBlue = 0.0;
        CGFloat colorAlpha = 0.0;
        
        [self getRed:&colorRed green:&colorGreen blue:&colorBlue alpha:&colorAlpha];
        return [NSString stringWithFormat:@"%02x%02x%02x", (int)round(colorRed * 0xFF), (int)round(colorGreen * 0xFF), (int)round(colorBlue * 0xFF)];
    }
    else {
        return [NSString stringWithFormat:@"(%@)", self.colorSpaceName];
    }
}

@end
