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
#import "NSDate+OrcaDate.h"
#import "TCPPacketProcessor.h"

@implementation AppDelegate

///////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.interfaces = [[NSMutableArray alloc] initWithArray:[PacketProcessor getInterfaces]];
    NSMutableArray *collect = [NSMutableArray arrayWithCapacity:self.interfaces.count];
    for(Interface *inter in self.interfaces)
        [collect addObject:inter.displayName];
    [self.popButton addItemsWithTitles:collect];
    TCPPacketProcessor *processor = [TCPPacketProcessor sharedProcessor];
    [processor addDelegate:(id<TCPPacketProcessorDelegate>)self];
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.tableDataSource = [[ACTableSource alloc] init];
    self.tableDataSource.delegate = self;
    self.tableView.dataSource = self.tableDataSource;
    self.tableView.delegate = self.tableDataSource;
    
    self.outlineDataSource = [[ACOutlineSource alloc] init];
    self.outlineDataSource.delegate = self;
    self.outlineView.dataSource = self.outlineDataSource;
    self.outlineView.delegate = self.outlineDataSource;
    
    self.time = [NSMutableArray new];
    self.source = [NSMutableArray new];
    self.destination = [NSMutableArray new];
    self.protocol = [NSMutableArray new];
    self.info = [NSMutableArray new];
    
    [self.tableDataSource bindArrays:@[self.time,self.source,self.destination,self.protocol,self.info]
                    toTableView:self.tableView];
    
    //fake test!!!
//    for(int i = 0; i < 10; i++)
//    {
//        [self.time addObject:@"7:51 AM"];
//        [self.source addObject:@"10.16.43.120"];
//        [self.destination addObject:@"69.87.134.123"];
//        [self.protocol addObject:@"HTTP"];
//        [self.info addObject:@"random data to fill this with"];
//    }
//    [self.tableView reloadData];
}
///////////////////////////////////////////////////////////////////////////////////////
-(IBAction)startCapture:(id)sender
{
    PacketProcessor *processor = [PacketProcessor sharedProcessor];
    processor.delegate = (id<PacketProcessorDelegate>)self;
    if(processor.isCapturing)
    {
        NSLog(@"stopping capture");
        self.captureButton.image = [NSImage imageNamed:NSImageNameRightFacingTriangleTemplate];
        [processor stopCapture];
    }
    else
    {
        self.captureButton.image = [NSImage imageNamed:NSImageNameStopProgressTemplate];
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
        IPPacket *ipPacket = packet;
        [self.time addObject:[ipPacket.date formatTime]];
        [self.source addObject:ipPacket.srcIP];
        [self.destination addObject:ipPacket.dstIP];
        [self.protocol addObject:[ipPacket protocolName]];
        [self.info addObject:[ipPacket infoString]];
    }
    [self.tableView reloadData];
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)didAssemblePacket:(TCPPacket*)packet
{
    NSLog(@"we got a newly assembled packet!");
}
///////////////////////////////////////////////////////////////////////////////////////
-(IBAction)openCapture:(id)sender
{
    PacketProcessor *processor = [PacketProcessor sharedProcessor];
    NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
    [openPanel setCanChooseFiles:YES];
    [openPanel setDelegate:self];
    if([openPanel runModal] == NSOKButton)
    {
        NSURL *selectedFileName = [openPanel URL];
        [processor openCapture:selectedFileName];
    }
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)didSelectRow:(NSArray*)objects atIndex:(NSInteger)row
{
    NSLog(@"selected: %@",objects);
    PacketProcessor *processor = [PacketProcessor sharedProcessor];
    IPPacket *packet = (IPPacket*)[processor packetAtIndex:row];
    NSLog(@"packet: %@",packet);
    self.outlineDataSource.rootNode = [packet outlineNode];
    [self.outlineView reloadData];
}
///////////////////////////////////////////////////////////////////////////////////////
-(BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url
{
    NSError *error = nil;
    NSNumber *isDirectory;
    if([[url pathExtension] isEqualToString:@"pcap"])
        return YES;
    else if([url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error])
    {
        if([isDirectory boolValue])
            return YES;
        else
            return NO;
    }
    return NO;
}
///////////////////////////////////////////////////////////////////////////////////////
-(Class)classForObject:(id)object
{
    return [TextTableViewCell class];
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc
{
    self.outlineDataSource = nil;
    self.tableDataSource = nil;
}
///////////////////////////////////////////////////////////////////////////////////////


@end
