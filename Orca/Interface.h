///////////////////////////////////////////////////////////////////////////////////////
//
//  Interface.h
//  Orca
//
//  Created by Dalton Cherry on 4/7/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface Interface : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSArray *addresses;

@property(nonatomic,copy,readonly)NSString *displayName;

@end
