///////////////////////////////////////////////////////////////////////////////////////
//
//  IPPacket.m
//  Orca
//
//  Created by Dalton Cherry on 3/18/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "IPPacket.h"
#import <netinet/if_ether.h>
#import <netinet/ip.h>
#import <netinet/ip6.h>
#import <arpa/inet.h>

@implementation IPPacket

///////////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithPacket:(u_char *)packet packetHeader:(const struct pcap_pkthdr *)packetHeader
{
    if(self = [super initWithPacket:(u_char *)packet packetHeader:(const struct pcap_pkthdr *)packetHeader])
    {
        struct ether_header *eptr = (struct ether_header *) packet;
        
        /* check to see if we have an ip packet */
        if (ntohs(eptr->ether_type) == ETHERTYPE_IP)
        {
            char src[64];
            char dst[64];
            struct ip *iphdr = (struct ip*)(packet + ETHER_HDR_LEN);
            inet_ntop(AF_INET, &iphdr->ip_src, src, sizeof(src));
            inet_ntop(AF_INET, &iphdr->ip_dst, dst, sizeof(dst));
            self.srcIP = [[NSString alloc] initWithUTF8String:src];
            self.dstIP = [[NSString alloc] initWithUTF8String:dst];
            self.totalSize = @(htons(iphdr->ip_len));
            //int ipHeaderSize = iphdr->ip_hl*sizeof(unsigned int);
            //NSLog(@"total length: %d",iphdr->ip_len);
            
        }
        else if (ntohs(eptr->ether_type) == ETHERTYPE_IPV6)
        {
            char src[64];
            char dst[64];
            struct ip6_hdr *iphdr = (struct ip6_hdr*)(packet + ETHER_HDR_LEN);
            inet_ntop(AF_INET6, &iphdr->ip6_src, src, sizeof(src));
            inet_ntop(AF_INET6, &iphdr->ip6_dst, dst, sizeof(dst));
            //int ipHeaderSize = iphdr->ip_hl*sizeof(unsigned int);
            self.srcIP = [[NSString alloc] initWithUTF8String:src];
            self.dstIP = [[NSString alloc] initWithUTF8String:dst];
            self.totalSize = @(iphdr->ip6_plen);
        }
        else
        {
            //not sure what kind of IP version this is....
        }
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)protocolName
{
    return @"IP";
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)infoString
{
    return [NSString stringWithFormat:@"%@ -> %@",self.srcIP,self.dstIP];
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSString*)description
{
    return [NSString stringWithFormat:@"\nsrcMac: %@\ndstMac: %@\nsrcIP: %@\ndstIP: %@\n",self.srcMac,
            self.dstMac,self.srcIP,self.dstIP];
}
///////////////////////////////////////////////////////////////////////////////////////

@end
