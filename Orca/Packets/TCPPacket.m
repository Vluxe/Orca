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

@implementation TCPPacket

///////////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithPacket:(u_char *)packet
{
    if(self = [super initWithPacket:packet])
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
            NSLog(@"ipv6 fail.");
            //offset += somesize...
        }
        else
        {
            NSLog(@"TCP ERROR: no idea what this is....");
            return self;
        }
        struct tcphdr *tcpHeader = (struct tcphdr*) (packet + offset);
        int size = tcpHeader->th_off*sizeof(unsigned int);
        offset += size;
        self.tcpSize = @(size);
        self.srcPort = @(ntohs(tcpHeader->th_sport));
        self.dstPort = @(ntohs(tcpHeader->th_dport));
        //NSLog(@"%s",(packet+offset));
        //NSLog(@"offset: %d",offset);
        //NSLog(@"total size: %@",self.totalSize);
        self.payload = [NSData dataWithBytes:(packet+(offset)) length:[self.totalSize intValue]-(offset-ETHER_HDR_LEN)];
        NSLog(@"payload: %@",[[NSString alloc] initWithData:self.payload encoding:NSUTF8StringEncoding]);
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)description
{
    return [NSString stringWithFormat:@"\nsrcMac: %@\ndstMac: %@\nsrcIP: %@\ndstIP: %@\n",self.srcMac,
            self.dstMac,self.srcIP,self.dstIP];
}
///////////////////////////////////////////////////////////////////////////////////////

@end
