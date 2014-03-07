///////////////////////////////////////////////////////////////////////////////////////
//
//  TCPPacket.m
//  Orca
//
//  Created by Austin Cherry on 3/6/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "TCPPacket.h"
#import <netinet/tcp.h>

@implementation TCPPacket

- (instancetype)initWithTCPHeader:(struct tcphdr *)tcpHeader
{
    if(self = [super init])
    {
        
    }
    return self;
}

@end
