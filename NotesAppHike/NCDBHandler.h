//
//  NCDBHandler.h
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NCNoteObject.h"

@interface NCDBHandler : NSObject

+ (instancetype)defaultHandler;

// functional methods
- (void)createInitNotesDb;
- (void)saveNoteObject:(NCNoteObject *)noteObject;
- (NSArray *)getAllNotes;
- (NCNoteObject *)getNoteWithId:(NSString *)noteIdentifier;

@end
