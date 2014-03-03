///////////////////////////////////////////////////////////////////////////////////////
//
//  AppDelegate.m
//  Orca
//
//  Created by Austin Cherry on 3/2/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "AppDelegate.h"
#import "PacketCapture.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    PacketCapture *pcap = [[PacketCapture alloc] init];
    [pcap capturePackets];
}

@end
