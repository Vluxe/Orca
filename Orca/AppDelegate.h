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
#import "ACTableSource.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,ACTableSourceDelegate,NSOpenSavePanelDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic,strong)IBOutlet NSPopUpButton *popButton;
@property (nonatomic,strong)IBOutlet NSToolbarItem *captureButton;
@property (nonatomic,strong)IBOutlet NSTableView *tableView;
@property (nonatomic,strong)ACTableSource *dataSource;
@property (nonatomic,strong)NSMutableArray *interfaces;

@property (nonatomic,strong)NSMutableArray *time;
@property (nonatomic,strong)NSMutableArray *source;
@property (nonatomic,strong)NSMutableArray *destination;
@property (nonatomic,strong)NSMutableArray *protocol;

@end
