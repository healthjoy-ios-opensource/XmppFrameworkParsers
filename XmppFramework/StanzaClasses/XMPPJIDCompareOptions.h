//
//  XMPPJIDCompareOptions.h
//  XmppFrameworkParsers
//
//  Created by Oleksandr Dodatko on 7/9/15.
//  Copyright (c) 2015 healthjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, XMPPJIDCompareOptions)
{
    XMPPJIDCompareUser     = 1, // 001
    XMPPJIDCompareDomain   = 2, // 010
    XMPPJIDCompareResource = 4, // 100
    
    XMPPJIDCompareBare     = 3, // 011
    XMPPJIDCompareFull     = 7, // 111
};
//typedef enum XMPPJIDCompareOptions XMPPJIDCompareOptions;

