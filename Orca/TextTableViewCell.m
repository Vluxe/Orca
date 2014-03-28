///////////////////////////////////////////////////////////////////////////////////////
//
//  TextTableViewCell.m
//  Orca
//
//  Created by Dalton Cherry on 3/27/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "TextTableViewCell.h"

@implementation TextTableViewCell

////////////////////////////////////////////////////////////////////////////////////////////////////
+(CGFloat)tableView:(NSTableView*)tableView rowHeightForObject:(id)object
{
    return 22;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithIdentifier:(NSString*)identifier
{
    if(self = [super initWithIdentifier:identifier])
    {
        self.textLabel = [[NSTextField alloc] init];
        [self.textLabel setBordered:NO];
        [self.textLabel setBezeled:NO];
        self.textLabel.backgroundColor = [NSColor clearColor];
        [self addSubview:self.textLabel];
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)layout
{
    [super layout];
    self.textLabel.frame = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setObject:(id)object
{
    self.textLabel.stringValue = object;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSelected:(BOOL)selected
{
    if(selected)
        self.textLabel.textColor = [NSColor whiteColor];
    else
        self.textLabel.textColor = [NSColor blackColor];
}

@end
