//
//  XMPPMessageTimestampParser.m
//  XmppFrameworkParsers
//
//  Created by Oleksandr Dodatko on 7/27/15.
//  Copyright (c) 2015 healthjoy. All rights reserved.
//

#import "XMPPMessageTimestampParser.h"
#import "NSXMLElement+XMPP.h"

@implementation XMPPMessageTimestampParser

+ (NSDate*)parseTimestampFromXmlElement:(id)xmlElement
{
    if (nil == xmlElement)
    {
        return nil;
    }
    
    NSParameterAssert([xmlElement isKindOfClass: [NSXMLElement class]]);
    NSXMLElement* selfElement = (NSXMLElement*)xmlElement;
    
    NSXMLElement* delayElement = [[selfElement elementsForName: @"delay"] firstObject];
    NSXMLElement* xElement = [[selfElement elementsForName: @"x"] firstObject];
    
    
    
    NSXMLElement* elementWithTimestamp = nil;
    NSString* timestampFormat = nil;
    if (nil != delayElement)
    {
        elementWithTimestamp = delayElement;
        timestampFormat = @"yyyy-MM-dd'T'hh:mm:ss.SSSZ";
    }
    else
    {
        elementWithTimestamp = xElement;
        timestampFormat = @"yyyy-MM-dd'T'hh:mm:ss";
    }
    
    
    if (nil != elementWithTimestamp)
    {
        // TODO : cache NSDateFormatter object for performance
        NSLocale* posixLocale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
        NSCalendar* gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        NSDateFormatter* df = [NSDateFormatter new];
        {
            gregorianCal.locale = posixLocale;
            df.locale = posixLocale;
            df.calendar = gregorianCal;
        }
        df.dateFormat = timestampFormat;
        
        
        NSString* strResult = [[elementWithTimestamp attributeForName: @"stamp"] stringValue];
        NSDate* result = [df dateFromString: strResult];
        
        return result;
    }
    
    return nil;
}

@end
