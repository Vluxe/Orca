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
#import <netinet/tcp.h>
#import <netinet/udp.h>

@implementation PacketCapture

static pcap_t* descr;
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
    
    return [array copy];
}
///////////////////////////////////////////////////////////////////////////////////////
- (void)capturePackets:(NSString *)interface
{
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
        pcap_loop(descr, 0, packet_callback, NULL);
    });
}
///////////////////////////////////////////////////////////////////////////////////////
void packet_callback(u_char *useless,const struct pcap_pkthdr *pkthdr,const u_char *packet)
{
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
        char src[64];
        char dst[64];
        int sport = 0;
        int dport = 0;
        struct ip *iphdr = (struct ip*)(packet + ETHER_HDR_LEN);
        inet_ntop(AF_INET, &iphdr->ip_src, src, sizeof(src));
        inet_ntop(AF_INET, &iphdr->ip_dst, dst, sizeof(dst));
        int ipHeaderSize = iphdr->ip_hl*sizeof(unsigned int);
        NSLog(@"ip_tos: %u", iphdr->ip_tos);
        
        NSLog(@"total length: %d",iphdr->ip_len);
        if(iphdr->ip_p == IPPROTO_UDP)
            NSLog(@"UDP action!");
        else if(iphdr->ip_p == IPPROTO_TCP)
        {
            NSLog(@"TCP action! ");
            struct tcphdr *tcpHeader = (struct tcphdr*) (iphdr + ipHeaderSize);
            sport = ntohs(tcpHeader->th_sport);
            dport = ntohs(tcpHeader->th_dport);
            NSLog(@"src address is: %s:%d and dst address is: %s:%d\n", src, sport, dst, dport);
        }
    }
    else if (ntohs (eptr->ether_type) == ETHERTYPE_ARP)
        NSLog(@"Ethernet type hex:%x dec:%d is an ARP packet\n", ntohs(eptr->ether_type), ntohs(eptr->ether_type));
    else
        NSLog(@"Ethernet type %x not IP\n", ntohs(eptr->ether_type));
}
///////////////////////////////////////////////////////////////////////////////////////
@end
