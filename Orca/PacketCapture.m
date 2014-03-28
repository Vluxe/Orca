///////////////////////////////////////////////////////////////////////////////////////
//
//  PacketCapture.m
//  Orca
//
//  Created by Austin Cherry on 3/2/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "PacketCapture.h"
#import <stdio.h>
#import <stdlib.h>
#import <pcap.h>
#import <errno.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netinet/if_ether.h>
#import <netinet/ip.h>
#import <netinet/ip6.h>
#import <netinet/tcp.h>
#import <netinet/udp.h>
#import "TCPPacket.h"

@implementation PacketCapture

static pcap_t* descr;
static BOOL isCapture;
///////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)getInterfaces
{
    NSMutableArray *array = [NSMutableArray array];
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_if_t *devices;
    int ret = pcap_findalldevs(&devices, errbuf);
    
    if(ret != 0)
    {
        NSLog(@"[ERROR] %s", errbuf);
        return nil;
    }
    
    struct pcap_if *device = devices;
    while(device)
    {
        [array addObject:[NSString stringWithUTF8String:device->name]];
        device = device->next;
    }
    
    pcap_freealldevs(devices);
    return [array copy];
}
///////////////////////////////////////////////////////////////////////////////////////
- (void)capturePackets:(NSString *)interface
{
    isCapture = YES;
    char errbuf[PCAP_ERRBUF_SIZE];
    
    descr = pcap_create([interface UTF8String], errbuf);
    
    if(descr == NULL)
    {
        NSLog(@"pcap_open(): %s\n",errbuf);
        exit(1);
    }
    
    int act = pcap_activate(descr);
    
    if(act != 0)
    {
        NSLog(@"pcap_activate(): %s\n",errbuf);
        exit(1);
    }

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        @autoreleasepool {
            pcap_loop(descr, 0, packet_callback, NULL);
        }
    });
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)stopCapturing
{
    isCapture = NO;
}
///////////////////////////////////////////////////////////////////////////////////////
void packet_callback(u_char *useless,const struct pcap_pkthdr *pkthdr,const u_char *packet)
{
    if(!isCapture)
    {
        if(descr)
        {
            NSLog(@"stop capturing...");
            pcap_breakloop(descr);
            pcap_close(descr);
            descr = nil;
        }
    }
    if(packet == NULL)
    {
        NSLog(@"Didn't grab packet\n");
        return;
    }
    
    /* lets start with the ether header... */
    struct ether_header *eptr = (struct ether_header *) packet;
    
    /* check to see if we have an ip packet */
    if (ntohs(eptr->ether_type) == ETHERTYPE_IP)
    {
        struct ip *iphdr = (struct ip*)(packet + ETHER_HDR_LEN);
        
        if(iphdr->ip_p == IPPROTO_UDP)
            NSLog(@"UDP action!");
        else if(iphdr->ip_p == IPPROTO_TCP)
        {
            NSLog(@"TCP action! ");
            TCPPacket *tcpObject = [[TCPPacket alloc] initWithPacket:(u_char*)packet];
            NSLog(@"tcpObject: %@",tcpObject);
        }
    }
    else if (ntohs(eptr->ether_type) == ETHERTYPE_IPV6)
    {
        struct ip6_hdr *iphdr = (struct ip6_hdr*)(packet + ETHER_HDR_LEN);
        if(iphdr->ip6_nxt == IPPROTO_UDP)
        {
            NSLog(@"UDP v6 action!");
            //IPPacket *pacObject = [[IPPacket alloc] initWithPacket:(u_char*)packet];
            //NSLog(@"%@",pacObject);
        }
        else if(iphdr->ip6_nxt == IPPROTO_TCP)
        {
            TCPPacket *tcpObject = [[TCPPacket alloc] initWithPacket:(u_char*)packet];
            NSLog(@"tcpObject v6: %@",tcpObject);
        }
        
    }
    else if (ntohs (eptr->ether_type) == ETHERTYPE_ARP)
        NSLog(@"Ethernet type hex:%x dec:%d is an ARP packet\n", ntohs(eptr->ether_type), ntohs(eptr->ether_type));
    else
        NSLog(@"Ethernet type %x not IP\n", ntohs(eptr->ether_type));
}
///////////////////////////////////////////////////////////////////////////////////////
-(BOOL)isCapturing
{
    return isCapture;
}
///////////////////////////////////////////////////////////////////////////////////////
@end
