//
//  HTMLBeautifier.m
//  CodaKit
//
//  Created by Plamen Todorov on 14.05.14.
//  Copyright (c) 2014 г. Plamen Todorov. All rights reserved.
//

#import "HTMLBeautifier.h"

@implementation HTMLBeautifier
@synthesize tmpFilePath;

-(id)initWithString:(NSString *)string
{
    self = [super init];
    
    if(self)
    {
        // Options file
        NSString *coda   = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths   = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        
        self.tmpFilePath = [[paths firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@/Plug-ins/com.codakit.tmp", coda]];
        
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:tmpFilePath atomically:YES];
    }
    
    return self;
}

-(NSString *)beautify
{
    NSString *coda = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *exec = [[paths firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@/Plug-ins/CodaKit.codaplugin/Contents/Resources/3rd/Parser.php", coda]];
    
    //exec = [exec stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    
    // Run compiler
    NSPipe *pipe = [NSPipe pipe];
    NSTask *task = [[NSTask alloc] init];
    NSArray *args = @[@"-c", [NSString stringWithFormat:@"'%@' '%@'", exec, tmpFilePath]];
    
    [task setLaunchPath: @"/bin/bash"];
    [task setArguments:args];
    [task setStandardOutput:pipe];
    [task setStandardError:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    
    NSString *response = [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    
    return response;
}

@end
