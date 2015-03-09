//
//  NCCreateEditNoteController.h
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCNoteObject;

@protocol NCEditNoteDelegate

@required
- (void)didFinishEditing:(id)sender withObject:(NCNoteObject *)noteObject;

@end

@interface NCCreateEditNoteController : UIViewController

@property (nonatomic, weak) id<NCEditNoteDelegate> delegate;

- (id)initWithNoteObject:(NCNoteObject *)notesObject;

@end
