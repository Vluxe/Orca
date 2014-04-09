///////////////////////////////////////////////////////////////////////////////////////
//
//  Payload.h
//  Orca
//
//  Created by Dalton Cherry on 4/8/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface Payload : NSObject

/**
 check and return a payload if the payload is the right type.
 @param packet is the TCP or UDP packet payload to inspect.
 */
+(BOOL)isPayload:(id)packet;

/**
 @return returns a description of the payload.
 */
@property(nonatomic,copy,readonly)NSString *payloadInfo;

@end
