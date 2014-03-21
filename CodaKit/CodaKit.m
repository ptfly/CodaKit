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
        
//		[controller registerActionWithTitle:@"Suggest Completion" target:self selector:@selector(autoComplete:)];
//        [controller registerActionWithTitle:@"—" target:self selector:nil];
        
        [controller registerActionWithTitle:@"Flip Quotes" target:self selector:@selector(quoteFixer:)];
        [controller registerActionWithTitle:@"Compile DustJS" target:self selector:@selector(compileDustJS:)];
		[controller registerActionWithTitle:@"Capitalize Selection" target:self selector:@selector(toUpperCase:)];
		[controller registerActionWithTitle:@"Uncapitalize Selection" target:self selector:@selector(toLowerCase:)];
        
        [controller registerActionWithTitle:@"Delete Selection / Line" target:self selector:@selector(deleteSelection:)];
        [controller registerActionWithTitle:@"Duplicate Selection / Line" target:self selector:@selector(duplicateSelection:)];
        [controller registerActionWithTitle:@"Line Break" target:self selector:@selector(newLine:)];
        
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
                
                for(uint i=0; i<dirs.count; i++){
                    path = [path stringByAppendingFormat:@"/%@", [dirs objectAtIndex:i]];
                    NSLog(@"%@", path);
                    
                    BOOL isDir = YES;
                    if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] == NO){
                        NSError *err;
                        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
                        if(err){
                            NSLog(@"%@", err);
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

-(void)autoComplete:(id)sender
{
    CodaTextView *tv = [controller focusedTextView:self];
	
    if(tv)
	{
        NSRange range   = [tv previousWordRange];
//        NSNumber *start = [NSNumber numberWithLong:range.location];
        NSNumber *end   = [NSNumber numberWithLong:range.location+range.length];
        NSNumber *bTrue = [NSNumber numberWithBool:YES];
        
        NSLog(@"Word: %@", [tv stringWithRange:range]);
        [self ternJS:@{@"query":@{@"type": @"completions", @"file":[tv path], @"end":end, @"types":bTrue}}];
    }
}

-(void)ternJS:(NSDictionary *)params
{
    NSError *error;
    NSData *outputData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
    if(!outputData){
        NSLog(@"JSON ERROR: %@", error);
    }
    else {
        
        NSURL *URL = [NSURL URLWithString:@"http://127.0.0.1:54782"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:outputData];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSMenu *theMenu = [[NSMenu alloc] init];
           
            [[responseObject objectForKey:@"completions"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                NSMenuItem *item = [[NSMenuItem alloc] init];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[obj objectForKey:@"name"]];
                
                [item setAttributedTitle:attrString];
                [item setAction:@selector(insertSuggestion:)];
                [item setTarget:self];
                [item setRepresentedObject:obj];
                
                [theMenu insertItem:item atIndex:(unsigned long)idx];
            }];
            
            CodaTextView *tv = [controller focusedTextView:self];
            
            NSPoint myPoint = [tv.window.contentView convertPoint:[tv.window convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
            
            NSEvent *fakeMouseEvent = [NSEvent mouseEventWithType:NSLeftMouseDown location:myPoint modifierFlags:0 timestamp:0 windowNumber:[tv.window windowNumber] context:nil eventNumber:0 clickCount:0 pressure:0];
            
            [NSMenu popUpContextMenu:theMenu withEvent:fakeMouseEvent forView:nil];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"ERROR %@", [error localizedDescription]);
        }];
        
        [operation start];
    }
}

-(void)insertSuggestion:(id)sender
{
    CodaTextView *tv = [controller focusedTextView:self];
    
	if(tv){
        NSDictionary *info = (NSDictionary *)[sender representedObject];
        [tv replaceCharactersInRange:[tv previousWordRange] withString:[info objectForKey:@"name"]];
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
                    end += 1;
                }
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
