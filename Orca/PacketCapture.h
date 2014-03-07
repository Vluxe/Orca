///////////////////////////////////////////////////////////////////////////////////////
//
//  PacketCapture.h
//  Orca
//
//  Created by Austin Cherry on 3/2/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface PacketCapture : NSObject

/**
 Returns if the packet filter is running.
 */
@property(nonatomic,assign,readonly)BOOL isCapturing;

/**
 fetches all the new interfaces.
 @return returns a list of all the interfaces.
 */
- (NSArray *)getInterfaces;

/**
 start capture packets on a interface.
 @param is the interface name to start capturing on.
 */
- (void)capturePackets:(NSString *)interface;

/**
 stop capturing packets (if it is capturing all ready).
 */
-(void)stopCapturing;

@end
