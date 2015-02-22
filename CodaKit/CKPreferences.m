//
//  CKPreferences.m
//  CodaKit
//
//  Created by Plamen Todorov on 09.05.14.
//  Copyright (c) 2014 г. Plamen Todorov. All rights reserved.
//

#import "CKPreferences.h"

@interface CKPreferences ()

@property (nonatomic, assign) IBOutlet NSView *jsHintView;
@end

@implementation CKPreferences
@synthesize jsHintView;

-(id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    
    if(self){
        [self.window setDelegate:self];
    }
    return self;
}

-(void)windowDidLoad
{
    [super windowDidLoad];
}

-(void)windowDidBecomeKey:(NSNotification *)notification
{
    
}

-(void)windowWillClose:(NSNotification *)notification
{
    // Write JSHint Config File
    NSString *cfg = [[NSUserDefaults standardUserDefaults] stringForKey:@"jsHintOptions"];
    
    if(cfg && ![cfg isEqualToString:@""])
    {
        NSData *data = [cfg dataUsingEncoding:NSUTF8StringEncoding];
        
        if(data)
        {
            id tmp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if(tmp)
            {
                NSMutableArray *lines = [NSMutableArray array];
                
                for(id key in tmp){
                    [lines addObject:[NSString stringWithFormat:@"\t\"%@\": %@", key, [tmp objectForKey:key]]];
                }
                
                NSString *coda = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
                NSString *path = [[paths firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@/Plug-ins/%@", coda, @"com.codakit.jshint"]];
                
                NSData *data   = [[NSString stringWithFormat:@"{\n%@\n}", [lines componentsJoinedByString:@",\n"]] dataUsingEncoding:NSUTF8StringEncoding];
                
                [data writeToFile:path atomically:YES];
            }
        }
    }
}

@end
