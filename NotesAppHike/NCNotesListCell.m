//
//  NCNotesListCell.m
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import "NCNotesListCell.h"
#import "NCNoteObject.h"
#import "NCColors.h"

static CGFloat const kRowHeight = 60.0;
static CGFloat const kMargin = 15.0;
static CGFloat const kFontSize = 14.0;

@interface NCNotesListCell ()

// UI elements
@property (nonatomic, strong) UILabel *notesSummary;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;

// Model references

@property (nonatomic, strong) NCNoteObject *noteObject;

@end

@implementation NCNotesListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    CGFloat lblHeight = 20.0;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin, self.contentView.width/2 , lblHeight)];
    [self.titleLabel setFont:[UIFont ncBoldFontOfSize:kFontSize]];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.contentView addSubview:self.titleLabel];
    
    self.notesSummary = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin + lblHeight, self.contentView.width - 2*kMargin, lblHeight)];
    [self.notesSummary setFont:[UIFont ncRegularFontOfSize:kFontSize]];
    [self.notesSummary setTextColor:[NCColors ncSmallLightFontColor]];
    [self.notesSummary setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.contentView addSubview:self.notesSummary];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.width - 105.0, kMargin, 90 , lblHeight)];
    [self.dateLabel setFont:[UIFont ncBoldFontOfSize:kFontSize]];
    [self.dateLabel setTextColor:[NCColors ncSmallLightFontColor]];
    [self.dateLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.dateLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.dateLabel];
}

- (void)setNoteObject:(NCNoteObject *)noteObject {
    if (!noteObject)
        return;
    
    [self.titleLabel setText:noteObject.title];
    [self.notesSummary setText:noteObject.noteString];
    [self.dateLabel setText:noteObject.dateString];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
