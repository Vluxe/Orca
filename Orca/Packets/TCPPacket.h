///////////////////////////////////////////////////////////////////////////////////////
//
//  TCPPacket.h
//  Orca
//
//  Created by Austin Cherry on 3/6/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "IPPacket.h"

@interface TCPPacket : IPPacket

@property(nonatomic, assign)NSInteger tcpSize;
@property(nonatomic, assign)NSInteger srcPort;
@property(nonatomic, assign)NSInteger dstPort;
@property(nonatomic, assign)NSInteger sequence;
@property(nonatomic, assign)NSInteger acknowledgement;
@property(nonatomic, assign)NSInteger flags;
@property(nonatomic, assign)NSInteger offset;
@property(nonatomic, assign)NSInteger window;
@property(nonatomic, assign)NSInteger checksum;
@property(nonatomic, assign)NSInteger urgentPointer;
@property(nonatomic,strong)NSData *payloadData;
@property(nonatomic,copy)NSString *payloadString;

@end
