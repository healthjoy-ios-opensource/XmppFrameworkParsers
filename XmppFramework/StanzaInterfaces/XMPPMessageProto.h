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
- (BOOL)userInvisible;
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
- (NSString *)viewTypeOfAutocompleteDirective;
- (NSString *)placeholderOfAutocompleteDirective;
- (NSString *)queryFilterOfAutocompleteDirective;
- (NSString *)sourceOfAutocompleteDirective;
- (BOOL)requiredOfAutocompleteDirective;
- (NSString *)valueOfAutocompleteDirective;
- (NSString *)showValueOfAutocompleteDirective;

- (BOOL)isMessageSelectDirective;
- (NSString *)valueOfOptionDirective;
- (NSString *)titleOfOptionDirective;
- (NSString *)typeOfOptionDirective;
- (NSArray *)optionDirectives;

- (BOOL)isMessageSimpleSelectDirective;
- (BOOL)isMessageSimpleSelectDirectiveExpand;
- (NSString *)chatSimpleSelectDirectiveHeader;
- (NSString *)chatSimpleSelectDirectiveType;
- (NSString *)chatSimpleSelectDirectiveTitle;
- (NSArray *)simpleOptionDirectives;
- (NSString *)chatDefaultOptionDirectiveValue;
- (NSString *)chatDefaultOptionDirectiveTitle;

- (NSString*)chatSelectDirectiveID;
- (NSString*)chatSelectDirectiveTitle;
- (NSString*)chatSelectDirectiveValue;
- (NSString*)chatSelectDirectiveUrl;

- (NSString*)chatSimpleSelectDirectiveValue;

- (BOOL)isMessageChatJourneyUpdatedDirective;
- (NSString*)chatJourneyUpdatedDirectiveID;
- (NSString*)chatJourneyUpdatedDirectiveStatus;
- (NSString*)chatJourneyUpdatedDirectiveType;
- (NSString*)chatJourneyUpdatedDirectiveViewType;
- (NSString*)chatJourneyUpdatedDirectiveTitle;

- (BOOL)isMessageChatJourneyStatusUpdatedDirective;
- (NSString*)chatJourneyStatusUpdatedDirectiveID;

- (NSError *)errorMessage;

- (NSString*)messageId;

- (BOOL)isChatSimpleInputDirective;
- (NSString *)valueOfMessageTextInputDirective;
- (NSString *)chatSimpleInputDirectivePlaceholder;
- (NSString *)chatSimpleInputDirectivePattern;
- (NSString *)chatSimpleInputDirectiveMask;
- (NSString *)chatSimpleInputDirectiveType;

- (BOOL)isChatPhotoDirective;
- (NSString *)valueOfChatPhotoDirective;
- (BOOL)isChatPhotoDirectiveForce;

- (BOOL)isChatControls;

- (BOOL)isCompletedDirective;

- (BOOL)isChatHeaderParameters;
- (UIColor*)chatHeaderColor;
- (BOOL)chatHeaderSiska;
- (NSString*)chatHeaderTitle;

- (BOOL)isChatBrowseDirective;
- (BOOL)isChatBrowseSecure;
- (NSString*)chatBrowseURL;

- (BOOL)isChatCheckPermissionDirective;
- (NSString *)chatCheckPermissionDirectivePermission;

- (BOOL)isChatRequestPermissionDirective;
- (NSString *)chatRequestPermissionDirectivePermission;

- (BOOL)isChatGetLocationDirective;

- (BOOL)isChatPermissionSettingsDirective;
- (NSString *)chatPermissionSettingsDirective;

- (BOOL)isChatDisclaimerDirective;
- (NSString *)chatDisclaimerDirectiveTitle;
- (NSString *)chatDisclaimerDirectiveBody;
- (NSString *)chatDisclaimerDirectiveNegativeButtonText;
- (NSString *)chatDisclaimerDirectivePositiveButtonText;

- (BOOL)isChatStripeDirective;
- (NSString *)chatStripeDirectiveTitle;
- (NSString *)chatStripeDirectiveAmount;
- (NSString *)chatStripeDirectiveCurrency;
- (NSString *)chatStripeDirectiveStripeApiVersion;
- (NSString *)chatStripeDirectiveStripePublicKey;

- (BOOL)isChatRefreshWebViewDirective;

- (BOOL)isChatAnimationSpeedDirective;
- (NSString *)chatAnimationSpeedValueDirective;

- (BOOL)isChatBlankControlDirective;

@end
