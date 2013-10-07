//
//  CodaKit.h
//  CodaKit
//
//  Created by Plamen Todorov on 07.10.13.
//  Copyright (c) 2013 г. Plamen Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodaPluginsController.h"

@class CodaPlugInsController;

@interface CodaKit : NSObject <CodaPlugIn>
{
    CodaPlugInsController* controller;
}

@end
