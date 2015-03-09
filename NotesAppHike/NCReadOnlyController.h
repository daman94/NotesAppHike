//
//  NCReadOnlyController.h
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class NCNoteObject;

@interface NCReadOnlyController : UIViewController

- (id)initWithNoteObject:(NCNoteObject *)noteObject;

@end
