///////////////////////////////////////////////////////////////////////////////////////
//
//  UDPPacket.m
//  Orca
//
//  Created by Dalton Cherry on 4/21/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "UDPPacket.h"
#include <netinet/udp.h>
#import <netinet/if_ether.h>
#import <netinet/ip.h>
#import <netinet/ip6.h>

@implementation UDPPacket

///////////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithPacket:(u_char *)packet packetHeader:(const struct pcap_pkthdr *)packetHeader
{
    if(self = [super initWithPacket:(u_char *)packet packetHeader:(const struct pcap_pkthdr *)packetHeader])
    {
        struct ether_header *eptr = (struct ether_header *) packet;
        int offset = ETHER_HDR_LEN;
        if (ntohs(eptr->ether_type) == ETHERTYPE_IP)
        {
            struct ip *iphdr = (struct ip*)(packet + ETHER_HDR_LEN);
            offset += iphdr->ip_hl*sizeof(unsigned int);
            
        }
        else if (ntohs(eptr->ether_type) == ETHERTYPE_IPV6)
        {
            //NSLog(@"ipv6 fail.");
            //offset += somesize...
        }
        else
        {
            NSLog(@"TCP ERROR: no idea what this is....");
            return self;
        }
        struct udphdr *udpHeader = (struct udphdr*) (packet + offset);
        NSInteger size = ntohs(udpHeader->uh_ulen);
        self.udpHeaderSize = sizeof(struct udphdr);
        offset += self.udpHeaderSize;
        offset += size;
        self.srcPort = htons(udpHeader->uh_sport);
        self.dstPort = htons(udpHeader->uh_dport);
        self.checksum = udpHeader->uh_sum;
        //u_char *buffer = (u_char*)(udpHeader+self.udpHeaderSize);
        NSInteger len = size-self.udpHeaderSize;
        if(len > 0)
        {
            self.payloadLength = len;
//            self.payloadData = [NSData dataWithBytes:buffer length:len];
//            if(self.payloadData)
//                self.payloadString = [[NSString alloc] initWithData:self.payloadData encoding:NSUTF8StringEncoding];
        }
        //NSLog(@"udp packet payload: %@",self.payloadString);
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)protocolName
{
    return @"UDP";
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)infoString
{
    return [NSString stringWithFormat:@"%ld -> %ld size=%ld",(long)self.srcPort,(long)self.dstPort,(long)self.payloadLength];
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)description
{
    return [NSString stringWithFormat:@"\nsrcMac: %@\ndstMac: %@\nsrcIP: %@\ndstIP: %@\n",self.srcMac,
            self.dstMac,self.srcIP,self.dstIP];
}
///////////////////////////////////////////////////////////////////////////////////////
-(DetailNode*)outlineNode
{
    DetailNode *root = [super outlineNode];
    DetailNode *node = [DetailNode nodeWithText:NSLocalizedString(@"UDP Header", nil)];
    [root addNode:node];
    
    DetailNode *srcPort = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Source Port", nil),self.srcPort]];
    [node addNode:srcPort];
    DetailNode *dstPort = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Destination Port", nil),self.dstPort]];
    [node addNode:dstPort];
    DetailNode *length = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Length", nil),self.payloadLength+self.udpHeaderSize]];
    [node addNode:length];
    DetailNode *checksum = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: 0x%lx",NSLocalizedString(@"Checksum", nil),self.checksum]];
    [node addNode:checksum];
    return root;
}

@end
