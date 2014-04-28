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
#import <pcap.h>

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
        NSInteger time = self.packetHeader->ts.tv_sec;
        self.date = [NSDate dateWithTimeIntervalSince1970:time];
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
-(DetailNode*)outlineNode
{
    DetailNode *root = [DetailNode new];
    DetailNode *node = [DetailNode nodeWithText:NSLocalizedString(@"Ethernet Header", nil)];
    [root addNode:node];
    
    DetailNode *srcMac = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Source", nil),self.srcMac]];
    [node addNode:srcMac];
    DetailNode *dstMac = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Destination", nil),self.dstMac]];
    [node addNode:dstMac];
    
    return root;
}
///////////////////////////////////////////////////////////////////////////////////////

@end
