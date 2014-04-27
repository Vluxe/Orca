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
        int size = ntohs(udpHeader->uh_ulen);
        offset += sizeof(struct udphdr);
        self.udpSize = size;
        self.srcPort = htons(udpHeader->uh_sport);
        self.dstPort = htons(udpHeader->uh_dport);
        //NSLog(@"%s",(packet+offset));
        //NSLog(@"offset: %d",offset);
        //NSLog(@"total size: %@",self.totalSize);
        self.payloadData = [NSData dataWithBytes:(packet+(offset)) length:self.totalSize-(offset-ETHER_HDR_LEN)];
        if(self.payloadData)
            self.payloadString = [[NSString alloc] initWithData:self.payloadData encoding:NSUTF8StringEncoding];
        NSLog(@"udp packet payload: %@",self.payloadString);
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
    return [NSString stringWithFormat:@"%ld -> %ld size=%ld",(long)self.srcPort,(long)self.dstPort,(long)self.udpSize];
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)description
{
    return [NSString stringWithFormat:@"\nsrcMac: %@\ndstMac: %@\nsrcIP: %@\ndstIP: %@\n",self.srcMac,
            self.dstMac,self.srcIP,self.dstIP];
}

@end
