//
//  NCNoteObject.h
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCNoteObject : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *noteString;
@property (nonatomic, strong) NSDate *modifiedDate;
@property (nonatomic, readonly) NSString *dateString;

@end
