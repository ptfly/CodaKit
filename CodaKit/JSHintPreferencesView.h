//
//  JSHintPreferencesView.h
//  CodaKit
//
//  Created by Plamen Todorov on 09.05.14.
//  Copyright (c) 2014 г. Plamen Todorov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JSHintPreferencesView : NSView <NSTextFieldDelegate>
{
    NSMutableDictionary *jsHintConfig;
    NSArray *settings;
    
    IBOutlet NSButton *docs;
}

-(IBAction)reset:(id)sender;
-(IBAction)gotoLink:(id)sender;

@end
