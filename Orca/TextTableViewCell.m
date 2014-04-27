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
    return 33;
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
        self.textLabel.font = [NSFont systemFontOfSize:15];
        //self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:self.textLabel];
        /*NSLayoutConstraint *width =[NSLayoutConstraint
                                    constraintWithItem:self.textLabel
                                    attribute:NSLayoutAttributeWidth
                                    relatedBy:0
                                    toItem:self
                                    attribute:NSLayoutAttributeWidth
                                    multiplier:1.0
                                    constant:0];
        NSLayoutConstraint *height =[NSLayoutConstraint
                                     constraintWithItem:self.textLabel
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:0
                                     toItem:self
                                     attribute:NSLayoutAttributeHeight
                                     multiplier:1.0
                                     constant:0];
        NSLayoutConstraint *top = [NSLayoutConstraint
                                   constraintWithItem:self.textLabel
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:0.f];
        NSLayoutConstraint *leading = [NSLayoutConstraint
                                       constraintWithItem:self.textLabel
                                       attribute:NSLayoutAttributeLeading
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self
                                       attribute:NSLayoutAttributeLeading
                                       multiplier:1.0f
                                       constant:0.f];
        [self addConstraint:width];
        [self addConstraint:height];
        [self addConstraint:top];
        [self addConstraint:leading];*/
    }
    return self;
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
