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
@property(nonatomic,assign)NSInteger totalSize;
@property(nonatomic,assign)NSInteger version;
@property(nonatomic,assign)NSInteger IPHeaderSize;

@property(nonatomic,assign)NSInteger IPIdent;
@property(nonatomic,assign)NSInteger IPFlags;
@property(nonatomic,assign)NSInteger IPTTL;
@property(nonatomic, assign)NSInteger IPChecksum;

//ipv6 specific headers will go here

@end
