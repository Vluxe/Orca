///////////////////////////////////////////////////////////////////////////////////////
//
//  NSDate+OrcaDate.m
//  Orca
//
//  Created by Dalton Cherry on 4/8/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////

#import "NSDate+OrcaDate.h"

@implementation NSDate (OrcaDate)

///////////////////////////////////////////////////////////////////////////////////////
NSLocale* CurrentLocale()
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
    if (languages.count > 0)
    {
        NSString* currentLanguage = [languages objectAtIndex:0];
        return [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    }
    else
        return [NSLocale currentLocale];
}
///////////////////////////////////////////////////////////////////////////////////////
- (NSString*)formatTime
{
    static NSDateFormatter* formatter = nil;
    if (nil == formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"h:mm a";
        formatter.locale = CurrentLocale();
    }
    return [formatter stringFromDate:self];
}
///////////////////////////////////////////////////////////////////////////////////////

@end
