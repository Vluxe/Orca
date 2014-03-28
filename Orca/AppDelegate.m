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
#import "TextTableViewCell.h"

@implementation AppDelegate

///////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.pcap = [[PacketCapture alloc] init];
    [self.popButton addItemsWithTitles:[self.pcap getInterfaces]];
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)awakeFromNib
{
    self.dataSource = [[ACTableSource alloc] init];
    self.dataSource.delegate = self;
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    
    self.time = [NSMutableArray new];
    self.source = [NSMutableArray new];
    self.destination = [NSMutableArray new];
    self.protocol = [NSMutableArray new];
    
    [self.dataSource bindArrays:@[self.time,self.source,self.destination,self.protocol]
                    toTableView:self.tableView];
    
    //fake test!!!
    for(int i = 0; i < 10; i++)
    {
        [self.time addObject:@"random time"];
        [self.source addObject:@"random src"];
        [self.destination addObject:@"random dest"];
        [self.protocol addObject:@"random protocol"];
    }
    [self.tableView reloadData];
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
    return [TextTableViewCell class];
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc
{
    self.dataSource = nil;
}
///////////////////////////////////////////////////////////////////////////////////////


@end
