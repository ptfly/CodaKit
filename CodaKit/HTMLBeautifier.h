//
//  HTMLBeautifier.h
//  CodaKit
//
//  Created by Plamen Todorov on 14.05.14.
//  Copyright (c) 2014 г. Plamen Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLBeautifier : NSObject

@property(nonatomic, retain) NSString *tmpFilePath;

-(id)initWithString:(NSString *)string;
-(NSString *)beautify;

@end
