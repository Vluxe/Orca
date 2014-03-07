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

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.pcap = [[PacketCapture alloc] init];
    NSArray *interfaces = [self.pcap getInterfaces];
    for(NSString *interface in interfaces)
        NSLog(@"inteface: %@", interface);
    [self.pcap capturePackets:[interfaces firstObject]];
}

@end
