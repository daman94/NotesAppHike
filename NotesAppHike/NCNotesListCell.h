//
//  NCNotesListCell.h
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCNoteObject;

@interface NCNotesListCell : UITableViewCell

- (void)setNoteObject:(NCNoteObject *)noteObject;

+ (NSString *)reuseIdentifier;

@end
