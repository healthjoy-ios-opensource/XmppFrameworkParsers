//
//  XMPPParserProto.h
//  XmppFrameworkParsers
//
//  Created by Oleksandr Dodatko on 7/9/15.
//  Copyright (c) 2015 healthjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMPPParserDelegate;


@protocol XMPPParserProto <NSObject>

/**
 * Asynchronously parses the given data.
 * The delegate methods will be dispatch_async'd as events occur.
 **/
- (void)parseData:(NSData *)data;


- (void)setDelegate:(id<XMPPParserDelegate>)delegate
      delegateQueue:(dispatch_queue_t)delegateQueue;

@end
