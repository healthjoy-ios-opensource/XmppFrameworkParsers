//
//  XMPPMessageProto.h
//  XmppFrameworkParsers
//
//  Created by Oleksandr Dodatko on 7/9/15.
//  Copyright (c) 2015 healthjoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XmppFrameworkParsers/XmppFramework/StanzaInterfaces/XMPPElementProto.h>

@class UIColor;

@protocol XMPPMessageProto <XMPPElementProto>

- (NSString *)identification;

- (NSString *)jid;
- (NSString *)type;
- (NSString *)xType;
- (BOOL)isXTypeSet;
- (BOOL)isXTypeResult;
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

- (BOOL)isMessageAutocompleteDirective;
- (NSString *)sourceOfMessageAutocompleteDirective;
- (NSString *)showValueOfMessageAutocompleteDirective;

- (BOOL)isMessagePhoneInputDirective;
- (NSString *)valueOfMessagePhoneInputDirective;

- (BOOL)isMessageDobInputDirective;
- (NSString *)valueOfMessageDobInputDirective;

- (BOOL)isMessageZipInputDirective;
- (NSString *)valueOfMessageZipInputDirective;

- (BOOL)isMessageSelectDirective;
- (NSString *)valueOfOptionDirective;
- (NSString *)titleOfOptionDirective;
- (NSString *)typeOfOptionDirective;
- (NSArray *)optionDirectives;

- (BOOL)isMessageSimpleSelectDirective;
- (NSArray *)simpleOptionDirectives;

- (NSString*)chatSelectDirectiveID;
- (NSString*)chatSelectDirectiveTitle;
- (NSString*)chatSelectDirectiveValue;

- (NSString*)chatSimpleSelectDirectiveValue;

- (BOOL)isMessageChatJourneyUpdatedDirective;
- (NSString*)chatJourneyUpdatedDirectiveStatus;
- (NSString*)chatJourneyUpdatedDirectiveType;
- (NSString*)chatJourneyUpdatedDirectiveTitle;

- (NSError *)errorMessage;

- (NSString*)messageId;

- (BOOL)isChatSimpleInputDirective;
- (NSString *)valueOfMessageTextInputDirective;
- (NSString *)chatSimpleInputDirectivePlaceholder;

- (BOOL)isChatControls;

- (BOOL)isCompletedDirective;

- (BOOL)isChatHeaderParameters;
- (UIColor*)chatHeaderColor;
- (BOOL)chatHeaderSiska;
- (NSString*)chatHeaderTitle;

- (BOOL)isChatBrowseDirective;
- (BOOL)isChatBrowseSecure;
- (NSString*)chatBrowseURL;

@end
