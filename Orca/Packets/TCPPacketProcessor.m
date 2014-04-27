///////////////////////////////////////////////////////////////////////////////////////
//
//  TCPPacketProcessor.m
//  Orca
//
//  Created by Dalton Cherry on 4/15/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "TCPPacketProcessor.h"
#import "TCPPacket.h"
#import <netinet/tcp.h>

@interface TCPPacketProcessor ()

@property(nonatomic,strong)NSMutableArray *packets;
@property(nonatomic,strong)NSMutableArray *delegates;

@end

@implementation TCPPacketProcessor

///////////////////////////////////////////////////////////////////////////////////////
+(TCPPacketProcessor*)sharedProcessor
{
    static TCPPacketProcessor *processor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processor = [[TCPPacketProcessor alloc] init];
    });
    return processor;
}
///////////////////////////////////////////////////////////////////////////////////////
-(instancetype)init
{
    if(self = [super init])
    {
        self.packets = [NSMutableArray new];
        self.delegates = [NSMutableArray new];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)addPacket:(TCPPacket*)packet
{
    //we need to reassemble these packets....
    
    //NSLog(@"packet count: %ld",self.packets.count);
    //NSLog(@"main packet src: %ld dst: %ld",packet.srcPort,packet.dstPort);
//    NSMutableArray *array = [NSMutableArray arrayWithObject:packet];
//    for(TCPPacket *subPacket in self.packets)
//    {
//        //NSLog(@"check packet src: %ld dst: %ld",subPacket.srcPort,subPacket.dstPort);
//        if(packet.dstPort == subPacket.dstPort && packet.srcPort == subPacket.srcPort)
//        {
//            [array addObject:subPacket];
//            //                NSLog(@"main match: %ld",packet.sequence);
//            //                NSLog(@"found a match: %ld",subPacket.sequence);
//            //                NSLog(@"main packet: %@",packet.payloadString);
//            //                NSLog(@"sub packet: %@",subPacket.payloadString);
//        }
//    }
//    if(array)
//    {
//        //for(TCPPacket *sub in array)
//        //    NSLog(@"sub seq: %ld",sub.sequence);
//        for(TCPPacket *sub in array)
//            NSLog(@"sub payload: %@",sub.payloadString);
//        [self.packets removeObjectsInArray:array];
//    }
//    NSLog(@"count: %ld",self.packets.count);
//    [self.packets addObject:packet];
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)addDelegate:(id<TCPPacketProcessorDelegate>)delegate
{
    [self.delegates addObject:delegate];
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)removeDelegate:(id<TCPPacketProcessorDelegate>)delegate
{
    [self.delegates removeObject:delegate];
}
///////////////////////////////////////////////////////////////////////////////////////

@end
