//
//  NSColorList+CKFormat.m
//  ColorListManager
//
//  Created by LiJieming on 16/7/4.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "NSColorList+CKFormat.h"
#import "NSColor+CKFormat.h"

@implementation NSColorList (CKFormat)

- (void)setListName:(NSString *)listName {
    self->_name = [listName copy];
}

- (NSString *)listName {
    return _name;
}

- (NSString *)filePath {
    return _fileName;
}

+ (NSColorList *)ck_colorListWithName:(NSString *)name formatSting:(NSString *)formatString {
    NSColorList *colorList = [[NSColorList alloc]initWithName:name];
    
    NSArray<NSString *> *colorValues = [formatString componentsSeparatedByString:@"\n"];
    for (NSString *colorValue in colorValues) {
        NSArray<NSString *> *colorComponents = [colorValue componentsSeparatedByString:@":"];
        if (colorComponents.count >= 2) {
            NSString *key = [colorComponents[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSColor *color = [NSColor ck_colorWithFormatSting:[colorComponents[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            
            [colorList setColor:color forKey:key];
        }
    }
    
    return colorList;
}

- (NSString *)ck_formatString {
    NSMutableArray<NSString *> *colorListStrings = [NSMutableArray array];
    
    NSArray<NSString *> *colorListKeys = self.allKeys;
    for (NSString *key in colorListKeys) {
        NSColor *color = [self colorWithKey:key];
        
        NSString *formatString = [NSString stringWithFormat:@"%@ :%@", [color ck_formatString], key];
        [colorListStrings addObject:formatString];
    }
    
    return [colorListStrings componentsJoinedByString:@"\r\n"];
}

- (NSString *)ck_formatCategoryHeader {
    NSMutableArray<NSString *> *colorFunctionDeclartions = [NSMutableArray array];
    
    NSArray<NSString *> *colorListKeys = self.allKeys;
    for (NSString *key in colorListKeys) {
        NSString *formatString = [NSString stringWithFormat:@"+ (UIColor *)%@;", [self ck_formatFuntionNameWithName:key]];
        [colorFunctionDeclartions addObject:formatString];
    }
    
    NSString *headerContent = [NSString stringWithFormat:@"@interface UIColor (%@)\n\n%@\n\n@end", self.name, [colorFunctionDeclartions componentsJoinedByString:@"\n\n"]];
    
    return headerContent;
}

- (NSString *)ck_formatCategorySource {
    NSMutableArray<NSString *> *colorFunctionImplementations = [NSMutableArray array];
    
    NSArray<NSString *> *colorListKeys = self.allKeys;
    for (NSString *key in colorListKeys) {
        NSColor *color = [self colorWithKey:key];
        NSString *formatString = [NSString stringWithFormat:@"+ (UIColor *)%@ {\n\treturn [UIColor colorWithHex:0x%@];\n}", [self ck_formatFuntionNameWithName:key], [color ck_formatString]];
        [colorFunctionImplementations addObject:formatString];
    }
    
    NSString *sourceContent = [NSString stringWithFormat:@"#import \"UIColor+BR.h\"\n\n@implementation UIColor (%@)\n\n%@\n\n@end", self.name, [colorFunctionImplementations componentsJoinedByString:@"\n\n"]];
    
    return sourceContent;
}

- (NSString *)ck_formatFuntionNameWithName:(NSString *)name {
    if (name.length > 0) {
        return [NSString stringWithFormat:@"%@%@", [[name substringToIndex:1] lowercaseString], [name substringFromIndex:1]];
    }
    return @"";
}

@end
