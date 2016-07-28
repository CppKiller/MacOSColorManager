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
    if (self.comboBox.indexOfSelectedItem < 0 || self.comboBox.indexOfSelectedItem >= self.colorListArray.count) {
        return;
    }
    
    NSColorList *currentColorList = self.colorListArray[self.comboBox.indexOfSelectedItem];
    
    if (currentColorList != nil) {
        NSString * const userHome = NSHomeDirectoryForUser(NSUserName());
        NSString * const filePath = [NSString stringWithFormat:@"%@/Library/Colors/", userHome];
        
        NSSavePanel *saveDlg = [[NSSavePanel alloc]init];
        saveDlg.title = @"导出Category";
        saveDlg.message = @"导出UIColor的Category";
        saveDlg.allowedFileTypes = nil;
        saveDlg.directoryURL = [NSURL URLWithString:filePath];
        saveDlg.nameFieldStringValue = [NSString stringWithFormat:@"UIColor+%@", currentColorList.name];
        [saveDlg beginWithCompletionHandler: ^(NSInteger result){
            if(result==NSFileHandlingPanelOKButton){
                NSURL *url =[saveDlg URL];
                [self saveColorList:currentColorList toCategoryFile:url];
            }
        }];
        
    }
}

- (void)saveColorList:(NSColorList *)colorList toCategoryFile:(NSURL *)fileUrl {
    NSString *extension = fileUrl.pathExtension;
    NSString *pathString = fileUrl.absoluteString;
    NSString *extensionString = extension.length > 0 ? [NSString stringWithFormat:@".%@", extension] : @"";
    NSString *pathWithoutExtension = [pathString substringToIndex:pathString.length - extensionString.length];
    
    NSURL * const headerFilePathURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@.h", pathWithoutExtension]];
    NSURL * const sourceFilePathURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@.m", pathWithoutExtension]];
    
    NSError *error;
    [[colorList ck_formatCategoryHeader] writeToURL:headerFilePathURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [[colorList ck_formatCategorySource] writeToURL:sourceFilePathURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if(error){
        NSLog(@"save file error %@",error);
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
