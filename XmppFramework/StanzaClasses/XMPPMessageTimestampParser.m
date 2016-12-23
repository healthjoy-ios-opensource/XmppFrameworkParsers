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
        timestampFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSz";
    }
    else
    {
        elementWithTimestamp = xElement;
        timestampFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    }
    
    
    if (nil != elementWithTimestamp)
    {
        // TODO : cache NSDateFormatter object for performance
        NSLocale* posixLocale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
        NSCalendar* gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        NSDateFormatter* df = [NSDateFormatter new];
        {
            gregorianCal.locale = posixLocale;
            [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
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

+ (NSString*)parseIdFromXmlMessage:(id)xmlElement
{
    NSXMLElement* castedMessage = (NSXMLElement*)xmlElement;
    if (nil == xmlElement)
    {
        return nil;
    }
    
    NSString* result = [self parseIdFromXmlElement: xmlElement];
    if (nil != result)
    {
        return result;
    }
 
    
    // recursive calls follow
    NSXMLElement* archivedElement = [[castedMessage elementsForName: @"archived"] firstObject];
    if (nil != archivedElement)
    {
        result = [self parseIdFromXmlMessage: archivedElement];
        return result;
    }
    
    NSXMLElement* resultElement = [[castedMessage elementsForName: @"result"] firstObject];
    if (nil != resultElement)
    {
        result = [self parseIdFromXmlMessage: resultElement];
        return result;
    }
    
    return nil;
}

+ (NSString*)parseIdFromXmlElement:(id)xmlElement
{
    NSXMLElement* castedMessage = (NSXMLElement*)xmlElement;
    NSXMLNode* idAttribute = [castedMessage attributeForName: @"id"];
    if (nil != idAttribute)
    {
        NSString* idValue = [idAttribute stringValue];
        return idValue;
    }

    return nil;
}

@end
