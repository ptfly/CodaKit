//
//  CodaKit.h
//  CodaKit
//
//  Created by Plamen Todorov on 07.10.13.
//  Copyright (c) 2013 г. Plamen Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "CodaPluginsController.h"
#import "DebugPrint.h"

@class CodaPlugInsController;

@interface CodaKit : NSObject <CodaPlugIn>
{
    DebugPrint *debug;
    CodaPlugInsController *controller;
}

@end
