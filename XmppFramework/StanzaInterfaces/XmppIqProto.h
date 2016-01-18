//
//  XmppIqProto.h
//  XmppFrameworkParsers
//
//  Created by Oleksandr Dodatko on 7/9/15.
//  Copyright (c) 2015 healthjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XmppIqProto <XMPPElementProto>

/**
 * Returns the type attribute of the IQ.
 * According to the XMPP protocol, the type should be one of 'get', 'set', 'result' or 'error'.
 *
 * This method converts the attribute to lowercase so
 * case-sensitive string comparisons are safe (regardless of server treatment).
 **/
- (NSString *)type;

- (NSString *)avatar;
- (NSString *)nickname;

/**
 * Convenience methods for determining the IQ type.
 **/
- (BOOL)isGetIQ;
- (BOOL)isSetIQ;
- (BOOL)isResultIQ;
- (BOOL)isErrorIQ;
- (BOOL)isAvatarIQ;

/**
 * Convenience method for determining if the IQ is of type 'get' or 'set'.
 **/
- (BOOL)requiresResponse;


/**
 * The XMPP RFC has various rules for the number of child elements an IQ is allowed to have:
 *
 * - An IQ stanza of type "get" or "set" MUST contain one and only one child element.
 * - An IQ stanza of type "result" MUST include zero or one child elements.
 * - An IQ stanza of type "error" SHOULD include the child element contained in the
 *   associated "get" or "set" and MUST include an <error/> child.
 *
 * The childElement returns the single non-error element, if one exists, or nil.
 * The childErrorElement returns the error element, if one exists, or nil.
 **/
- (NSXMLElement *)childElement;
- (NSXMLElement *)childErrorElement;


@end
