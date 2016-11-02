#import "XMPPMessage.h"
#import "XMPPJID.h"
#import "NSXMLElement+XMPP.h"

#import "XMPPMessageTimestampParser.h"

#import <objc/runtime.h>

#import <UIKit/UIKit.h>


#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif


@interface XMPPMessage()

@property (nonatomic, copy) NSDate* objectCreationDate;

@end

@implementation XMPPMessage

@dynamic objectCreationDate;

- (void)dealloc
{
    objc_removeAssociatedObjects(self);
}

static const char* objectCreationDateKey = "objectCreationDateKey";
- (void)setObjectCreationDate:(NSDate *)objectCreationDate
{
    objc_setAssociatedObject(self, objectCreationDateKey, objectCreationDate, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDate*)objectCreationDate
{
    NSDate* result = objc_getAssociatedObject(self, objectCreationDateKey);
    return result;
}

#if DEBUG

+ (void)initialize
{
	// We use the object_setClass method below to dynamically change the class from a standard NSXMLElement.
	// The size of the two classes is expected to be the same.
	//
	// If a developer adds instance methods to this class, bad things happen at runtime that are very hard to debug.
	// This check is here to aid future developers who may make this mistake.
	//
	// For Fearless And Experienced Objective-C Developers:
	// It may be possible to support adding instance variables to this class if you seriously need it.
	// To do so, try realloc'ing self after altering the class, and then initialize your variables.
	
	size_t superSize = class_getInstanceSize([NSXMLElement class]);
	size_t ourSize   = class_getInstanceSize([XMPPMessage class]);
	
	if (superSize != ourSize)
	{
		NSLog(@"Adding instance variables to XMPPMessage is not currently supported!");
		exit(15);
	}
}

#endif

+ (XMPPMessage *)messageFromElement:(NSXMLElement *)element
{
	object_setClass(element, [XMPPMessage class]);
    XMPPMessage* result = (XMPPMessage *)element;
    
    result.objectCreationDate = [NSDate date];
    
    return result;
}

+ (XMPPMessage *)message
{
	return [[XMPPMessage alloc] init];
}

+ (XMPPMessage *)messageWithType:(NSString *)type
{
	return [[XMPPMessage alloc] initWithType:type to:nil];
}

+ (XMPPMessage *)messageWithType:(NSString *)type to:(XMPPJID *)to
{
	return [[XMPPMessage alloc] initWithType:type to:to];
}

+ (XMPPMessage *)messageWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid
{
	return [[XMPPMessage alloc] initWithType:type to:jid elementID:eid];
}

+ (XMPPMessage *)messageWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid child:(NSXMLElement *)childElement
{
	return [[XMPPMessage alloc] initWithType:type to:jid elementID:eid child:childElement];
}

+ (XMPPMessage *)messageWithType:(NSString *)type elementID:(NSString *)eid
{
	return [[XMPPMessage alloc] initWithType:type elementID:eid];
}

+ (XMPPMessage *)messageWithType:(NSString *)type elementID:(NSString *)eid child:(NSXMLElement *)childElement
{
	return [[XMPPMessage alloc] initWithType:type elementID:eid child:childElement];
}

+ (XMPPMessage *)messageWithType:(NSString *)type child:(NSXMLElement *)childElement
{
	return [[XMPPMessage alloc] initWithType:type child:childElement];
}

- (id)init
{
	return [self initWithType:nil to:nil elementID:nil child:nil];
}

- (id)initWithType:(NSString *)type
{
	return [self initWithType:type to:nil elementID:nil child:nil];
}

- (id)initWithType:(NSString *)type to:(XMPPJID *)jid
{
	return [self initWithType:type to:jid elementID:nil child:nil];
}

- (id)initWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid
{
	return [self initWithType:type to:jid elementID:eid child:nil];
}

- (id)initWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid child:(NSXMLElement *)childElement
{
	if ((self = [super initWithName:@"message"]))
	{
        self.objectCreationDate = [NSDate date];
        
		if (type)
			[self addAttributeWithName:@"type" stringValue:type];
		
		if (jid)
			[self addAttributeWithName:@"to" stringValue:[jid full]];
		
		if (eid)
			[self addAttributeWithName:@"id" stringValue:eid];
		
		if (childElement)
			[self addChild:childElement];
	}
	return self;
}

- (id)initWithType:(NSString *)type elementID:(NSString *)eid
{
	return [self initWithType:type to:nil elementID:eid child:nil];
}

- (id)initWithType:(NSString *)type elementID:(NSString *)eid child:(NSXMLElement *)childElement
{
	return [self initWithType:type to:nil elementID:eid child:childElement];
}

- (id)initWithType:(NSString *)type child:(NSXMLElement *)childElement
{
	return [self initWithType:type to:nil elementID:nil child:childElement];
}

- (id)initWithXMLString:(NSString *)string error:(NSError *__autoreleasing *)error
{
	if((self = [super initWithXMLString:string error:error])){
		self = [XMPPMessage messageFromElement:self];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    NSXMLElement *element = [super copyWithZone:zone];
    return [XMPPMessage messageFromElement:element];
}

- (NSString *)identification
{
    return [[self attributeForName:@"id"] stringValue];
}

- (NSString *)jid
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement *presenceDirectiveNode = [[xNode elementsForName: @"chat-presence-directive"] firstObject];
    
    return [[presenceDirectiveNode attributeForName:@"jid"] stringValue];
}

- (NSString *)type
{
    return [[self attributeForName:@"type"] stringValue];
}

- (BOOL)isXTypeSet {
    
    return ([[self xType] isEqualToString:@"set"]);
}

- (BOOL)isXTypeResult {
    
    return ([[self xType] isEqualToString:@"result"]);
}

- (NSString *)xType
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    
    return [[xNode attributeForName:@"type"] stringValue];
}

- (NSString *)subject
{
	return [[self elementForName:@"subject"] stringValue];
}

- (NSString *)body
{
	return [[self elementForName:@"body"] stringValue];
}

- (NSString*)messageId
{
    return [XMPPMessageTimestampParser parseIdFromXmlMessage: self];
}

- (NSString *)bodyForLanguage:(NSString *)language
{
    NSString *bodyForLanguage = nil;
    
    for (NSXMLElement *bodyElement in [self elementsForName:@"body"])
    {
        NSString *lang = [[bodyElement attributeForName:@"xml:lang"] stringValue];
        
        // Openfire strips off the xml prefix
        if (lang == nil)
        {
            lang = [[bodyElement attributeForName:@"lang"] stringValue];
        }
        
        if ([language isEqualToString:lang] || ([language length] == 0  && [lang length] == 0))
        {
            bodyForLanguage = [bodyElement stringValue];
            break;
        }
    }
    
    return bodyForLanguage;
}

- (NSString *)thread
{
	return [[self elementForName:@"thread"] stringValue];
}

- (void)setTimestamp:(NSDate *)timestamp
{
    self.objectCreationDate = timestamp;
}

- (NSDate*)timestamp
{
    NSDate* result = [XMPPMessageTimestampParser parseTimestampFromXmlElement: self];
    
    if (nil == result)
    {
        return self.objectCreationDate;
    }
    
    return result;
}

- (void)addSubject:(NSString *)subject
{
    NSXMLElement *subjectElement = [NSXMLElement elementWithName:@"subject" stringValue:subject];
    [self addChild:subjectElement];
}

- (void)addBody:(NSString *)body
{
    NSXMLElement *bodyElement = [NSXMLElement elementWithName:@"body" stringValue:body];
    [self addChild:bodyElement];
}

- (void)addBody:(NSString *)body withLanguage:(NSString *)language
{
    NSXMLElement *bodyElement = [NSXMLElement elementWithName:@"body" stringValue:body];
    
    if ([language length])
    {
        [bodyElement addAttributeWithName:@"xml:lang" stringValue:language];
    }
    
    [self addChild:bodyElement];
}

- (void)addThread:(NSString *)thread
{
    NSXMLElement *threadElement = [NSXMLElement elementWithName:@"thread" stringValue:thread];
    [self addChild:threadElement];
}

- (BOOL)isChatMessage
{
	return [[[self attributeForName:@"type"] stringValue] isEqualToString:@"chat"];
}

- (BOOL)isChatMessageWithBody
{
	if ([self isChatMessage])
	{
		return [self isMessageWithBody];
	}
	
	return NO;
}

- (BOOL)isErrorMessage
{
    return [[[self attributeForName:@"type"] stringValue] isEqualToString:@"error"];
}

- (BOOL)isMessageSelectDirective
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *selectDirectiveNode = [xNode elementsForName: @"chat-select-directive"];
    
    return (selectDirectiveNode.count != 0);
}

- (BOOL)isMessageAutocompleteDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-autocomplete-directive"];
    
    return (directiveNode.count != 0);
}

- (NSString *)viewTypeOfAutocompleteDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-autocomplete-directive"];
    NSString *listType = [[[directiveNode firstObject] attributeForName:@"view_type"] stringValue];
    
    return listType;
}

- (NSString *)placeholderOfAutocompleteDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-autocomplete-directive"];
    NSString *placeholder = [[[directiveNode firstObject] attributeForName:@"placeholder"] stringValue];
    
    return placeholder;
}

- (NSString *)queryFilterOfAutocompleteDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-autocomplete-directive"];
    NSString *queryFilter = [[[directiveNode firstObject] attributeForName:@"query_filter"] stringValue];
    
    return queryFilter;
}

- (NSString *)sourceOfAutocompleteDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-autocomplete-directive"];
    NSString *source = [[[directiveNode firstObject] attributeForName:@"source"] stringValue];
    
    return source;
}

- (BOOL)requiredOfAutocompleteDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-autocomplete-directive"];
    BOOL required = [[[[directiveNode firstObject] attributeForName:@"required"] stringValue] boolValue];
    
    return required;
}

- (NSString *)valueOfAutocompleteDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-autocomplete-directive"];
    NSString *value = [[[directiveNode firstObject] attributeForName:@"value"] stringValue];
    
    return value;
}

- (NSString *)showValueOfAutocompleteDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-autocomplete-directive"];
    NSString *showValue = [[[directiveNode firstObject] attributeForName:@"show_value"] stringValue];
    
    return showValue;
}

- (NSString *)valueOfMessageTextInputDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-simple-input-directive"];
    NSString *value = [[[directiveNode firstObject] attributeForName:@"value"] stringValue];
    
    return value;
}

- (NSString *)chatSimpleInputDirectivePlaceholder {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-simple-input-directive"];
    NSString *value = [[[directiveNode firstObject] attributeForName:@"placeholder"] stringValue];
    
    return value;
}

- (NSString *)chatSimpleInputDirectivePattern {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-simple-input-directive"];
    NSString *pattern = [[[directiveNode firstObject] attributeForName:@"pattern"] stringValue];
    
    return pattern;
}

- (NSString *)chatSimpleInputDirectiveMask {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-simple-input-directive"];
    NSString *mask = [[[directiveNode firstObject] attributeForName:@"mask"] stringValue];
    
    return mask;
}

- (NSString *)chatSimpleInputDirectiveType {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *directiveNode = [xNode elementsForName: @"chat-simple-input-directive"];
    NSString *type = [[[directiveNode firstObject] attributeForName:@"type"] stringValue];
    
    return type;
}

- (NSString *)valueOfOptionDirective {
    
    return [[self attributeForName:@"value"] stringValue];
}

- (NSString *)titleOfOptionDirective {
    
    return [[self attributeForName:@"title"] stringValue];
}
- (NSString *)typeOfOptionDirective {
    
    return [[self attributeForName:@"type"] stringValue];
}

- (NSArray *)optionDirectives
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* selectDirectiveNode = [[xNode elementsForName: @"chat-select-directive"] firstObject];
    NSArray* optionDirectives = [selectDirectiveNode elementsForName: @"chat-option-directive"];
    
    return optionDirectives;
}

- (BOOL)isMessageSimpleSelectDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSArray *selectDirectiveNode = [xNode elementsForName: @"chat-simple-select-directive"];
    
    return (selectDirectiveNode.count != 0);
}

- (NSString *)chatSimpleSelectDirectiveType {
    
    NSXMLElement *xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement *chatSimpleSelectNode= [[xNode elementsForName: @"chat-simple-select-directive"] firstObject];
    
    NSString *view = [[chatSimpleSelectNode attributeForName:@"view_type"] stringValue];
    
    return view;
}

- (NSString *)chatSimpleSelectDirectiveTitle {
    
    NSXMLElement *xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement *chatSimpleSelectNode= [[xNode elementsForName: @"chat-simple-select-directive"] firstObject];
    
    NSString *title = [[chatSimpleSelectNode attributeForName:@"title"] stringValue];
    
    return title;
}

- (NSArray *)simpleOptionDirectives
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* selectDirectiveNode = [[xNode elementsForName: @"chat-simple-select-directive"] firstObject];
    
    NSArray* optionDirectives = [selectDirectiveNode elementsForName: @"chat-simple-option-directive"];
    
    return optionDirectives;
}

- (NSString *)chatDefaultOptionDirectiveValue {
    
    NSXMLElement *xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement *chatSimpleSelectNode= [[xNode elementsForName: @"chat-simple-select-directive"] firstObject];
    NSXMLElement* defaultOptionDirectiveNode = [[chatSimpleSelectNode elementsForName: @"default-option-directive"] firstObject];
    
    NSString *value = [[defaultOptionDirectiveNode attributeForName:@"value"] stringValue];
    
    return value;
}
- (NSString *)chatDefaultOptionDirectiveTitle {
    
    NSXMLElement *xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement *chatSimpleSelectNode= [[xNode elementsForName: @"chat-simple-select-directive"] firstObject];
    NSXMLElement* defaultOptionDirectiveNode = [[chatSimpleSelectNode elementsForName: @"default-option-directive"] firstObject];
    
    return [defaultOptionDirectiveNode stringValue];
}

- (BOOL)isMessagePresenceDirective
{
    NSXMLElement *xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement *presenceDirectiveNode = [[xNode elementsForName: @"chat-presence-directive"] firstObject];
    
    NSString *status = [[presenceDirectiveNode attributeForName:@"status"] stringValue];

    return ([status isEqualToString:@"available"]);
}

- (BOOL)isMessagePresenceDirectiveLeaveDoc
{
    NSXMLElement *xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement *presenceDirectiveNode = [[xNode elementsForName: @"chat-presence-directive"] firstObject];
    
    NSString *status = [[presenceDirectiveNode attributeForName:@"status"] stringValue];
    NSString *type = [[presenceDirectiveNode attributeForName:@"type"] stringValue];
    
    return ([status isEqualToString:@"unavailable"] &&
            [type isEqualToString:@"MD"]);
}

- (BOOL)isMessageHasPHAType
{
    NSXMLElement *xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement *presenceDirectiveNode = [[xNode elementsForName: @"chat-presence-directive"] firstObject];
    
    NSString *type = [[presenceDirectiveNode attributeForName:@"type"] stringValue];
    
    return ([type isEqualToString:@"PHA"]);
}

- (NSString *)nicknameOfPresenceDirective
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement *presenceDirectiveNode = [[xNode elementsForName: @"chat-presence-directive"] firstObject];
    
    NSString *nickname = [[presenceDirectiveNode attributeForName:@"nickname"] stringValue];
    
    return nickname;
}

- (NSString*)chatSelectDirectiveID
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    
    NSString *value = [[xNode attributeForName:@"id"] stringValue];
    
    return value;
}

- (NSString*)chatSelectDirectiveValue
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatSelectNode = [[xNode elementsForName: @"chat-select-directive"] firstObject];
    
    NSString *value = [[chatSelectNode attributeForName:@"value"] stringValue];
    
    return value;
}

- (NSString*)chatSelectDirectiveTitle
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatSelectNode = [[xNode elementsForName: @"chat-select-directive"] firstObject];
    
    NSString *value = [[chatSelectNode attributeForName:@"title"] stringValue];
    
    return value;
}

- (NSString*)chatSimpleSelectDirectiveValue
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatSelectNode = [[xNode elementsForName: @"chat-simple-select-directive"] firstObject];
    
    NSString *value = [[chatSelectNode attributeForName:@"value"] stringValue];
    
    return value;
}

- (BOOL)isMessageChatJourneyUpdatedDirective
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatSelectNode = [[xNode elementsForName: @"chat-journey-presentation-directive"] firstObject];
    
    return (chatSelectNode != nil) ? YES : NO;
}

- (NSString*)chatJourneyUpdatedDirectiveID {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* directiveNode = [[xNode elementsForName: @"chat-journey-presentation-directive"] firstObject];
    
    NSString *cardID = [[directiveNode attributeForName:@"card_id"] stringValue];
    
    return cardID;
}

- (NSString*)chatJourneyUpdatedDirectiveStatus
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* directiveNode = [[xNode elementsForName: @"chat-journey-presentation-directive"] firstObject];
    
    NSString *value = [[directiveNode attributeForName:@"status"] stringValue];
    
    return value;
}
- (NSString*)chatJourneyUpdatedDirectiveType
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatSelectNode = [[xNode elementsForName: @"chat-journey-presentation-directive"] firstObject];
    
    NSString *value = [[chatSelectNode attributeForName:@"type"] stringValue];
    
    return value;
}
- (NSString*)chatJourneyUpdatedDirectiveViewType {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatSelectNode = [[xNode elementsForName: @"chat-journey-presentation-directive"] firstObject];
    
    NSString *viewType = [[chatSelectNode attributeForName:@"view_type"] stringValue];
    
    return viewType;
}
- (NSString*)chatJourneyUpdatedDirectiveTitle
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatSelectNode = [[xNode elementsForName: @"chat-journey-presentation-directive"] firstObject];
    
    NSString *value = [[chatSelectNode attributeForName:@"title"] stringValue];
    
    return value;
}

- (BOOL)isMessageChatJourneyStatusUpdatedDirective
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatJourneyNode = [[xNode elementsForName: @"chat-journey-status-updated-directive"] firstObject];
    
    return (chatJourneyNode != nil) ? YES : NO;
}

- (NSString*)chatJourneyStatusUpdatedDirectiveID {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* directiveNode = [[xNode elementsForName: @"chat-journey-status-updated-directive"] firstObject];
    
    NSString *cardID = [[directiveNode attributeForName:@"card_id"] stringValue];
    
    return cardID;
}

- (NSError *)errorMessage
{
    if (![self isErrorMessage]) {
        return nil;
    }
    
    NSXMLElement *error = [self elementForName:@"error"];
    return [NSError errorWithDomain:@"urn:ietf:params:xml:ns:xmpp-stanzas"
                               code:[error attributeIntValueForName:@"code"]
                           userInfo:@{NSLocalizedDescriptionKey : [error compactXMLString]}];
    
}

- (BOOL)isMessageWithBody {
    
	return ([self elementForName:@"body"] != nil);
}

- (BOOL)isChatSimpleInputDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatSimpleInputNode = [[xNode elementsForName: @"chat-simple-input-directive"] firstObject];
    
    return (chatSimpleInputNode != nil) ? YES : NO;
}

- (BOOL)isChatPhotoDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatPhotoNode = [[xNode elementsForName: @"chat-photo-directive"] firstObject];
    
    return (chatPhotoNode != nil) ? YES : NO;
}

- (NSString *)valueOfChatPhotoDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatPhotoNode = [[xNode elementsForName: @"chat-photo-directive"] firstObject];
    NSString *value = [[chatPhotoNode attributeForName:@"value"] stringValue];
    
    return value;
}

- (BOOL)isChatPhotoDirectiveForce {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatPhotoNode = [[xNode elementsForName: @"chat-photo-directive"] firstObject];
    
    return [[[chatPhotoNode attributeForName:@"force"] stringValue] boolValue];
}

- (BOOL)isChatControls {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    
    return ([[[xNode attributeForName:@"chat-controls"] stringValue] boolValue]);
}

- (BOOL)isCompletedDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatCompletedNode = [[xNode elementsForName: @"chat-completed-directive"] firstObject];
    
    return (chatCompletedNode != nil) ? YES : NO;
}

- (BOOL)isChatHeaderParameters {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatHeaderParametersNode = [[xNode elementsForName: @"chat-header-parameters"] firstObject];
    
    return (chatHeaderParametersNode != nil) ? YES : NO;
}

- (UIColor*)chatHeaderColor {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatHeaderNode = [[xNode elementsForName: @"chat-header-parameters"] firstObject];
    
    NSString *colorStr = [[chatHeaderNode attributeForName:@"color"] stringValue];
    colorStr = [XMPPMessage removeSlashAndQuotes:colorStr];
    
    UIColor *value = [XMPPMessage colorFromHexString:colorStr];
    
    return value;
}

- (BOOL)chatHeaderSiska {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatHeaderNode = [[xNode elementsForName: @"chat-header-parameters"] firstObject];
    
    return [[[chatHeaderNode attributeForName:@"siska"] stringValue] boolValue];
}

- (NSString*)chatHeaderTitle {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatHeaderNode = [[xNode elementsForName: @"chat-header-parameters"] firstObject];
    
    NSString *value = [[chatHeaderNode attributeForName:@"title"] stringValue];
    value = [XMPPMessage removeSlashAndQuotes:value];
    
    return value;
}

- (BOOL)isChatBrowseDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatBrowseNode = [[xNode elementsForName: @"chat-browse-directive"] firstObject];
    
    return (chatBrowseNode != nil) ? YES : NO;
}

- (BOOL)isChatBrowseSecure {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatBrowseNode = [[xNode elementsForName: @"chat-browse-directive"] firstObject];
    
    return [[[chatBrowseNode attributeForName:@"secure"] stringValue] boolValue];
}

- (NSString*)chatBrowseURL {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatBrowseNode = [[xNode elementsForName: @"chat-browse-directive"] firstObject];
    
    NSString *value = [[chatBrowseNode attributeForName:@"url"] stringValue];
    
    return value;
}

- (BOOL)isChatCheckPermissionDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatCheckPermission = [[xNode elementsForName: @"chat-check-permission-directive"] firstObject];
    
    return (chatCheckPermission != nil) ? YES : NO;
}
- (NSString *)chatCheckPermissionDirectivePermission {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatCheckPermission = [[xNode elementsForName: @"chat-check-permission-directive"] firstObject];
    
    NSString *permission = [[chatCheckPermission attributeForName:@"permission"] stringValue];
    return permission;
}

- (BOOL)isChatRequestPermissionDirective {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatCheckPermission = [[xNode elementsForName: @"chat-request-permission-directive"] firstObject];
    
    return (chatCheckPermission != nil) ? YES : NO;
}
- (NSString *)chatRequestPermissionDirectivePermission {
    
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatCheckPermission = [[xNode elementsForName: @"chat-request-permission-directive"] firstObject];
    
    NSString *permission = [[chatCheckPermission attributeForName:@"permission"] stringValue];
    return permission;
}

#pragma mark - Private

+ (NSString *)removeSlashAndQuotes:(NSString *)string {
    
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return string;
}

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:(float)((rgbValue & 0xFF0000) >> 16)/255.0f green:(float)((rgbValue & 0xFF00) >> 8)/255.0f blue:(float)(rgbValue & 0xFF)/255.0f alpha:1.0];
}

@end
