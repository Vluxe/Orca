///////////////////////////////////////////////////////////////////////////////////////
//
//  AppDelegate.h
//  Orca
//
//  Created by Austin Cherry on 3/2/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>
#import "PacketCapture.h"
#import "ACTableSource.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,ACTableSourceDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic,strong)PacketCapture *pcap;

@property (nonatomic,strong)IBOutlet NSPopUpButton *popButton;
@property (nonatomic,strong)IBOutlet NSToolbarItem *captureButton;
@property (nonatomic,strong)IBOutlet NSTableView *tableView;
@property (nonatomic,strong)ACTableSource *dataSource;

@end
