//
//  CodaKit.m
//  CodaKit
//
//  Created by Plamen Todorov on 07.10.13.
//  Copyright (c) 2013 г. Plamen Todorov. All rights reserved.
//

#import "CodaKit.h"

@interface CodaKit ()
-(id)initWithController:(CodaPlugInsController *)inController;
@end

@class CodaPlugInsController;
@implementation CodaKit

//2.0 and lower
-(id)initWithPlugInController:(CodaPlugInsController *)aController bundle:(NSBundle*)aBundle
{
    return [self initWithController:aController];
}

//2.0.1 and higher
-(id)initWithPlugInController:(CodaPlugInsController *)aController plugInBundle:(NSObject <CodaPlugInBundle> *)plugInBundle
{
    return [self initWithController:aController];
}

-(id)initWithController:(CodaPlugInsController *)inController
{
	if((self = [super init]) != nil)
	{
		controller = inController;
        
		[controller registerActionWithTitle:@"Capitalize Selection" target:self selector:@selector(toUpperCase:)];
		[controller registerActionWithTitle:@"Uncapitalize Selection" target:self selector:@selector(toLowerCase:)];
        
        [controller registerActionWithTitle:@"Delete Selection / Line" target:self selector:@selector(deleteSelection:)];
        [controller registerActionWithTitle:@"Duplicate Selection / Line" target:self selector:@selector(duplicateSelection:)];
        
        [controller registerActionWithTitle:@"—" target:self selector:nil];
        
        NSString *groupName = @"Wrap Selection With...";
        [controller registerActionWithTitle:@"h1" underSubmenuWithTitle:groupName target:self selector:@selector(wrapWithTag:) representedObject:@"h1" keyEquivalent:@"^1" pluginName:nil];
        [controller registerActionWithTitle:@"h2" underSubmenuWithTitle:groupName target:self selector:@selector(wrapWithTag:) representedObject:@"h2" keyEquivalent:@"^2" pluginName:nil];
        [controller registerActionWithTitle:@"h3" underSubmenuWithTitle:groupName target:self selector:@selector(wrapWithTag:) representedObject:@"h3" keyEquivalent:@"^3" pluginName:nil];
        [controller registerActionWithTitle:@"h4" underSubmenuWithTitle:groupName target:self selector:@selector(wrapWithTag:) representedObject:@"h4" keyEquivalent:@"^4" pluginName:nil];
        [controller registerActionWithTitle:@"h5" underSubmenuWithTitle:groupName target:self selector:@selector(wrapWithTag:) representedObject:@"h5" keyEquivalent:@"^5" pluginName:nil];
        [controller registerActionWithTitle:@"h6" underSubmenuWithTitle:groupName target:self selector:@selector(wrapWithTag:) representedObject:@"h5" keyEquivalent:@"^6" pluginName:nil];
        
        [controller registerActionWithTitle:@"p" underSubmenuWithTitle:groupName target:self selector:@selector(wrapWithTag:) representedObject:@"p" keyEquivalent:@"^p" pluginName:nil];
        [controller registerActionWithTitle:@"em" underSubmenuWithTitle:groupName target:self selector:@selector(wrapWithTag:) representedObject:@"em" keyEquivalent:@"^e" pluginName:nil];
        [controller registerActionWithTitle:@"div" underSubmenuWithTitle:groupName target:self selector:@selector(wrapWithTag:) representedObject:@"div" keyEquivalent:@"^d" pluginName:nil];
        [controller registerActionWithTitle:@"span" underSubmenuWithTitle:groupName target:self selector:@selector(wrapWithTag:) representedObject:@"span" keyEquivalent:@"^s" pluginName:nil];
        [controller registerActionWithTitle:@"strong" underSubmenuWithTitle:groupName target:self selector:@selector(wrapWithTag:) representedObject:@"strong" keyEquivalent:@"^b" pluginName:nil];
	}
    
	return self;
}

-(NSString *)name
{
	return @"CodaKit";
}

-(void)toUpperCase:(id)sender
{
	CodaTextView *tv = [controller focusedTextView:self];
    
	if(tv)
	{
		NSString *selectedText = [tv selectedText];
		
		if(selectedText)
		{
			NSRange savedRange = [tv selectedRange];
			[tv insertText:[selectedText uppercaseString]];
			[tv setSelectedRange:savedRange];
		}
	}
}

-(void)toLowerCase:(id)sender
{
	CodaTextView *tv = [controller focusedTextView:self];
	
    if(tv)
	{
		NSString *selectedText = [tv selectedText];
		
		if(selectedText)
		{
			NSRange savedRange = [tv selectedRange];
			[tv insertText:[selectedText lowercaseString]];
			[tv setSelectedRange:savedRange];
		}
	}
}

-(void)wrapWithTag:(id)sender
{
    CodaTextView *tv = [controller focusedTextView:self];
	
    if(tv)
	{
        NSString *tagName = [sender representedObject];
		NSString *selectedText = [tv selectedText];
		
		if(selectedText){
			[tv insertText:[NSString stringWithFormat:@"<%@>%@</%@>", tagName, selectedText, tagName]];
		}
	}
}

-(void)deleteSelection:(id)sender
{
    CodaTextView *tv = [controller focusedTextView:self];
	
    if(tv)
	{
		NSString *selectedText = [tv selectedText];
		
		if(selectedText && [selectedText isNotEqualTo:@""]){
            [tv insertText:@""];
		}
        else {
            long start, end;
            NSRange range = [tv rangeOfCurrentLine];
            
            if([tv currentLineNumber] == 1){
                start = range.location;
                end = range.length;
            }
            else {
                start = range.location - 1;
                end = range.length+1;
            }
            
            [tv setSelectedRange:NSMakeRange(start, end)];
            [tv deleteSelection];
        }
	}
}

-(void)duplicateSelection:(id)sender
{
    CodaTextView *tv = [controller focusedTextView:self];
	
    if(tv)
	{
		NSString *selectedText = [tv selectedText];
        
		if(selectedText && [selectedText isNotEqualTo:@""])
        {
            [tv insertText:[NSString stringWithFormat:@"%@%@", selectedText, selectedText]];
            [tv setSelectedRange:NSMakeRange([tv selectedRange].location, ([tv selectedRange].length-1)*2)];
		}
        else {
            NSString *lineContent = [tv stringWithRange:[tv rangeOfCurrentLine]];
            
            [tv setSelectedRange:NSMakeRange(tv.rangeOfCurrentLine.location+tv.rangeOfCurrentLine.length, 0)];
            [tv insertText:[NSString stringWithFormat:@"\n%@", lineContent]];
        }
	}
}

@end
