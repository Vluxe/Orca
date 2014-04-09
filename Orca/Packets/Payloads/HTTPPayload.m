///////////////////////////////////////////////////////////////////////////////////////
//
//  HTTPPayload.m
//  Orca
//
//  Created by Dalton Cherry on 4/8/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "HTTPPayload.h"
#import "TCPPacket.h"

@implementation HTTPPayload

///////////////////////////////////////////////////////////////////////////////////////
+(BOOL)isPayload:(id)packet
{
    TCPPacket *tcpObject = packet;
    NSString *text = tcpObject.payloadString;
    //NSLog(@"text: %@",text);
    if(text && [text rangeOfString:@"HTTP/"].location != NSNotFound)
    {
        HTTPPayload *payload = [HTTPPayload new];
        tcpObject.payload = payload;
        NSLog(@"http payload: %@",text);
        //we need to do more parsing here...
        //basically get the headers into a dict.
        //get the status code, resource, VERB
        //and then put the response content into a string.
        //now we have a beautiful form HTTP payload object
        return YES;
    }
    return NO;
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)payloadInfo
{
    return @"I am HTTP...";
}
///////////////////////////////////////////////////////////////////////////////////////

@end
