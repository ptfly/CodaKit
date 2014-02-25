//
//  DebugPrintg.m
//  CodaKit
//
//  Created by Plamen Todorov on 21.02.14.
//  Copyright (c) 2014 г. Plamen Todorov. All rights reserved.
//

#import "DebugPrint.h"

@implementation DebugPrint
@synthesize field;

-(id)init
{
    self = [super initWithWindowNibName:@"DebugPrint"];
    
    if(self){
        
    }
    
    return self;
}

-(void)print:(NSString *)info
{
    if(![self.window isVisible]){
        [self showWindow:self];
    }
    
    [self.field setTextColor:[NSColor whiteColor]];
    [self.field setBackgroundColor:[NSColor clearColor]];
    [self.field setString:info];
}

@end

@interface NSMenu (PopUpRegularMenuAdditions)
+ (void)popUpMenu:(NSMenu *)menu forView:(NSView *)view pullsDown:(BOOL)pullsDown;
@end

@implementation NSMenu (PopUpRegularMenuAdditions)
+ (void)popUpMenu:(NSMenu *)menu forView:(NSView *)view pullsDown:(BOOL)pullsDown {
    NSMenu *popMenu = [menu copy];
    NSRect frame = [view frame];
    frame.origin.x = 0.0;
    frame.origin.y = 0.0;
    
    if (pullsDown) [popMenu insertItemWithTitle:@"" action:NULL keyEquivalent:@"" atIndex:0];
    
    NSPopUpButtonCell *popUpButtonCell = [[NSPopUpButtonCell alloc] initTextCell:@"" pullsDown:pullsDown];
    [popUpButtonCell setMenu:popMenu];
    if (!pullsDown) [popUpButtonCell selectItem:nil];
    [popUpButtonCell performClickWithFrame:frame inView:view];
}
@end