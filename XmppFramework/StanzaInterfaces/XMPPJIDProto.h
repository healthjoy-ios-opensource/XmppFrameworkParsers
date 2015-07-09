//
//  XMPPJIDProto.h
//  XmppFrameworkParsers
//
//  Created by Oleksandr Dodatko on 7/9/15.
//  Copyright (c) 2015 healthjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMPPJIDProto <NSObject>

-(NSString*)user;
-(NSString*)domain;
-(NSString*)resource;


/**
 * Terminology (from RFC 6120):
 *
 * The term "bare JID" refers to an XMPP address of the form <localpart@domainpart> (for an account at a server)
 * or of the form <domainpart> (for a server).
 *
 * The term "full JID" refers to an XMPP address of the form
 * <localpart@domainpart/resourcepart> (for a particular authorized client or device associated with an account)
 * or of the form <domainpart/resourcepart> (for a particular resource or script associated with a server).
 *
 * Thus a bareJID is one that does not have a resource.
 * And a fullJID is one that does have a resource.
 *
 * For convenience, there are also methods that that check for a user component as well.
 **/

- (id<XMPPJIDProto>)bareJID;
- (id<XMPPJIDProto>)domainJID;

- (NSString *)bare;
- (NSString *)full;

- (BOOL)isBare;
- (BOOL)isBareWithUser;

- (BOOL)isFull;
- (BOOL)isFullWithUser;

/**
 * A server JID does not have a user component.
 **/
- (BOOL)isServer;

/**
 * Returns a new jid with the given resource.
 **/
- (id<XMPPJIDProto>)jidWithNewResource:(NSString *)resource;

/**
 * When you know both objects are JIDs, this method is a faster way to check equality than isEqual:.
 **/
- (BOOL)isEqualToJID:(id<XMPPJIDProto>)aJID;
- (BOOL)isEqualToJID:(id<XMPPJIDProto>)aJID options:(XMPPJIDCompareOptions)mask;

@end
