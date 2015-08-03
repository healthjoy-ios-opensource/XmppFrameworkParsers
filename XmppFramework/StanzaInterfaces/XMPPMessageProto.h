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

- (NSString *)type;
- (NSString *)subject;
- (NSString *)body;
- (NSString *)bodyForLanguage:(NSString *)language;
- (NSString *)thread;
- (NSDate*)timestamp;

- (BOOL)isChatMessage;
- (BOOL)isChatMessageWithBody;
- (BOOL)isErrorMessage;
- (BOOL)isMessageWithBody;

- (NSError *)errorMessage;

- (NSString*)messageId;

@end
