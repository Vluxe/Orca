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

///////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.pcap = [[PacketCapture alloc] init];
    NSArray *interfaces = [self.pcap getInterfaces];
    for(NSString *interface in interfaces)
        NSLog(@"inteface: %@", interface);
    [self.popButton addItemsWithTitles:interfaces];
}
///////////////////////////////////////////////////////////////////////////////////////
-(IBAction)startCapture:(id)sender
{
    NSString *interface = self.popButton.selectedItem.title;
    NSLog(@"starting capture on: %@",interface);
    [self.pcap capturePackets:interface];
}
///////////////////////////////////////////////////////////////////////////////////////


@end
