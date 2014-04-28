///////////////////////////////////////////////////////////////////////////////////////
//
//  UDPPacket.h
//  Orca
//
//  Created by Dalton Cherry on 4/21/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "IPPacket.h"

@interface UDPPacket : IPPacket

@property(nonatomic, assign)NSInteger udpHeaderSize;
@property(nonatomic, assign)NSInteger srcPort;
@property(nonatomic, assign)NSInteger dstPort;
@property(nonatomic, assign)NSInteger checksum;
@property(nonatomic,strong)NSData *payloadData;
@property(nonatomic,copy)NSString *payloadString;
@property(nonatomic, assign)NSInteger payloadLength;

@end
