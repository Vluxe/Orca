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

@interface TCPPacket : NSObject

@property(nonatomic, copy)NSString *sourceIP;
@property(nonatomic, copy)NSString *dstIP;
@property(nonatomic, strong)NSNumber *sourcePort;
@property(nonatomic, strong)NSNumber *dstPort;
@property(nonatomic, strong)NSNumber *sequence;
@property(nonatomic, strong)NSNumber *acknowledgement;
@property(nonatomic, strong)NSNumber *flags;
@property(nonatomic, strong)NSNumber *offset;
@property(nonatomic, strong)NSNumber *window;
@property(nonatomic, strong)NSNumber *checksum;
@property(nonatomic, strong)NSNumber *urgentPointer;

@end
