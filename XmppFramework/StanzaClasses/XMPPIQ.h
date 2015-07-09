#import <Foundation/Foundation.h>
#import <XmppFrameworkParsers/XmppFramework/StanzaClasses/XMPPElement.h>
#import <XmppFrameworkParsers/XmppFramework/StanzaInterfaces/XmppIqProto.h>

/**
 * The XMPPIQ class represents an <iq> element.
 * It extends XMPPElement, which in turn extends NSXMLElement.
 * All <iq> elements that go in and out of the
 * xmpp stream will automatically be converted to XMPPIQ objects.
 * 
 * This class exists to provide developers an easy way to add functionality to IQ processing.
 * Simply add your own category to XMPPIQ to extend it with your own custom methods.
**/

@interface XMPPIQ : XMPPElement<XmppIqProto>

/**
 * Converts an NSXMLElement to an XMPPIQ element in place (no memory allocations or copying)
**/
+ (XMPPIQ *)iqFromElement:(NSXMLElement *)element;

/**
 * Creates and returns a new autoreleased XMPPIQ element.
 * If the type or elementID parameters are nil, those attributes will not be added.
**/
+ (XMPPIQ *)iq;
+ (XMPPIQ *)iqWithType:(NSString *)type;
+ (XMPPIQ *)iqWithType:(NSString *)type to:(XMPPJID *)jid;
+ (XMPPIQ *)iqWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid;
+ (XMPPIQ *)iqWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid child:(NSXMLElement *)childElement;
+ (XMPPIQ *)iqWithType:(NSString *)type elementID:(NSString *)eid;
+ (XMPPIQ *)iqWithType:(NSString *)type elementID:(NSString *)eid child:(NSXMLElement *)childElement;
+ (XMPPIQ *)iqWithType:(NSString *)type child:(NSXMLElement *)childElement;

/**
 * Creates and returns a new XMPPIQ element.
 * If the type or elementID parameters are nil, those attributes will not be added.
**/
- (id)init;
- (id)initWithType:(NSString *)type;
- (id)initWithType:(NSString *)type to:(XMPPJID *)jid;
- (id)initWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid;
- (id)initWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid child:(NSXMLElement *)childElement;
- (id)initWithType:(NSString *)type elementID:(NSString *)eid;
- (id)initWithType:(NSString *)type elementID:(NSString *)eid child:(NSXMLElement *)childElement;
- (id)initWithType:(NSString *)type child:(NSXMLElement *)childElement;

@end
