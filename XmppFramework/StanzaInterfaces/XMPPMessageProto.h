//
//  XMPPMessageProto.h
//  XmppFrameworkParsers
//
//  Created by Oleksandr Dodatko on 7/9/15.
//  Copyright (c) 2015 healthjoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XmppFrameworkParsers/XmppFramework/StanzaInterfaces/XMPPElementProto.h>

@protocol XMPPMessageProto <XMPPElementProto>

- (NSString *)identification;

- (NSString *)jid;
- (NSString *)type;
- (NSString *)xType;
- (NSString *)subject;
- (NSString *)body;
- (NSString *)bodyForLanguage:(NSString *)language;
- (NSString *)thread;
- (NSDate*)timestamp;
- (NSString *)nicknameOfPresenceDirective;

- (BOOL)isChatMessage;
- (BOOL)isChatMessageWithBody;
- (BOOL)isErrorMessage;
- (BOOL)isMessageWithBody;

- (BOOL)isMessagePresenceDirective;
- (BOOL)isMessageHasPHAType;
- (BOOL)isMessagePresenceDirectiveLeaveDoc;

- (BOOL)isMessageSelectDirective;
- (NSString *)valueOfOptionDirective;
- (NSArray *)optionDirectives;

- (BOOL)isMessageSimpleSelectDirective;
- (NSArray *)simpleOptionDirectives;

- (NSString*)chatSelectDirectiveID;
- (NSString*)chatSelectDirectiveValue;

- (NSString*)chatSimpleSelectDirectiveValue;

- (NSError *)errorMessage;

- (NSString*)messageId;

@end
