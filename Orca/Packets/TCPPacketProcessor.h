///////////////////////////////////////////////////////////////////////////////////////
//
//  TCPPacketProcessor.h
//  Orca
//
//  Created by Dalton Cherry on 4/15/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@class TCPPacket;

@protocol TCPPacketProcessorDelegate <NSObject>

/**
 This returns a assembled TCPPackets (e.g. a HTTP packet).
 The first TCPPacket will be used for the headers up to the assembled packet.
 @param: the newly assembled packet.
 */
-(void)didAssemblePacket:(TCPPacket*)packet;

@end

@interface TCPPacketProcessor : NSObject

/**
 Packet TCP processor singleton.
 */
+(TCPPacketProcessor*)sharedProcessor;

/**
 Add a TCPPacket to the collector so it can be grouped.
 Once a FIN or FIN|ACK flag is on the packet, the grouping process will be run.
 This process can spit out a "new" packet (e.g. a HTTP packet based off the data) to the delegate.
 @param: packet is the TCP object to add to the processor.
 */
-(void)addPacket:(TCPPacket*)packet;

/**
 Add a delegate to the multicast delegate system
 @param: delegate is the object to receive the delegate messages
 */
-(void)addDelegate:(id<TCPPacketProcessorDelegate>)delegate;

/**
 remove a delegate from the multicast delegate system
 @param: delegate is the object to receive the delegate messages
 */
-(void)removeDelegate:(id<TCPPacketProcessorDelegate>)delegate;



@end
