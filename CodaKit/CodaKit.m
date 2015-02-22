//
//  CodaKit.m
//  CodaKit
//
//  Created by Plamen Todorov on 07.10.13.
//  Copyright (c) 2013 г. Plamen Todorov. All rights reserved.
//

#import "CodaKit.h"
#import "CKPreferences.h"
#import "HTMLBeautifier.h"
#import "XMLReader.h"
#import "RegExCategories.h"

@interface CodaKit ()
-(id)initWithController:(CodaPlugInsController *)inController;
@end

@class CodaPlugInsController;
@implementation CodaKit

@synthesize prefController, JSHintPanel;

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
        
        [controller registerActionWithTitle:@"JSHint" target:self selector:@selector(runJSHint:)];
        [controller registerActionWithTitle:@"HTML Beautify" underSubmenuWithTitle:nil target:self selector:@selector(runHTMLBeautifier:) representedObject:nil keyEquivalent:@"^~@b" pluginName:nil];
        
        [controller registerActionWithTitle:@"Line Break" target:self selector:@selector(newLine:)];
        [controller registerActionWithTitle:@"Flip Quotes" target:self selector:@selector(quoteFixer:)];
        
		[controller registerActionWithTitle:@"Capitalize Selection" target:self selector:@selector(toUpperCase:)];
		[controller registerActionWithTitle:@"Uncapitalize Selection" target:self selector:@selector(toLowerCase:)];
        
        [controller registerActionWithTitle:@"Delete Selection / Line" target:self selector:@selector(deleteSelection:)];
        [controller registerActionWithTitle:@"Duplicate Selection / Line" target:self selector:@selector(duplicateSelection:)];
        
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
        
        [controller registerActionWithTitle:@"—" target:self selector:nil];
        [controller registerActionWithTitle:@"Preferences" underSubmenuWithTitle:nil target:self selector:@selector(preferences:) representedObject:nil keyEquivalent:@"^~@p" pluginName:nil];
	}
    
	return self;
}

-(NSString *)name
{
	return @"CodaKit";
}

-(void)textViewWillSave:(CodaTextView*)textView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self compileDustJS:nil];
    });
}

-(void)compileDustJS:(id)sender
{
    CodaTextView *tv = [controller focusedTextView:self];
    
	if(tv)
	{
        NSString *confFile = [NSString stringWithFormat:@"%@/%@", [tv siteLocalPath], @"dust.conf"];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:confFile isDirectory:NO])
        {
            NSData *confData = [NSData dataWithContentsOfFile:confFile];
            NSDictionary *config = [NSJSONSerialization JSONObjectWithData:confData options:0 error:nil];
            
            // Compile files with specific extensions only, defined in the dust.conf file
            if([[[[tv path] pathExtension] lowercaseString] isEqualToString:[config objectForKey:@"compileFilesWithExtension"]] == NO){
                return;
            }
            
            NSString *fileName;
            NSString *compilePath;
            
            NSString *compileDir = [NSString stringWithFormat:@"%@%@", [tv siteLocalPath], [config objectForKey:@"compileDir"]];
            NSString *templateDir = [NSString stringWithFormat:@"%@%@", [tv siteLocalPath], [config objectForKey:@"templateDir"]];
            
            if([[config objectForKey:@"preserveDirectoryStructure"] boolValue] == YES)
            {
                fileName = [[[tv path] stringByReplacingOccurrencesOfString:templateDir withString:@""] stringByDeletingPathExtension];
                
                NSArray *dirs = [[fileName stringByDeletingLastPathComponent] componentsSeparatedByString:@"/"];
                NSString *path = compileDir;
                
                for(uint i=0; i<dirs.count; i++)
                {
                    path = [path stringByAppendingFormat:@"/%@", [dirs objectAtIndex:i]];
                    
                    BOOL isDir = YES;
                    if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] == NO){
                        NSError *err;
                        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
                        if(err){
                            [self showError:[err localizedDescription] andTitle:@"NSFileManager failed to create directory!"];
                        }
                    }
                }
            }
            else {
                fileName = [[[tv path] lastPathComponent] stringByDeletingPathExtension];
            }
            
            compilePath = [NSString stringWithFormat:@"%@%@.js", compileDir, fileName];
            fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            
            // Run compiler
            NSPipe *pipe = [NSPipe pipe];
            NSTask *task = [[NSTask alloc] init];
            NSArray *args = @[@"-c", [NSString stringWithFormat:@"/usr/bin/dustc --name='%@' '%@' '%@'", fileName, [tv path], compilePath]];
            
            [task setLaunchPath: @"/bin/bash"];
            [task setArguments:args];
            [task setStandardOutput:pipe];
            [task setStandardError:pipe];
            
            NSFileHandle *file = [pipe fileHandleForReading];
            [task launch];

            NSString *response = [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
            
            if([response isEqualToString:@""] == NO){
                [self showError:[NSString stringWithFormat:@"%@\n\n==== RESPONSE ====\n%@", [args lastObject], response] andTitle:@"DustJS Compiler"];
            }
        }
    }
}

-(void)preferences:(id)sender
{
    if(!prefController){
        self.prefController = [[CKPreferences alloc] initWithWindowNibName:@"Preferences"];
    }
    
    [prefController.window makeKeyAndOrderFront:nil];
}

-(void)goToLine:(NSDictionary *)data
{
    CodaTextView *tv = [controller focusedTextView:self];
    
    if(tv){
        [tv goToLine:[[data objectForKey:@"line"] intValue] column:[[data objectForKey:@"char"] intValue]];
    }
}

-(void)runJSHint:(id)sender
{
    CodaTextView *tv = [controller focusedTextView:self];
    
	if(tv)
	{
        if(JSHintPanel){
            [JSHintPanel setDelegate:nil];
            [JSHintPanel close];
            self.JSHintPanel = nil;
        }
        
        JSHintPanel = [[JSHint alloc] initWithFilePath:[tv path]];
        [JSHintPanel setDelegate:self];
        [JSHintPanel showResults];
    }
}

-(void)runHTMLBeautifier:(id)sender
{
    CodaTextView *tv = [controller focusedTextView:self];
    
	if(tv)
	{
        BOOL selection = YES;
        NSString *code = [tv selectedText];
		
		if(!code || [code isEqualToString:@""]){
			code = [tv string];
            selection = NO;
		}
        
        HTMLBeautifier *parser = [[HTMLBeautifier alloc] initWithString:code];
        
        NSString *response = [parser beautify];
        
        if([response isEqualToString:@""]){
            return;
        }
        else {
            // check for error
            if([response hasPrefix:@"CodaKitBeautifierError="]){
                [self showError:[response stringByReplacingOccurrencesOfString:@"CodaKitBeautifierError=" withString:@""]];
                return;
            }
        }
        
        if(selection){
            [tv replaceCharactersInRange:[tv selectedRange] withString:response];
        }
        else {
            [tv replaceCharactersInRange:NSMakeRange(0, tv.string.length) withString:response];
        }
    }
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

-(void)quoteFixer:(id)sender
{
	CodaTextView *tv = [controller focusedTextView:self];
	
    if(tv)
	{
		NSString *selectedText = [tv selectedText];
		
		if(selectedText)
        {
            selectedText = [selectedText stringByReplacingOccurrencesOfString:@"'" withString:@"{{PT.SQ}}"];
            selectedText = [selectedText stringByReplacingOccurrencesOfString:@"\"" withString:@"{{PT.DQ}}"];
            selectedText = [selectedText stringByReplacingOccurrencesOfString:@"{{PT.SQ}}" withString:@"\""];
            selectedText = [selectedText stringByReplacingOccurrencesOfString:@"{{PT.DQ}}" withString:@"'"];
            
            [tv replaceCharactersInRange:[tv selectedRange] withString:selectedText];
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
			[tv replaceCharactersInRange:tv.selectedRange withString:[NSString stringWithFormat:@"<%@>%@</%@>", tagName, selectedText, tagName]];
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
            
            if(tv.currentLineNumber == 1)
            {
                start = range.location;
                end = range.length;
                
                if([tv.string isNotEqualTo:[tv stringWithRange:tv.rangeOfCurrentLine]]){
                    end += [[tv lineEnding] length];
                }
            }
            else {
                start = range.location - [[tv lineEnding] length];
                end = range.length+[[tv lineEnding] length];
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
            
            NSString *copiedContent = [NSString stringWithFormat:@"%@%@", [tv lineEnding], lineContent];
            [tv insertText:copiedContent];
        }
	}
}

-(void)newLine:(id)sender
{
	CodaTextView *tv = [controller focusedTextView:self];
    
	if(tv){
		[tv insertText:@"<br />"];
	}
}

-(BOOL)validateMenuItem:(NSMenuItem *)aMenuItem
{
	BOOL result = YES;
    
	if([controller focusedTextView:self] == nil){
        result = NO;
    }
    else {
        if([aMenuItem action] == @selector(quoteFixer:) || [aMenuItem action] == @selector(toUpperCase:) || [aMenuItem action] == @selector(toLowerCase:) || [aMenuItem action] == @selector(wrapWithTag:))
        {
            if([[controller focusedTextView:self] selectedText] == nil || [[[controller focusedTextView:self] selectedText] isEqualToString:@""]){
                result = NO;
            }
        }
    }
	
	return result;
}

-(void)showError:(NSString *)text
{
    [self showError:text andTitle:@"CodaKit"];
}

-(void)showError:(NSString *)text andTitle:(NSString *)title
{
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:title];
    [alert setInformativeText:text];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert runModal];
}

@end
