//
//  XMPPMessageTimestampParser.h
//  XmppFrameworkParsers
//
//  Created by Oleksandr Dodatko on 7/27/15.
//  Copyright (c) 2015 healthjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMPPMessageTimestampParser : NSObject

+ (NSDate*)parseTimestampFromXmlElement:(id)xmlElement;

+ (NSString*)parseIdFromXmlMessage:(id)xmlElement;
+ (NSString*)parseIdFromXmlElement:(id)xmlElement;

@end
