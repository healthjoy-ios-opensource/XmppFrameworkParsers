#import "XMPPMessage.h"
#import "XMPPJID.h"
#import "NSXMLElement+XMPP.h"

#import "XMPPMessageTimestampParser.h"

#import <objc/runtime.h>



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

- (NSString *)valueOfOptionDirective {
    
    return [[self attributeForName:@"value"] stringValue];
}

- (NSArray *)optionDirectives
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* selectDirectiveNode = [[xNode elementsForName: @"chat-select-directive"] firstObject];
    
    NSArray* optionDirectives = [selectDirectiveNode elementsForName: @"chat-option-directive"];
    
    return optionDirectives;
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
    
    NSString *archivedID = [[xNode attributeForName:@"id"] stringValue];
    
    return archivedID;
}

- (NSString*)chatSelectDirectiveValue
{
    NSXMLElement* xNode = [[self elementsForName: @"x"] firstObject];
    NSXMLElement* chatSelectNode = [[xNode elementsForName: @"chat-select-directive"] firstObject];
    
    NSString *archivedValue = [[chatSelectNode attributeForName:@"value"] stringValue];
    
    return archivedValue;
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

- (BOOL)isMessageWithBody
{
	return ([self elementForName:@"body"] != nil);
}

@end
