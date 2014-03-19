///////////////////////////////////////////////////////////////////////////////////////
//
//  EthernetPacket.h
//  Orca
//
//  Created by Dalton Cherry on 3/18/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//  The base ethernet header. Stores the Mac address.
///////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface EthernetPacket : NSObject

@property(nonatomic,copy)NSString *srcMac;
@property(nonatomic,copy)NSString *dstMac;

- (instancetype)initWithPacket:(u_char *)packet;

@end
