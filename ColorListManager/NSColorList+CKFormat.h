//
//  NSColorList+CKFormat.h
//  ColorListManager
//
//  Created by LiJieming on 16/7/4.
//  Copyright © 2016年 CK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColorList (CKFormat)

@property (nonatomic, copy) NSString *listName;
@property (nonatomic, readonly) NSString *filePath;

+ (NSColorList *)ck_colorListWithName:(NSString *)name formatSting:(NSString *)formatString;
- (NSString *)ck_formatString;

@end
