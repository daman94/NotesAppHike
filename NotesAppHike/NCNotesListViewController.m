//
//  NCNotesListViewController.m
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import "NCNotesListViewController.h"
#import "NCNotesListCell.h"
#import "NCColors.h"
#import "NCCreateEditNoteController.h"
#import "NCDBHandler.h"
#import "NCReadOnlyController.h"

static CGFloat const kRowHeight = 60.0;

static NSString *const kDummyCellIdentifier = @"kDummyCellIdentifier";

@interface NCNotesListViewController () <UITableViewDataSource, UITableViewDelegate, NCEditNoteDelegate>

@property (nonatomic, strong) UITableView *notesTableView;
@property (nonatomic, strong) NSArray *savedNotesArray;

@end

@implementation NCNotesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavItem];
    [self setupListView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchAllSavedNotes];
    [super viewWillAppear:animated];
}


#pragma mark - view creation methods

- (void)setupNavItem {
    self.navigationItem.title = @"Notes";
    
    UIBarButtonItem *createNoteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                      target:self
                                                                                      action:@selector(createNewNote:)];
    self.navigationItem.rightBarButtonItem = createNoteButton;
}

- (void)setupListView {
    self.notesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.notesTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.notesTableView setBackgroundColor:[NCColors mainBackgroundColor]];
    [self.notesTableView registerClass:[NCNotesListCell class]
                forCellReuseIdentifier:[NCNotesListCell reuseIdentifier]];
    [self.notesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDummyCellIdentifier];
    [self.notesTableView setDelegate:self];
    [self.notesTableView setDataSource:self];
    [self.view addSubview:self.notesTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - functional methods

- (void)createNewNote:(id)sender {
    NCCreateEditNoteController *notesController = [[NCCreateEditNoteController alloc] initWithNoteObject:nil];
    notesController.delegate = self;
    
    UINavigationController *containerController = [[UINavigationController alloc] initWithRootViewController:notesController];
    containerController.navigationBar.translucent = NO;
    
    [self presentViewController:containerController animated:YES completion:nil];
}

- (void)fetchAllSavedNotes {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSArray *savedNotes = [[NCDBHandler defaultHandler] getAllNotes];
    if ([savedNotes count] == 0) {
        self.savedNotesArray = nil;
    } else {
        self.savedNotesArray = savedNotes;
    }
    
    [self.notesTableView reloadData];
    [SVProgressHUD dismiss];
}

#pragma mark - ncEditNoteDelegate

- (void)didFinishEditing:(id)sender withObject:(NCNoteObject *)noteObject {
    // do nothing
}

#pragma mark - uitableviewdelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.savedNotesArray && [self.savedNotesArray count] > 0? [self.savedNotesArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.savedNotesArray || [self.savedNotesArray count] == 0) {
        // dummy no results cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDummyCellIdentifier];
        [cell.textLabel setText:@"no notes saved.."];
        [cell.textLabel setTextColor:[NCColors ncSmallLightFontColor]];
        return cell;
    }
    
    NCNotesListCell *cell = [tableView dequeueReusableCellWithIdentifier:[NCNotesListCell reuseIdentifier]];
    NCNoteObject *currentNote = self.savedNotesArray[indexPath.row];
    [cell setNoteObject:currentNote];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.savedNotesArray && [self.savedNotesArray count] > 0) {
        // show display view
        NCReadOnlyController *readOnly = [[NCReadOnlyController alloc] initWithNoteObject:self.savedNotesArray[indexPath.row]];
        [self.navigationController pushViewController:readOnly animated:YES];
    }
}

@end
