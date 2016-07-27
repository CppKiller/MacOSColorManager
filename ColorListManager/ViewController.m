//
//  ViewController.m
//  ColorListManager
//
//  Created by LiJieming on 16/7/4.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "ViewController.h"
#import "NSColorList+CKFormat.h"

@interface ViewController () <NSComboBoxDataSource, NSComboBoxDelegate>

@property (strong) NSMutableArray<NSColorList *> *colorListArray;

@property (weak) IBOutlet NSComboBox *comboBox;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorListArray = [[NSColorList availableColorLists] mutableCopy];
    [self.comboBox reloadData];
    self.textView.font = [NSFont fontWithName:@"Menlo" size:15.0];
}

- (void)viewDidDisappear {
    [super viewDidDisappear];
    
    [[NSApplication sharedApplication] terminate:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)showColorList:(NSColorList *)colorList {
    self.textView.string = [colorList ck_formatString];
}

- (void)saveColorList:(NSColorList *)colorList {
    NSString *filePath = colorList.filePath;
    if (filePath == nil) {
        NSString * const userHome = NSHomeDirectoryForUser(NSUserName());
        filePath = [NSString stringWithFormat:@"%@/Library/Colors/%@.clr", userHome, colorList.listName];
    }
    
    [colorList writeToFile:nil];
    self.colorListArray = [[NSColorList availableColorLists] mutableCopy];
}

- (IBAction)onSaveButtonTouched:(id)sender {
    NSColorList *newColorList = [NSColorList ck_colorListWithName:self.colorListArray[self.comboBox.indexOfSelectedItem].listName formatSting:self.textView.string];
    
    [self saveColorList:newColorList];
    self.colorListArray[self.comboBox.indexOfSelectedItem] = newColorList;
}

- (IBAction)onFolderButtonTouched:(id)sender {
    NSString * const userHome = NSHomeDirectoryForUser(NSUserName());
    NSString * const filePath = [NSString stringWithFormat:@"%@/Library/Colors/", userHome];
    [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:filePath];
}

- (IBAction)onExportCategoryButtonTouched:(id)sender {
    NSColorList *currentColorList = self.colorListArray[self.comboBox.indexOfSelectedItem];
    
    if (currentColorList != nil) {
        NSString * const userHome = NSHomeDirectoryForUser(NSUserName());
        NSString * const filePath = [NSString stringWithFormat:@"%@/Library/Colors/", userHome];
        NSString * const headerFilePath = [NSString stringWithFormat:@"%@UIColor+%@.h", filePath, currentColorList.name];
        NSString * const sourceFilePath = [NSString stringWithFormat:@"%@UIColor+%@.m", filePath, currentColorList.name];
        
        [[currentColorList ck_formatCategoryHeader] writeToFile:headerFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [[currentColorList ck_formatCategorySource] writeToFile:sourceFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

#pragma mark - NSComboBoxDataSource
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    return self.colorListArray.count;
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
    return self.colorListArray[index].listName;
}

#pragma mark - NSComboBoxDelegate
- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    [self showColorList:self.colorListArray[self.comboBox.indexOfSelectedItem]];
}

@end
