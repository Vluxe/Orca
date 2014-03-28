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
    self.dataSource = [[ACTableSource alloc] init];
    self.dataSource.delegate = self;
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
}
///////////////////////////////////////////////////////////////////////////////////////
-(IBAction)startCapture:(id)sender
{
    if(self.pcap.isCapturing)
    {
        NSLog(@"stopping capture");
        self.captureButton.label = self.captureButton.paletteLabel = NSLocalizedString(@"Start", nil);
        [self.pcap stopCapturing];
    }
    else
    {
        self.captureButton.label = self.captureButton.paletteLabel = NSLocalizedString(@"Stop", nil);
        NSString *interface = self.popButton.selectedItem.title;
        NSLog(@"starting capture on: %@",interface);
        [self.pcap capturePackets:interface];
    }
}
///////////////////////////////////////////////////////////////////////////////////////
-(Class)classForObject:(id)object
{
    return nil;
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc
{
    self.dataSource = nil;
}
///////////////////////////////////////////////////////////////////////////////////////


@end
