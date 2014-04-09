///////////////////////////////////////////////////////////////////////////////////////
//
//  EthernetPacket.m
//  Orca
//
//  Created by Dalton Cherry on 3/18/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "EthernetPacket.h"
#import <netinet/if_ether.h>

@implementation EthernetPacket

///////////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithPacket:(u_char*)packet packetHeader:(const struct pcap_pkthdr *)packetHeader
{
    if(self = [super init])
    {
        self.rawData = packet;
        struct ether_header *eptr = (struct ether_header *) packet;
        self.srcMac = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                       eptr->ether_shost[0],eptr->ether_shost[1],eptr->ether_shost[2],
                       eptr->ether_shost[3],eptr->ether_shost[4],eptr->ether_shost[5]];
        self.dstMac = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                       eptr->ether_dhost[0],eptr->ether_dhost[1],eptr->ether_dhost[2],
                       eptr->ether_dhost[3],eptr->ether_dhost[4],eptr->ether_dhost[5]];
        self.packetHeader = packetHeader;
        self.date = [NSDate date];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)protocolName
{
    return @"Undefined";
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)infoString
{
    return [NSString stringWithFormat:@"%@ -> %@",self.srcMac,self.dstMac];
}
///////////////////////////////////////////////////////////////////////////////////////

@end
