//
//  NCNoteObject.m
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import "NCNoteObject.h"

@implementation NCNoteObject

- (NSString *)dateString {
    if (!self.modifiedDate)
        return @"";
    
    return [self stringFromModifiedDate:self.modifiedDate];
}

- (NSString *)stringFromModifiedDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    return [dateFormatter stringFromDate:date];
}

- (void)setDateFromString:(NSString *)dateString {
    
}



@end
