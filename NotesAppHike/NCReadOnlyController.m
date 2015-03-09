//
//  NCReadOnlyController.m
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import "NCReadOnlyController.h"
#import "NCNoteObject.h"
#import "NCColors.h"
#import "NCCreateEditNoteController.h"
#import "TTTAttributedLabel.h"

static CGFloat const kMargin = 15.0;
static CGFloat const kFontSize = 14.0;

@interface NCReadOnlyController () <UITableViewDataSource, UITableViewDelegate, NCEditNoteDelegate, TTTAttributedLabelDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NCNoteObject *noteObject;

@property (nonatomic, strong) UITableView *noteTableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *noteLabel;

@end

@implementation NCReadOnlyController

- (id)initWithNoteObject:(NCNoteObject *)noteObject
{
    self = [super init];
    if (self) {
        self.noteObject = noteObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews {
    [self setupTableView];
    [self setupRightBarITem];
}

- (void)setupTableView {
    self.noteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.noteTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.noteTableView setBackgroundColor:[NCColors mainBackgroundColor]];
    self.noteTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.noteTableView setDelegate:self];
    [self.noteTableView setDataSource:self];
    [self.view addSubview:self.noteTableView];
}

- (void)setupRightBarITem {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editNote)];
    
    UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectEmailIcon)];
    self.navigationItem.rightBarButtonItems = @[emailButton,rightBarItem];
}

#pragma mark - uitableviewdelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCellForView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getRowHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self headerView];
}

- (UITableViewCell *)getCellForView {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifierNote"];
    [cell setBackgroundColor:[UIColor whiteColor]];
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(kMargin, kMargin, cell.contentView.width - 2*kMargin, [self getRowHeight])];
    label.font = [UIFont ncRegularFontOfSize:kFontSize];
    label.textColor = [UIColor darkGrayColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
    label.delegate = self; // Delegate methods are called when the user taps on a link (see `TTTAttributedLabelDelegate` protocol)
    label.text = self.noteObject.noteString;
    [cell.contentView addSubview:label];
    return cell;
}
- (UIView *)headerView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60.0)];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin, self.view.width - 110, 60 - 2*kMargin)];
    [titleLabel setFont:[UIFont ncBoldFontOfSize:kFontSize]];
    [titleLabel setText:self.noteObject.title];
    [headerView addSubview:titleLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 110, kMargin, 95, 60 - 2*kMargin)];
    [dateLabel setFont:[UIFont ncBoldFontOfSize:kFontSize]];
    [dateLabel setTextAlignment:NSTextAlignmentRight];
    [dateLabel setText:self.noteObject.dateString];
    [headerView addSubview:dateLabel];
    
    return headerView;
}

- (CGFloat)getRowHeight {
    CGSize size = [self.noteObject.noteString sizeWithFont:[UIFont ncRegularFontOfSize:kFontSize]
                                         constrainedToSize:CGSizeMake(self.view.width - 2*kMargin, CGFLOAT_MAX)
                                             lineBreakMode:NSLineBreakByWordWrapping];
    
    return 2*kMargin + size.height;
}

- (void)editNote {
    NCCreateEditNoteController *notesController = [[NCCreateEditNoteController alloc] initWithNoteObject:self.noteObject];
    notesController.delegate = self;
    
    UINavigationController *containerController = [[UINavigationController alloc] initWithRootViewController:notesController];
    containerController.navigationBar.translucent = NO;
    
    [self presentViewController:containerController animated:YES completion:nil];
}

#pragma mark - ncEditNoteDelegate

- (void)didFinishEditing:(id)sender withObject:(NCNoteObject *)noteObject {
    self.noteObject = noteObject;
    [self.noteTableView reloadData];
}

#pragma mark TTTAttrLabel

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

#pragma Email - functionality

- (void)didSelectEmailIcon {
    NSString *emailTitle = [NSString stringWithFormat:self.noteObject.title,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    // Email Content
    NSString *messageBody = self.noteObject.noteString;
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"feedback@hike.com"];
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        mc.navigationBar.barStyle = UIBarStyleBlack;
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:NSLocalizedString(@"Mail Not Configured", nil)
                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
