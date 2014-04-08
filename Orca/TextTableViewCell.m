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
    /*if(!object)
        return 22;
    NSString *text = object;
    NSRect textSize = [text boundingRectWithSize:NSMakeSize(tableView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [NSFont systemFontOfSize:15]}];
    return textSize.size.height;*/
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithIdentifier:(NSString*)identifier
{
    if(self = [super initWithIdentifier:identifier])
    {
        self.textLabel = [[ACLabel alloc] init];
        //[self.textLabel setBordered:NO];
        //[self.textLabel setBezeled:NO];
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
    self.textLabel.text = object;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSelected:(BOOL)selected
{
    if(selected)
        self.textLabel.textColor = [NSColor whiteColor];
    else
        self.textLabel.textColor = [NSColor blackColor];
}
////////////////////////////////////////////////////////////////////////////////////////////////////

@end
