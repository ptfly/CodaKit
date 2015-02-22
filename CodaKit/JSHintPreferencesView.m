//
//  JSHintPreferencesView.m
//  CodaKit
//
//  Created by Plamen Todorov on 09.05.14.
//  Copyright (c) 2014 г. Plamen Todorov. All rights reserved.
//

#import "JSHintPreferencesView.h"

@implementation JSHintPreferencesView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self drawForm];
    }
    
    return self;
}

-(void)drawForm
{
    settings = @[
                 
         //@{@"key": @"separator", @"info": @"Error Handling:"},
         @{@"key": @"maxerr", @"value":@"50",                @"options": @[@"integer"],	@"info": @"Maximum error before stopping"},
         
         // Enforcing
         @{@"key": @"separator", @"info": @"Enforcing:"},
         @{@"key": @"bitwise", @"value":@"true",             @"options": @[@"boolean"],	@"info": @"Prohibit bitwise operators (&, |, ^, etc.)"},
         @{@"key": @"camelcase", @"value":@"false",          @"options": @[@"boolean"],	@"info": @"Identifiers must be in camelCase"},
         @{@"key": @"curly", @"value":@"true",               @"options": @[@"boolean"],	@"info": @"Require {} for every new block or scope"},
         @{@"key": @"eqeqeq", @"value":@"true",              @"options": @[@"boolean"],	@"info": @"Require triple equals (===) for comparison"},
         @{@"key": @"forin", @"value":@"true",               @"options": @[@"boolean"],	@"info": @"Require filtering for..in loops with obj.hasOwnProperty()"},
         @{@"key": @"immed", @"value":@"false",              @"options": @[@"boolean"],	@"info": @"Require immediate invocations to be wrapped in parens e.g. `(function () { } ());`"},
         @{@"key": @"indent", @"value":@"4",                 @"options": @[@"integer"],	@"info": @"Number of spaces to use for indentation"},
         @{@"key": @"latedef", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Require variables/functions to be defined before being used"},
         @{@"key": @"newcap", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Require capitalization of all constructor functions e.g. `new F()`"},
         @{@"key": @"noarg", @"value":@"true",               @"options": @[@"boolean"],	@"info": @"Prohibit use of `arguments.caller` and `arguments.callee`"},
         @{@"key": @"noempty", @"value":@"true", 			@"options": @[@"boolean"],	@"info": @"Prohibit use of empty blocks"},
         @{@"key": @"nonew", @"value":@"false",              @"options": @[@"boolean"],	@"info": @"Prohibit use of constructors for side-effects (without assignment)"},
         @{@"key": @"plusplus", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Prohibit use of `++` & `--`"},
         @{@"key": @"quotmark", @"value":@"false", 			@"options": @[@"boolean", @"single", @"double"], @"info": @"Quotation mark consistency"},
         @{@"key": @"undef", @"value":@"true",               @"options": @[@"boolean"],	@"info": @"Require all non-global variables to be declared (prevents global leaks)"},
         @{@"key": @"unused", @"value":@"true",              @"options": @[@"boolean"],	@"info": @"Require all defined variables be used"},
         @{@"key": @"strict", @"value":@"true",              @"options": @[@"boolean"],	@"info": @"Requires all functions run in ES5 Strict Mode"},
         @{@"key": @"trailing", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Prohibit trailing whitespaces"},
         @{@"key": @"maxparams", @"value":@"false",          @"options": @[@"integer"],	@"info": @"Max number of formal params allowed per function"},
         @{@"key": @"maxdepth", @"value":@"false", 			@"options": @[@"integer"],	@"info": @"Max depth of nested blocks (within functions)"},
         @{@"key": @"maxstatements", @"value":@"false",		@"options": @[@"integer"],	@"info": @"Max number statements per function"},
         @{@"key": @"maxcomplexity", @"value":@"false",		@"options": @[@"integer"],	@"info": @"Max cyclomatic complexity per function"},
         @{@"key": @"maxlen", @"value":@"false", 			@"options": @[@"integer"],	@"info": @"Max number of characters per line"},
         
         // Relaxing
         @{@"key": @"separator", @"info": @"Relaxing:"},
         @{@"key": @"asi", @"value":@"false", 				@"options": @[@"boolean"],	@"info": @"Tolerate Automatic Semicolon Insertion (no semicolons)"},
         @{@"key": @"boss", @"value":@"false", 				@"options": @[@"boolean"],	@"info": @"Tolerate assignments where comparisons would be expected"},
         @{@"key": @"debug", @"value":@"false",              @"options": @[@"boolean"],	@"info": @"Allow debugger statements e.g. browser breakpoints."},
         @{@"key": @"eqnull", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Tolerate use of `== null`"},
         @{@"key": @"es5", @"value":@"false", 				@"options": @[@"boolean"],	@"info": @"Allow ES5 syntax (ex: getters and setters)"},
         @{@"key": @"esnext", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Allow ES.next (ES6) syntax (ex: `const`)"},
         @{@"key": @"moz", @"value":@"false", 				@"options": @[@"boolean"],	@"info": @"Allow Mozilla specific syntax (extends and overrides esnext features)"},
         @{@"key": @"evil", @"value":@"false", 				@"options": @[@"boolean"],	@"info": @"Tolerate use of `eval` and `new Function()`"},
         @{@"key": @"expr", @"value":@"false", 				@"options": @[@"boolean"],	@"info": @"Tolerate `ExpressionStatement` as Programs"},
         @{@"key": @"funcscope", @"value":@"false",          @"options": @[@"boolean"],	@"info": @"Tolerate defining variables inside control statements"},
         @{@"key": @"globalstrict", @"value":@"false", 		@"options": @[@"boolean"],	@"info": @"Allow global \"use strict\" (also enables 'strict')"},
         @{@"key": @"iterator", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Tolerate using the `__iterator__` property"},
         @{@"key": @"lastsemic", @"value":@"false",          @"options": @[@"boolean"],	@"info": @"Tolerate omitting a semicolon for the last statement of a 1-line block"},
         @{@"key": @"laxbreak", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Tolerate possibly unsafe line breakings"},
         @{@"key": @"laxcomma", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Tolerate comma-first style coding"},
         @{@"key": @"loopfunc", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Tolerate functions being defined in loops"},
         @{@"key": @"multistr", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Tolerate multi-line strings"},
         @{@"key": @"proto", @"value":@"false",              @"options": @[@"boolean"],	@"info": @"Tolerate using the `__proto__` property"},
         @{@"key": @"scripturl", @"value":@"false",          @"options": @[@"boolean"],	@"info": @"Tolerate script-targeted URLs"},
         @{@"key": @"smarttabs", @"value":@"false",          @"options": @[@"boolean"],	@"info": @"Tolerate mixed tabs/spaces when used for alignment"},
         @{@"key": @"shadow", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Allows re-define variables later in code e.g. `var x=1; x=2;`"},
         @{@"key": @"sub", @"value":@"false", 				@"options": @[@"boolean"],	@"info": @"Tolerate using `[]` notation when it can still be expressed in dot notation"},
         @{@"key": @"supernew", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Tolerate `new function () { ... };` and `new Object;`"},
         @{@"key": @"validthis", @"value":@"false",          @"options": @[@"boolean"],	@"info": @"Tolerate using this in a non-constructor function"},
         
         // Environments
         @{@"key": @"separator", @"info": @"Environments:"},
         @{@"key": @"browser", @"value":@"true", 			@"options": @[@"boolean"],	@"info": @"Web Browser (window, document, etc)"},
         @{@"key": @"couch", @"value":@"false",              @"options": @[@"boolean"],	@"info": @"CouchDB"},
         @{@"key": @"devel", @"value":@"true",               @"options": @[@"boolean"],	@"info": @"Development/debugging (alert, confirm, etc)"},
         @{@"key": @"dojo", @"value":@"false", 				@"options": @[@"boolean"],	@"info": @"Dojo Toolkit"},
         @{@"key": @"jquery", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"jQuery"},
         @{@"key": @"mootools", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"MooTools"},
         @{@"key": @"node", @"value":@"false", 				@"options": @[@"boolean"],	@"info": @"Node.js"},
         @{@"key": @"nonstandard", @"value":@"false", 		@"options": @[@"boolean"],	@"info": @"Widely adopted globals (escape, unescape, etc)"},
         @{@"key": @"prototypejs", @"value":@"false", 		@"options": @[@"boolean"],	@"info": @"Prototype and Scriptaculous"},
         @{@"key": @"rhino", @"value":@"false",              @"options": @[@"boolean"],	@"info": @"Rhino"},
         @{@"key": @"worker", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Web Workers"},
         @{@"key": @"wsh", @"value":@"false", 				@"options": @[@"boolean"],	@"info": @"Windows Scripting Host"},
         @{@"key": @"yui", @"value":@"false", 				@"options": @[@"boolean"],	@"info": @"Yahoo User Interface"},
         
         // Legacy
         @{@"key": @"separator", @"info": @"Legacy:"},
         @{@"key": @"nomen", @"value":@"false",              @"options": @[@"boolean"],	@"info": @"Prohibit dangling `_` in variables"},
         @{@"key": @"onevar", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Allow only one `var` statement per function"},
         @{@"key": @"passfail", @"value":@"false", 			@"options": @[@"boolean"],	@"info": @"Stop on first error"},
         @{@"key": @"white", @"value":@"false",              @"options": @[@"boolean"],	@"info": @"Check against strict whitespace and indentation rules"},
         
         // Custom Globals
         @{@"key": @"separator", @"info": @"Additional Predefined Global Variables:"},
         @{@"key": @"globals", @"value": @"", 				@"options": @[@"input"],	@"info": @""}
    ];
    
    NSString *cfg = [[NSUserDefaults standardUserDefaults] stringForKey:@"jsHintOptions"];
    
    // Load prefs
    if(cfg && ![cfg isEqualToString:@""])
    {
        NSData *data = [cfg dataUsingEncoding:NSUTF8StringEncoding];
        
        if(data){
            id tmp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            jsHintConfig = [tmp mutableCopy];
        }
    }
    else {
        jsHintConfig = [NSMutableDictionary dictionary];
    }
    
    float x = 0;
    __block float y = 0;
    
    for(uint i=0; i<settings.count; i++)
    {
        // Draw separaotr
        NSDictionary *data = [settings objectAtIndex:i];
        
        if([[data objectForKey:@"key"] isEqualToString:@"separator"])
        {
            NSTextField *sep = [[NSTextField alloc] initWithFrame:CGRectMake(x, y+7, 400.0, 22.0)];
            
            [sep setTextColor:[NSColor grayColor]];
            [sep setBezeled:NO];
            [sep setDrawsBackground:NO];
            [sep setEditable:NO];
            [sep setSelectable:NO];
            [sep setStringValue:[data objectForKey:@"info"]];
            
            [self addSubview:sep];
            
            y+= 25;
            
            continue;
        }
        
        NSArray *options = [data objectForKey:@"options"];
        
        NSString *key  = [data objectForKey:@"key"];
        NSString *info = [data objectForKey:@"info"];
        NSString *hint = key;
        NSString *conf = [jsHintConfig objectForKey:key];
        
        // defaults
        if(!conf || [[NSString stringWithFormat:@"%@", conf] isEqualToString:@""]){
            conf = [data objectForKey:@"value"];
        }
        
        if([options count] == 1)
        {
            if([[options lastObject] isEqualToString:@"boolean"])
            {
                NSButton *checkbox = [[NSButton alloc] initWithFrame:CGRectMake(x, y, 522.0, 22.0)];
                
                [checkbox setTag:i];
                [checkbox setToolTip:hint];
                [checkbox setButtonType:NSSwitchButton];
                [checkbox setTitle:[data objectForKey:@"info"]];
                [checkbox setState:[conf isEqualToString:@"true"]];
                [checkbox setTarget:self];
                [checkbox setAction:@selector(valueChanged:)];
                
                [self addSubview:checkbox];
            }
            else if([[options lastObject] isEqualToString:@"integer"] || [[options lastObject] isEqualToString:@"input"])
            {
                NSTextField *input;
                
                if([[data objectForKey:@"info"] isEqualToString:@""]){
                    input = [[NSTextField alloc] initWithFrame:CGRectMake(x+2, y, 520.0, 22.0)];
                }
                else {
                    input = [[NSTextField alloc] initWithFrame:CGRectMake(x+2, y, 60.0, 22.0)];
                    
                    NSTextField *label = [[NSTextField alloc] initWithFrame:CGRectMake(x+65.0, y+2, 460.0, 22.0)];
                    
                    [label setBezeled:NO];
                    [label setDrawsBackground:NO];
                    [label setEditable:NO];
                    [label setSelectable:NO];
                    [label setToolTip:hint];
                    [label setStringValue:info];
                    
                    [self addSubview:label];
                }
                
                [input setTag:i];
                [input setFocusRingType:NSFocusRingTypeNone];
                [input setStringValue:conf];
                [input setDelegate:self];
                
                [self addSubview:input];
            }
        }
        else {
            NSPopUpButton *combo = [[NSPopUpButton alloc] initWithFrame:CGRectMake(x+2, y, 100.0, 25.0)];
            NSTextField *label = [[NSTextField alloc] initWithFrame:CGRectMake(x+105.0, y+4, 420.0, 25.0)];
            
            [label setBezeled:NO];
            [label setDrawsBackground:NO];
            [label setEditable:NO];
            [label setSelectable:NO];
            [label setToolTip:hint];
            [label setStringValue:info];
            
            int selected = 0;
            NSButton *checkbox;
            
            for(uint j=0; j<options.count; j++)
            {
                if([[options objectAtIndex:j] isEqualToString:@"boolean"])
                {
                    checkbox = [[NSButton alloc] initWithFrame:CGRectMake(x, y, 522.0, 22.0)];
                    
                    [checkbox setTitle:@""];
                    [checkbox setState:![conf isEqualToString:@"false"]];
                    [checkbox setButtonType:NSSwitchButton];
                    [checkbox setTag:5000+i];
                    [checkbox setTarget:self];
                    [checkbox setAction:@selector(valueChanged:)];
                    
                    [self addSubview:checkbox];
                    
                    CGRect cf = combo.frame;
                    CGRect lf = label.frame;
                    
                    cf.origin.x += 16;
                    lf.origin.x += 16;
                    
                    [combo setFrame:cf];
                    [combo setEnabled:[conf boolValue]];
                    [label setFrame:lf];
                }
                else {
                    if([[NSString stringWithFormat:@"%@", conf] isEqualToString:[options objectAtIndex:j]]){
                        selected = j;
                    }
                    [combo addItemWithTitle:[options objectAtIndex:j]];
                }
            }
            
            [combo setTag:i];
            [combo selectItemAtIndex:selected];
            [combo setTarget:self];
            [combo setAction:@selector(valueChanged:)];
            
            [self addSubview:combo];
            [self addSubview:label];
        }
        
        y += 26.0;
    };
    
    CGRect frame = self.frame;
    frame.size.height = fabs(y);
    [self setFrame:frame];
}

-(BOOL)isFlipped
{
    return YES;
}

-(void)valueChanged:(id)sender
{
    NSDictionary *data;
    
    if([sender tag] < settings.count){
        data = [settings objectAtIndex:[sender tag]];
    }
    
    if([sender isKindOfClass:[NSButton class]])
    {
        NSButton *cb = (NSButton *)sender;
        
        // enablers
        if(cb.tag > 5000)
        {
            long tag = (cb.tag-5000);
            [[cb.superview viewWithTag:tag] setEnabled:cb.state];
            
            data = [settings objectAtIndex:tag];
        }
        
        NSString *value = @"false";
        if(cb.state == NSOnState){
            value = @"true";
        }
        
        [jsHintConfig setObject:value forKey:[data objectForKey:@"key"]];
    }
    
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
        NSPopUpButton *combo = (NSPopUpButton *)sender;
        [jsHintConfig setObject:[combo selectedItem].title forKey:[data objectForKey:@"key"]];
    }
    
    [self synchronize];
}

-(void)controlTextDidChange:(NSNotification *)notification
{
    NSTextField *input = [notification object];
    NSDictionary *data = [settings objectAtIndex:[input tag]];
    
    [jsHintConfig setObject:[input stringValue] forKey:[data objectForKey:@"key"]];
    
    [self synchronize];
}

-(void)synchronize
{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsHintConfig options:0 error:&err];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:@"jsHintOptions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(IBAction)reset:(id)sender
{
    NSArray *subviews = [[self subviews] copy];
    
    for(id subview in subviews){
        [subview removeFromSuperview];
    }
    
    jsHintConfig = [NSMutableDictionary dictionary];
        
    [self synchronize];
    [self drawForm];
}

-(IBAction)gotoLink:(id)sender
{
    NSButton *btn = (NSButton *)sender;
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[btn title]]];
}
@end
