//
//  JSHint.m
//  CodaKit
//
//  Created by Plamen Todorov on 11.05.14.
//  Copyright (c) 2014 г. Plamen Todorov. All rights reserved.
//

#import "JSHint.h"
#import "XMLReader.h"

// Flippd NSClipView
@interface NSFlipView : NSView -(BOOL)isFlipped; @end
@implementation NSFlipView -(BOOL)isFlipped {return YES;} @end


@interface JSHint ()

@end

@implementation JSHint
@synthesize delegate, scrollView, filePathToValidate, infoLabel;

-(id)initWithFilePath:(NSString *)filePath
{
    self = [super initWithWindowNibName:@"JSHint"];
    
    if(self)
    {
        self.filePathToValidate = filePath;
        [[self window] makeKeyAndOrderFront:nil];
    }
    
    return self;
}

-(void)showResults
{
    NSArray *errorsList = [self validate];
    
    // Errors List
    float y = 0;
    
    if(errorsList.count > 0)
    {
        [infoLabel setStringValue:[NSString stringWithFormat:(errorsList.count != 1 ? @"%ld errors" : @"%ld error"), errorsList.count]];
        [infoLabel setTextColor:[NSColor redColor]];
        
        y = [self printErrors:errorsList];
    }
    else {
        [infoLabel setStringValue:@"No Errors"];
        [infoLabel setTextColor:[NSColor grayColor]];
    }
    
    CGRect cvFrame =  self.scrollView.frame;
    cvFrame.size.height = (errorsList.count * 65);
    [self.scrollView.documentView setFrameSize:CGSizeMake(cvFrame.size.width, cvFrame.size.height)];
    
    [[self.scrollView contentView] scrollToPoint: NSMakePoint(0,0)];
    [self.scrollView reflectScrolledClipView: [self.scrollView contentView]];
}

-(float)printErrors:(NSArray *)errorList
{
    NSData *boxTemplate = [NSKeyedArchiver archivedDataWithRootObject:self.boxTemplate];
    
    float x = 5;
    float y = 5;
    
    for(uint i=0; i<errorList.count; i++)
    {
        NSDictionary *data = [errorList objectAtIndex:i];
        
        NSString *evidence = [[data objectForKey:@"evidence"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        evidence = [evidence stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        evidence = [evidence stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *title = [NSString stringWithFormat:@"Line: %@, %@", [data objectForKey:@"line"], [data objectForKey:@"reason"]];
        title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSBox *box = [NSKeyedUnarchiver unarchiveObjectWithData:boxTemplate];
        CGRect frame = CGRectMake(x, y, box.frame.size.width, box.frame.size.height);
        
        [box setFrame:frame];
        [box setHidden:NO];
        [box setAutoresizingMask:NSViewWidthSizable];
        [box setTitle:title];
        
        JSHintBtn *goTo = (JSHintBtn *)[[[box contentView] subviews] objectAtIndex:0];
        [goTo setTarget:self];
        [goTo setAction:@selector(selectError:)];
        [goTo setData:data];
        [self.scrollView.documentView addSubview:box];
        
        NSTextField *info = [[NSTextField alloc] initWithFrame:CGRectMake(10, 9, box.frame.size.width - 50, 18)];
        [info setEditable:NO];
        [info setSelectable:NO];
        [info setBordered:NO];
        [info setBackgroundColor:[NSColor clearColor]];
        [info setStringValue:evidence];
        [info setTextColor:[NSColor darkGrayColor]];
        [info setAlignment:NSLeftTextAlignment];
        [info setFont:[NSFont fontWithName:@"Courier" size:12]];
        [info setAutoresizingMask:NSViewWidthSizable];
        
        [[box contentView] addSubview:info];
        y += 65;
    }
    
    return y;
}

-(void)selectError:(id)sender
{
    if(self.delegate){
        JSHintBtn *btn = (JSHintBtn *)sender;
        [self.delegate goToLine:btn.data];
    }
}

-(NSArray *)validate
{
    // Options file
    NSString *coda = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *optp = [[paths firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@/Plug-ins/%@", coda, @"com.codakit.jshint"]];
    
    // Run compiler
    NSPipe *pipe = [NSPipe pipe];
    NSTask *task = [[NSTask alloc] init];
    NSArray *args = @[@"-c", [NSString stringWithFormat:@"jshint -c '%@' '%@' --verbose --extract=auto --reporter=jslint", optp, filePathToValidate]];
    
    [task setLaunchPath: @"/bin/bash"];
    [task setArguments:args];
    [task setStandardOutput:pipe];
    [task setStandardError:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    
    NSString *response    = [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSDictionary *xmlDict = [[NSDictionary alloc] initWithDictionary:[XMLReader dictionaryForXMLString:response error:nil]];
    
    NSArray *errors;
    
    id found = [[[xmlDict objectForKey:@"jslint"] objectForKey:@"file"] objectForKey:@"issue"];
    
    if([found isKindOfClass:[NSArray class]]){
        errors = found;
    }
    else if([found isKindOfClass:[NSDictionary class]]){
        errors = @[found];
    }
    else {
        errors = @[];
    }
    
    return errors;
}

@end

@implementation JSHintBtn
@synthesize data;

@end