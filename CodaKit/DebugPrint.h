//
//  DebugPrint.h
//  CodaKit
//
//  Created by Plamen Todorov on 21.02.14.
//  Copyright (c) 2014 г. Plamen Todorov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DebugPrint : NSWindowController <NSWindowDelegate>

@property (nonatomic, retain) IBOutlet NSTextView *field;

-(void)print:(NSString *)info;
@end
