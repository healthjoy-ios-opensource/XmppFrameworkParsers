//
//  XmppMutableMessageProto.h
//  XmppFrameworkParsers
//
//  Created by Oleksandr Dodatko on 7/9/15.
//  Copyright (c) 2015 healthjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XmppMutableMessageProto <NSObject>

- (void)addSubject:(NSString *)subject;
- (void)addBody:(NSString *)body;
- (void)addBody:(NSString *)body withLanguage:(NSString *)language;
- (void)addThread:(NSString *)thread;

- (void)setTimestamp:(NSDate*)timestamp;

@end
