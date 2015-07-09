#import <Foundation/Foundation.h>
#import <XmppFrameworkParsers/XmppFramework/Parser/XMPPParserProto.h>


@interface XMPPParser : NSObject<XMPPParserProto>

- (id)initWithDelegate:(id)delegate delegateQueue:(dispatch_queue_t)dq;
- (id)initWithDelegate:(id)delegate delegateQueue:(dispatch_queue_t)dq parserQueue:(dispatch_queue_t)pq;

- (void)setDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

/**
 * Asynchronously parses the given data.
 * The delegate methods will be dispatch_async'd as events occur.
**/
- (void)parseData:(NSData *)data;

@end


