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
#include <pthread.h>

@implementation PacketCapture

static pthread_t pthread;
static pcap_t* descr;
///////////////////////////////////////////////////////////////////////////////////////
- (void)getInterfaces
{
    char *dev; /* name of the device to use */
    char *net; /* dot notation of the network address */
    char *mask;/* dot notation of the network mask    */
    int ret;   /* return code */
    char errbuf[PCAP_ERRBUF_SIZE];
    bpf_u_int32 netp; /* ip          */
    bpf_u_int32 maskp;/* subnet mask */
    struct in_addr addr;
    
    /* ask pcap to find a valid device for use to sniff on */
    dev = pcap_lookupdev(errbuf);
    
    /* error checking */
    if(dev == NULL)
    {
        NSLog(@"%s\n",errbuf);
        exit(1);
    }
    
    /* print out device name */
    NSLog(@"DEV: %s\n",dev);
    
    /* ask pcap for the network address and mask of the device */
    ret = pcap_lookupnet(dev,&netp,&maskp,errbuf);
    
    if(ret == -1)
    {
        NSLog(@"%s\n",errbuf);
        exit(1);
    }
    
    /* get the network address in a human readable form */
    addr.s_addr = netp;
    net = inet_ntoa(addr);
    
    if(net == NULL)/* thanks Scott :-P */
    {
        perror("inet_ntoa");
        exit(1);
    }
    
    NSLog(@"NET: %s\n",net);
    
    /* do the same as above for the device's mask */
    addr.s_addr = maskp;
    mask = inet_ntoa(addr);
    
    if(mask == NULL)
    {
        perror("inet_ntoa");
        exit(1);
    }
    
    NSLog(@"MASK: %s\n",mask);
}
///////////////////////////////////////////////////////////////////////////////////////
- (void)capturePackets
{
    char *dev;
    char errbuf[PCAP_ERRBUF_SIZE];
    
    /* grab a device to peak into... */
    dev = pcap_lookupdev(errbuf);
    
    if(dev == NULL)
    {
        NSLog(@"%s\n",errbuf);
        exit(1);
    }
    
    NSLog(@"DEV: %s\n",dev);
    
    descr = pcap_create(dev, errbuf);
    
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

    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
    //});
    pthread_create(&pthread, NULL, captureLoop, (void*)descr);
}
///////////////////////////////////////////////////////////////////////////////////////
void* captureLoop(void *descr)
{
    pcap_loop(descr, 0, packet_callback, NULL);
    NSLog(@"loop finished?");
    return NULL;
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
        
        NSLog(@"ip header size: %d", ipHeaderSize);
        NSLog(@"total length: %d",iphdr->ip_len);
        if(iphdr->ip_p == IPPROTO_UDP)
            NSLog(@"UDP action!");
        else if(iphdr->ip_p == IPPROTO_TCP) {
            NSLog(@"TCP action! ");
            struct tcphdr *tcpHeader = (struct tcphdr*) (iphdr + ipHeaderSize);
            NSLog(@"src address is: %s and dst address is: %s\n", src, dst);
            sport = ntohs(tcpHeader->th_sport);
            dport = ntohs(tcpHeader->th_dport);
            NSLog(@"src address is: %s:%d and dst address is: %s:%d\n", src, sport, dst, dport);
        }
    }
    else if (ntohs (eptr->ether_type) == ETHERTYPE_ARP)
    {
        NSLog(@"Ethernet type hex:%x dec:%d is an ARP packet\n",
               ntohs(eptr->ether_type),
               ntohs(eptr->ether_type));
    }
    else
        NSLog(@"Ethernet type %x not IP\n", ntohs(eptr->ether_type));
}
///////////////////////////////////////////////////////////////////////////////////////
@end
