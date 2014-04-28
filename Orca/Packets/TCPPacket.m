///////////////////////////////////////////////////////////////////////////////////////
//
//  TCPPacket.m
//  Orca
//
//  Created by Austin Cherry on 3/6/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "TCPPacket.h"
#import <netinet/tcp.h>
#import <netinet/if_ether.h>
#import <netinet/ip.h>
#import <netinet/ip6.h>
#import "TCPPacketProcessor.h"

@interface TCPPacket ()

@end

@implementation TCPPacket

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
        struct tcphdr *tcpHeader = (struct tcphdr*) (packet + offset);
        NSInteger size = tcpHeader->th_off*sizeof(unsigned int);
        offset += size;
        self.tcpHeaderSize = size;
        self.flags = tcpHeader->th_flags;
        self.sequence = tcpHeader->th_seq;
        self.srcPort = ntohs(tcpHeader->th_sport);
        self.dstPort = ntohs(tcpHeader->th_dport);
        self.checksum = tcpHeader->th_sum;
        //u_char *buffer = (u_char*)(tcpHeader+size);
        NSInteger len = self.totalSize-(self.IPHeaderSize+self.tcpHeaderSize);
        if(len > 0)
        {
            self.payloadLength = len;
//            self.payloadData = [NSData dataWithBytes:buffer length:len];
//            if(self.payloadData)
//                self.payloadString = [[NSString alloc] initWithData:self.payloadData encoding:NSUTF8StringEncoding];
//            TCPPacketProcessor *processor = [TCPPacketProcessor sharedProcessor];
//            [processor addPacket:self];
        }
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)protocolName
{
    return @"TCP";
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)infoString
{
    return [NSString stringWithFormat:@"%ld -> %ld Seq=%ld",(long)self.srcPort,(long)self.dstPort,(long)self.sequence];
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
    DetailNode *node = [DetailNode nodeWithText:NSLocalizedString(@"TCP Header", nil)];
    [root addNode:node];
    
    DetailNode *srcPort = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Source Port", nil),self.srcPort]];
    [node addNode:srcPort];
    DetailNode *dstPort = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Destination Port", nil),self.dstPort]];
    [node addNode:dstPort];
    DetailNode *seq = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Sequence", nil),self.sequence]];
    [node addNode:seq];
    DetailNode *headerLen = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Header Length", nil),self.tcpHeaderSize]];
    [node addNode:headerLen];
    DetailNode *flags = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: 0x%lx",NSLocalizedString(@"Flags", nil),self.flags]];
    [node addNode:flags];
    DetailNode *window = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Window", nil),self.window]];
    [node addNode:window];
    DetailNode *checksum = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: 0x%lx",NSLocalizedString(@"Checksum", nil),self.checksum]];
    [node addNode:checksum];
    //options
    return root;
}
///////////////////////////////////////////////////////////////////////////////////////

@end
