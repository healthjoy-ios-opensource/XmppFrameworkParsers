//
//  XMPPParserDelegate.h
//  XmppFrameworkParsers
//
//  Created by Oleksandr Dodatko on 7/9/15.
//  Copyright (c) 2015 healthjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMPPParser;

// @class NSXMLElement;
// @class DDXMLElement;
#if TARGET_OS_IPHONE | TARGET_IPHONE_SIMULATOR
#import <KissXML/DDXML.h> // fucking macros inside
#endif



@protocol XMPPParserDelegate
@optional

- (void)xmppParser:(XMPPParser *)sender didReadRoot:(NSXMLElement *)root;

- (void)xmppParser:(XMPPParser *)sender didReadElement:(NSXMLElement *)element;

- (void)xmppParserDidEnd:(XMPPParser *)sender;

- (void)xmppParser:(XMPPParser *)sender didFail:(NSError *)error;

- (void)xmppParserDidParseData:(XMPPParser *)sender;

@end


