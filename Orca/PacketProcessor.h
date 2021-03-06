///////////////////////////////////////////////////////////////////////////////////////
//
//  PacketProcessor.h
//  Orca
//
//  Created by Dalton Cherry on 4/7/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "Interface.h"

@class EthernetPacket;

@protocol PacketProcessorDelegate <NSObject>

/**
 Packets are buffered to avoid the UI being refresh every time a new packet comes in. 
 This can be can be very often and usually come in batches, so this greatly improves drawing preformance.
 */
-(void)didReceivePackets:(NSArray*)packets;

/**
 A search query has finished.
 */
-(void)didSearchPackets:(NSArray*)packets;

@end

@interface PacketProcessor : NSObject

/**
 processor singleton.
 */
+(PacketProcessor*)sharedProcessor;

/**
 get the interface names.
 @return returns a list of all the interfaces.
 */
+(NSArray*)getInterfaces;

/**
 @return returns if we are capturing.
 */
@property(nonatomic,assign,readonly)BOOL isCapturing;

/**
 The standard delegate pattern. We might turn this into a multicast delegate.
 */
@property(nonatomic,weak)id<PacketProcessorDelegate>delegate;

/**
 start capturing packets on a interface.
 @param inteface is the name of the interfce to start capturing on. 
 // The interface names can be fetched from getInterfaces
 */
- (void)startCapture:(Interface*)interface;

/**
 stop capturing packets (if it is capturing already).
 */
-(void)stopCapture;

/**
 save the packet capture to disk as a pcap file.
 @param fileURL is the url to save the packet capture to.
 */
- (void)saveCapture:(NSURL *)fileURL;

/**
 open a packet capture from disk.
 @param fileURL is the url to open it from.
 */
- (void)openCapture:(NSURL *)fileURL;

/**
 Get a packet at a row index.
 @param: index is array index to access for the packet.
 @return a packet that has been processed
 */
-(EthernetPacket*)packetAtIndex:(NSInteger)index;

/**
 Search the packets.
 @param: the search query to process.
 */
-(void)runSearch:(NSString*)query;



@end
