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
#import "PacketProcessor.h"
#import "EthernetPacket.h"
#import "TCPPacket.h"

@implementation AppDelegate

///////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.interfaces = [[NSMutableArray alloc] initWithArray:[PacketProcessor getInterfaces]];
    NSMutableArray *collect = [NSMutableArray arrayWithCapacity:self.interfaces.count];
    for(Interface *inter in self.interfaces)
        [collect addObject:inter.displayName];
    [self.popButton addItemsWithTitles:collect];
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)awakeFromNib
{
    [super awakeFromNib];
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
    /*for(int i = 0; i < 10; i++)
    {
        [self.time addObject:@"random time"];
        [self.source addObject:@"random src"];
        [self.destination addObject:@"random dest"];
        [self.protocol addObject:@"random protocol"];
    }
    [self.tableView reloadData];*/
}
///////////////////////////////////////////////////////////////////////////////////////
-(IBAction)startCapture:(id)sender
{
    PacketProcessor *processor = [PacketProcessor sharedProcessor];
    processor.delegate = (id<PacketProcessorDelegate>)self;
    if(processor.isCapturing)
    {
        NSLog(@"stopping capture");
        self.captureButton.label = self.captureButton.paletteLabel = NSLocalizedString(@"Start", nil);
        [processor stopCapture];
    }
    else
    {
        self.captureButton.label = self.captureButton.paletteLabel = NSLocalizedString(@"Stop", nil);
        NSInteger index = [self.popButton indexOfSelectedItem];
        Interface *inter = self.interfaces[index];
        NSLog(@"starting capture on: %@",inter.name);
        [processor startCapture:inter];
    }
}
///////////////////////////////////////////////////////////////////////////////////////
-(IBAction)saveCapture:(id)sender
{
    PacketProcessor *processor = [PacketProcessor sharedProcessor];
    NSSavePanel *savePanel = [[NSSavePanel alloc] init];
    if ([savePanel runModal] == NSOKButton)
    {
        NSURL *selectedFileName = [savePanel URL];
        if(![[selectedFileName pathExtension] isEqualToString:@"pcap"])
            selectedFileName = [selectedFileName URLByAppendingPathExtension:@"pcap"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            @autoreleasepool {
                [processor saveCapture:selectedFileName];
            }
        });
    }
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)didReceivePackets:(NSArray*)packets
{
    //NSLog(@"new packets: %@",packets);
    for(id packet in packets)
    {
        if([packet isKindOfClass:[TCPPacket class]])
        {
            TCPPacket *tcp = packet;
            [self.time addObject:@"Now"];
            [self.source addObject:tcp.srcIP];
            [self.destination addObject:tcp.dstIP];
            [self.protocol addObject:@"TCP"];
        }
    }
    [self.tableView reloadData];
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
