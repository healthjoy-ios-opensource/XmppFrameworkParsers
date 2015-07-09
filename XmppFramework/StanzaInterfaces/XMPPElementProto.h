//
//  XMPPElementProto.h
//  XmppFrameworkParsers
//
//  Created by Oleksandr Dodatko on 7/9/15.
//  Copyright (c) 2015 healthjoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XmppFrameworkParsers/XmppFramework/StanzaClasses/XMPPJIDCompareOptions.h>

@protocol XMPPJID;

@protocol XMPPElementProto <NSObject>

#pragma mark - serialization
- (NSString *)XMLString;
- (NSString *)XMLStringWithOptions:(NSUInteger)options;


#pragma mark Common Jabber Methods

- (NSString *)elementID;

- (id<XMPPJID>)to;
- (id<XMPPJID>)from;

- (NSString *)toStr;
- (NSString *)fromStr;

#pragma mark To and From Methods

- (BOOL)isTo:(id<XMPPJID>)to;
- (BOOL)isTo:(id<XMPPJID>)to options:(XMPPJIDCompareOptions)mask;

- (BOOL)isFrom:(id<XMPPJID>)from;
- (BOOL)isFrom:(id<XMPPJID>)from options:(XMPPJIDCompareOptions)mask;

- (BOOL)isToOrFrom:(id<XMPPJID>)toOrFrom;
- (BOOL)isToOrFrom:(id<XMPPJID>)toOrFrom options:(XMPPJIDCompareOptions)mask;

- (BOOL)isTo:(id<XMPPJID>)to from:(id<XMPPJID>)from;
- (BOOL)isTo:(id<XMPPJID>)to from:(id<XMPPJID>)from options:(XMPPJIDCompareOptions)mask;

@end
