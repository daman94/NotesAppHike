//
//  NCCreateEditNoteController.m
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import "NCCreateEditNoteController.h"
#import "NCNoteObject.h"
#import "NCDBHandler.h"

static CGFloat const kMargin = 15.0;
static CGFloat const kFontSize = 14.0;

@interface NCCreateEditNoteController () <UITextViewDelegate>

// objects
@property (nonatomic, strong) NCNoteObject *noteObject;

// views
@property (nonatomic, strong) UITextField *titleLabel;
@property (nonatomic, strong) UITextView *noteLabel;

@end

@implementation NCCreateEditNoteController

- (id)initWithNoteObject:(NCNoteObject *)notesObject {
    self = [super init];
    if (self) {
        if (notesObject) {
            self.noteObject = notesObject;
        } else {
            // create new note
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];
    [self observeKeyboard];
    [self setupNavBar];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupSubviews {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (self.noteObject) {
        self.navigationItem.title = @"Edit Note";
    } else {
        self.navigationItem.title = @"New Note";
    }
    
    CGFloat kTitleLblHeight = 50.0;
    self.titleLabel = [[UITextField alloc] initWithFrame:CGRectMake(kMargin, kMargin, self.view.width - 2*kMargin, kTitleLblHeight)];
    [self.titleLabel setFont:[UIFont ncBoldFontOfSize:kFontSize]];
    [self.titleLabel addTarget:self action:@selector(onTitleDidEditing) forControlEvents: UIControlEventEditingChanged];
    [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleBottomMargin];
    self.titleLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    self.titleLabel.layer.borderWidth = 0.8;
    self.titleLabel.autocorrectionType = UITextAutocorrectionTypeNo;
    self.titleLabel.placeholder = @"title";
    [self.titleLabel setBackgroundColor:[UIColor whiteColor]];
    self.titleLabel.layer.cornerRadius = 4.0;
    [self.view addSubview:self.titleLabel];
    
    self.noteLabel = [[UITextView alloc] initWithFrame:CGRectMake(kMargin, 2*kMargin + kTitleLblHeight, self.view.width - 2*kMargin, self.view.height - 3*kMargin - kTitleLblHeight)];
    [self.noteLabel setFont:[UIFont ncBoldFontOfSize:kFontSize]];
    self.noteLabel.delegate = self;
    [self.noteLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight];
    self.noteLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    self.noteLabel.layer.borderWidth = 0.8;
    self.noteLabel.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.noteLabel setBackgroundColor:[UIColor whiteColor]];
    self.noteLabel.returnKeyType = UIReturnKeyDone;
    self.noteLabel.layer.cornerRadius = 4.0;
    [self.view addSubview:self.noteLabel];
    
    if (self.noteObject) {
        [self.titleLabel setText:self.noteObject.title];
        [self.noteLabel setText:self.noteObject.noteString];
    }
    [self addDoneToolbar];
}

- (void)addDoneToolbar {
    // DONE TOOLBAR
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [doneToolbar sizeToFit];
    self.noteLabel.inputAccessoryView = doneToolbar;
    self.titleLabel.inputAccessoryView = doneToolbar;
}

- (void)setupNavBar {
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
    
    self.navigationItem.leftBarButtonItem = cancelItem;
    
}

#pragma mark - keyboard funtions

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGRect finalKeyboardFrame = [self.view convertRect:keyboardFrame fromView:self.view.window];
    
    int kbHeight = finalKeyboardFrame.size.height;
    
    int height = self.view.height - kbHeight - 3*kMargin -50.0;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.noteLabel setFrame:CGRectMake(self.noteLabel.x, self.noteLabel.y
                                            , self.noteLabel.width, height)];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.noteLabel setFrame:CGRectMake(kMargin, 2*kMargin + 50.0, self.view.width - 2*kMargin, self.view.height - 3*kMargin - 50.0)];
    }];
}

#pragma mark - uitextview delegates

- (void)doneButtonClickedDismissKeyboard {
    [self.noteLabel resignFirstResponder];
    [self.titleLabel resignFirstResponder];
}

- (void)onTitleDidEditing {
    if (![self.titleLabel.text isEqualToString:self.noteObject.title] || ![self.noteLabel.text isEqualToString:self.noteObject.noteString]) {
        [self showSaveBarItem];
    } else {
        [self removeSaveBarItem];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (![self.noteLabel.text isEqualToString:self.noteObject.noteString] || ![self.titleLabel.text isEqualToString:self.noteObject.title]) {
        [self showSaveBarItem];
    } else {
        [self removeSaveBarItem];
    }
}

#pragma mark - navigation methods

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAndDismissController {
    NCNoteObject *createdObject = [[NCNoteObject alloc] init];
    createdObject.noteString = self.noteLabel.text;
    createdObject.title = self.titleLabel.text;
    createdObject.modifiedDate = [NSDate date];
    createdObject.identifier = self.noteObject? self.noteObject.identifier : nil;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[NCDBHandler defaultHandler] saveNoteObject:createdObject];
    if (self.delegate) {
        [self.delegate didFinishEditing:self withObject:createdObject];
    }
    [SVProgressHUD dismiss];
    
    // data saved
    [self dismissController];
}

- (void)showSaveBarItem {
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndDismissController)];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)removeSaveBarItem {
    self.navigationItem.rightBarButtonItem = nil;
}

@end
