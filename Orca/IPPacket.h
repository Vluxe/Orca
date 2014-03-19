///////////////////////////////////////////////////////////////////////////////////////
//
//  IPPacket.h
//  Orca
//
//  Created by Dalton Cherry on 3/18/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//  This can be either IPV4 or IPV6.
///////////////////////////////////////////////////////////////////////////////////////

#import "EthernetPacket.h"

@interface IPPacket : EthernetPacket

@property(nonatomic,copy)NSString *srcIP;
@property(nonatomic,copy)NSString *dstIP;
@property(nonatomic,strong)NSNumber *totalSize;

//ipv6 specific headers will go here

//ipv4 headers will go here

@end
