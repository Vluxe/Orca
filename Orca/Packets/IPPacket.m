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
            self.totalSize = htons(iphdr->ip_len);
            self.IPHeaderSize = iphdr->ip_hl*sizeof(unsigned int);
            self.version = 4;
            self.IPChecksum = iphdr->ip_sum;
            self.IPTTL = iphdr->ip_ttl;
            self.IPIdent = iphdr->ip_id;
            self.IPFlags = iphdr->ip_off;
            //should we do the protocol?
            //ip_p
            
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
            self.totalSize = iphdr->ip6_plen;
            self.version = 6;
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
-(DetailNode*)outlineNode
{
    DetailNode *root = [super outlineNode];
    DetailNode *node = [DetailNode nodeWithText:NSLocalizedString(@"IP Header", nil)];
    [root addNode:node];

    DetailNode *version = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Version", nil),self.version]];
    [node addNode:version];
    DetailNode *headerLen = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Header Length", nil),self.IPHeaderSize]];
    [node addNode:headerLen];
    DetailNode *totalSize = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Total Length", nil),self.totalSize]];
    [node addNode:totalSize];
    DetailNode *ident = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: 0x%lx (%ld)",NSLocalizedString(@"Identification", nil),
                                                  self.IPIdent,self.IPIdent]];
    [node addNode:ident];
    DetailNode *flags = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: 0x%lx",NSLocalizedString(@"Flags", nil),self.IPFlags]];
    [node addNode:flags];
    DetailNode *ttl = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"Time To Live", nil),self.IPTTL]];
    [node addNode:ttl];
    DetailNode *checksum = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: 0x%lx",NSLocalizedString(@"Header Checksum", nil),self.IPChecksum]];
    [node addNode:checksum];
    DetailNode *srcIP = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Source", nil),self.srcIP]];
    [node addNode:srcIP];
    DetailNode *dstIP = [DetailNode nodeWithText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Destination", nil),self.dstIP]];
    [node addNode:dstIP];
    return root;
}
///////////////////////////////////////////////////////////////////////////////////////

@end
