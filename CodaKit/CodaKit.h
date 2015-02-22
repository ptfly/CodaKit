//
//  CodaKit.h
//  CodaKit
//
//  Created by Plamen Todorov on 07.10.13.
//  Copyright (c) 2013 г. Plamen Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodaPluginsController.h"
#import "JSHint.h"

@class CodaPlugInsController;

@interface CodaKit : NSObject <CodaPlugIn, JSHintDelegate>
{
    CodaPlugInsController *controller;
}

@property (nonatomic, retain)  JSHint *JSHintPanel;
@property (nonatomic, retain)  NSWindowController *prefController;

@end
