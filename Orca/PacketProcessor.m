///////////////////////////////////////////////////////////////////////////////////////
//
//  PacketProcessor.m
//  Orca
//
//  Created by Dalton Cherry on 4/7/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "PacketProcessor.h"
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
#import "UDPPacket.h"

@interface PacketProcessor ()

@property(nonatomic,assign)pcap_t* descr;
@property(nonatomic, strong)NSMutableArray *allPackets;
@property(nonatomic, strong)NSMutableArray *bufferPackets;
@property(nonatomic, strong)NSDate *lastDate;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, copy)NSString *searchQuery;

@end

@implementation PacketProcessor

///////////////////////////////////////////////////////////////////////////////////////
+(PacketProcessor*)sharedProcessor
{
    static PacketProcessor *processor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processor = [[PacketProcessor alloc] init];
    });
    return processor;
}
///////////////////////////////////////////////////////////////////////////////////////
+(NSArray *)getInterfaces
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
        Interface *interface = [Interface new];
        interface.name = [NSString stringWithUTF8String:device->name];
        NSMutableArray *collect = [NSMutableArray new];
        //for some reason we need to skip to first address in the link list as it is always bogus.
        struct pcap_addr *address = device->addresses->next;
        while(address)
        {
            char addr[64];
            int type = AF_INET;
            if(address->addr->sa_family == AF_INET6)
                type = AF_INET6;
            inet_ntop(type, &(((struct sockaddr_in *)address->addr)->sin_addr), addr, sizeof(addr));
            [collect addObject:[NSString stringWithUTF8String:addr]];
            address = address->next;
        }
        interface.addresses = collect;
        if(interface.addresses.count > 0)
            [array addObject:interface];
        device = device->next;
    }
    
    pcap_freealldevs(devices);
    return [array copy];
}
///////////////////////////////////////////////////////////////////////////////////////
-(instancetype)init
{
    if(self = [super init])
    {
        self.allPackets = [[NSMutableArray alloc] init];
        self.bufferPackets = [[NSMutableArray alloc] init];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////
- (void)startCapture:(Interface*)interface
{
    char errbuf[PCAP_ERRBUF_SIZE];
    
    self.descr = pcap_create([interface.name UTF8String], errbuf);
    
    if(self.descr == NULL)
    {
        NSLog(@"pcap_open(): %s\n",errbuf);
        return;
    }
    
    int act = pcap_activate(self.descr);
    
    if(act != 0)
    {
        NSLog(@"pcap_activate(): %s\n",errbuf);
        return;
    }
    _isCapturing = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(checkPackets)
                                                userInfo:nil repeats:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        @autoreleasepool {
            pcap_loop(self.descr, 0, packet_callback, NULL);
        }
    });
}
///////////////////////////////////////////////////////////////////////////////////////
void packet_callback(u_char *useless,const struct pcap_pkthdr *pkthdr,const u_char *packet)
{
    PacketProcessor *processor = [PacketProcessor sharedProcessor];
//    if(!processor.isCapturing)
//    {
//        if(processor.descr)
//        {
//            NSLog(@"stop capturing...");
//            pcap_breakloop(processor.descr);
//            //pcap_close(processor.descr);
//            processor.descr = nil;
//        }
//        return;
//    }
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
        {
            //NSLog(@"UDP action!");
            UDPPacket *udpObject = [[UDPPacket alloc] initWithPacket:(u_char*)packet packetHeader:pkthdr];
            [processor.allPackets addObject:udpObject];
            [processor.bufferPackets addObject:udpObject];
        }
        else if(iphdr->ip_p == IPPROTO_TCP)
        {
            //NSLog(@"TCP action! ");
            TCPPacket *tcpObject = [[TCPPacket alloc] initWithPacket:(u_char*)packet packetHeader:pkthdr];
            [processor.allPackets addObject:tcpObject];
            [processor.bufferPackets addObject:tcpObject];
            //NSLog(@"tcpObject: %@",tcpObject);
        }
    }
    else if (ntohs(eptr->ether_type) == ETHERTYPE_IPV6)
    {
        struct ip6_hdr *iphdr = (struct ip6_hdr*)(packet + ETHER_HDR_LEN);
        if(iphdr->ip6_nxt == IPPROTO_UDP)
        {
            //NSLog(@"UDP v6 action!");
            //IPPacket *pacObject = [[IPPacket alloc] initWithPacket:(u_char*)packet];
            //NSLog(@"%@",pacObject);
        }
        else if(iphdr->ip6_nxt == IPPROTO_TCP)
        {
            //TCPPacket *tcpObject = [[TCPPacket alloc] initWithPacket:(u_char*)packet packetHeader:pkthdr];
            //[processor.allPackets addObject:tcpObject];
            //[processor.bufferPackets addObject:tcpObject];
            //NSLog(@"tcpObject v6: %@",tcpObject);
        }
        
    }
    else if (ntohs (eptr->ether_type) == ETHERTYPE_ARP)
        NSLog(@"Ethernet type hex:%x dec:%d is an ARP packet\n", ntohs(eptr->ether_type), ntohs(eptr->ether_type));
    else
        NSLog(@"Ethernet type %x not IP\n", ntohs(eptr->ether_type));
    //NSLog(@"time: %f",[processor.lastDate timeIntervalSinceNow]);
    [processor checkPackets];
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)checkPackets
{
    if(!self.lastDate || [self.lastDate timeIntervalSinceNow] < -0.5)
    {
        NSArray *copyPackets = [self.bufferPackets copy];
        //filter the packets if there is a search term
        NSArray *filterPackets = [self filter:copyPackets query:self.searchQuery];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didReceivePackets:filterPackets];
            //NSLog(@"buffer packets: %@",copyPackets);
        });
        [self.bufferPackets removeAllObjects];
        self.lastDate = [NSDate date];
    }
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)stopCapture
{
    [self.timer invalidate];
    self.timer = nil;
    if(self.isCapturing)
    {
        _isCapturing = NO;
    }
    pcap_breakloop(self.descr);
    self.descr = nil;
    //check one last time to ensure the buffer is clear
    //[self checkPackets];
}
///////////////////////////////////////////////////////////////////////////////////////
- (void)saveCapture:(NSURL *)fileURL
{
    if(self.descr)
    {
        pcap_dumper_t *dump = pcap_dump_open(self.descr, [[fileURL path] UTF8String]);
        for(EthernetPacket *packet in self.allPackets)
            pcap_dump((u_char *)dump, packet.packetHeader, packet.rawData);
        pcap_dump_flush(dump);
    }
}
///////////////////////////////////////////////////////////////////////////////////////
- (void)openCapture:(NSURL *)fileURL
{
    if(self.isCapturing)
        [self stopCapture];
    [self.allPackets removeAllObjects];
    char errbuf[PCAP_ERRBUF_SIZE];
    self.descr = pcap_open_offline([[fileURL path] UTF8String], errbuf);
    if(self.descr == NULL)
    {
        NSLog(@"[ERROR] %s", errbuf);
        return;
    }
    
    _isCapturing = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        @autoreleasepool {
            int r = pcap_loop(self.descr, 0, packet_callback, NULL);
            if(r < 0)
                return;
        }
    });
}
///////////////////////////////////////////////////////////////////////////////////////
-(EthernetPacket*)packetAtIndex:(NSInteger)index
{
    NSArray *filterPackets = [self filter:self.allPackets query:self.searchQuery];
    return filterPackets[index];
}
///////////////////////////////////////////////////////////////////////////////////////
-(void)runSearch:(NSString*)query
{
    query = [query lowercaseString];
    self.searchQuery = query;
    //this could be a long opt and this array is likely to change, so let's get a copy to work with
    NSArray *packets = [self.allPackets copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        @autoreleasepool {
            NSArray *searchPackets = [self filter:packets query:query];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didSearchPackets:searchPackets];
            });
        }
    });
}
///////////////////////////////////////////////////////////////////////////////////////
-(NSArray*)filter:(NSArray*)packets query:(NSString*)query
{
    //we should probably add some better filter logic in here.
    //experssions like ip.src or ip.dst or even ip.src == 192.168.1.1 && tcp should be supported
    
    NSMutableArray *collect = nil;
    if(query.length == 0)
        collect = (NSMutableArray*)packets;
    else
    {
        collect = [NSMutableArray array];
        for(EthernetPacket *packet in packets)
        {
            if([[packet.protocolName lowercaseString] isEqualToString:query])
                [collect addObject:packet];
            if([packet isKindOfClass:[IPPacket class]])
            {
                IPPacket *ipPacket = (IPPacket*)packet;
                if([ipPacket.srcIP hasPrefix:query])
                    [collect addObject:packet];
                if([ipPacket.dstIP hasPrefix:query])
                    [collect addObject:packet];
            }
            
            if([packet isKindOfClass:[UDPPacket class]])
            {
                //do port numbers
            }
            else if([packet isKindOfClass:[TCPPacket class]])
            {
                //do port, seq, window, and ack, numbers.
            }
        }
    }
    return collect;
}
///////////////////////////////////////////////////////////////////////////////////////
@end
