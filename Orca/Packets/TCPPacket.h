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
#import "Payload.h"

@interface TCPPacket : IPPacket

@property(nonatomic, strong)NSNumber *tcpSize;
@property(nonatomic, strong)NSNumber *srcPort;
@property(nonatomic, strong)NSNumber *dstPort;
@property(nonatomic, strong)NSNumber *sequence;
@property(nonatomic, strong)NSNumber *acknowledgement;
@property(nonatomic, strong)NSNumber *flags;
@property(nonatomic, strong)NSNumber *offset;
@property(nonatomic, strong)NSNumber *window;
@property(nonatomic, strong)NSNumber *checksum;
@property(nonatomic, strong)NSNumber *urgentPointer;
@property(nonatomic,strong)NSData *payloadData;
@property(nonatomic,copy)NSString *payloadString;
@property(nonatomic,strong)Payload *payload;

@end
