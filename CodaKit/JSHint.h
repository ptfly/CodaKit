//
//  JSHint.h
//  CodaKit
//
//  Created by Plamen Todorov on 11.05.14.
//  Copyright (c) 2014 г. Plamen Todorov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JSHint;

@protocol JSHintDelegate <NSObject>
    -(void)goToLine:(NSDictionary *)data;
@end

@interface JSHint : NSWindowController <NSTextViewDelegate>
    @property (nonatomic, retain) NSString *filePathToValidate;
    @property (nonatomic, retain) IBOutlet NSTextField *infoLabel;
    @property (nonatomic, retain) IBOutlet NSScrollView *scrollView;
@property (nonatomic, retain) IBOutlet NSView *containerView;
    @property (nonatomic, retain) IBOutlet NSBox *boxTemplate;
    @property (nonatomic, weak) id <JSHintDelegate> delegate;

    -(id)initWithFilePath:(NSString *)filePath;
    -(void)showResults;
@end

@interface JSHintBtn : NSButton
    @property (nonatomic, retain) NSDictionary *data;
@end