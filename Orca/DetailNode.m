////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DetailNode.m
//  Orca
//
//  Created by Dalton Cherry on 4/27/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DetailNode.h"

@implementation DetailNode

////////////////////////////////////////////////////////////////////////////////////////////////////
-(instancetype)initWithText:(NSString*)text;
{
    if(self = [super init])
    {
        self.text = text;
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DetailNode*)nodeWithText:(NSString*)text
{
    return [[DetailNode alloc] initWithText:text];
}
////////////////////////////////////////////////////////////////////////////////////////////////////

@end
