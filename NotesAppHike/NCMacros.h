//
//  NCMacros.h
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline BOOL IsIOS7AndUp() {
    return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
}
