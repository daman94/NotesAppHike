//
//  NCDBHandler.m
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import "NCDBHandler.h"

static NSString *const kDbName = @"notes.db";

@interface NCDBHandler ()

@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic) sqlite3 *notesDb;

@end

@implementation NCDBHandler

+ (instancetype)defaultHandler {
    static NCDBHandler *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NCDBHandler alloc] init];
    });
    return _instance;
}

- (void)createInitNotesDb {
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths lastObject];
    
    // Build the path to the database file
    self.databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:kDbName]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_notesDb) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS NOTES (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, NOTE TEXT, DATE TEXT)";
            
            if (sqlite3_exec(self.notesDb, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"failed to create Db");
            }
            sqlite3_close(self.notesDb);
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
}

#pragma mark - util methods
- (void)saveNoteObject:(NCNoteObject *)noteObject {
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_notesDb) == SQLITE_OK)
    {
        NSString *query;
        if (noteObject.identifier) {
            query = [NSString stringWithFormat:
                     @"UPDATE NOTES SET title = \"%@\", note = \"%@\", date = \"%@\" WHERE id = \"%@\"",
                     noteObject.title, noteObject.noteString, noteObject.dateString,noteObject.identifier];
        }else {
          query = [NSString stringWithFormat:
             @"INSERT INTO NOTES (title, note, date) VALUES (\"%@\", \"%@\", \"%@\")",
             noteObject.title, noteObject.noteString, noteObject.dateString];
        }
        
//        NSString *insertSQL = [NSString stringWithFormat:
//                               @"INSERT INTO NOTES (title, note, date) VALUES (\"%@\", \"%@\", \"%@\")",
//                               noteObject.title, noteObject.noteString, noteObject.dateString];
        
        const char *insert_stmt = [query UTF8String];
        sqlite3_prepare_v2(self.notesDb, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            [self showAlertWithMessage:@"Succesfully Added" withTitle:@"Saved"];
        } else {
            NSLog(@"Failed to add contact");
        }
        sqlite3_finalize(statement);
        sqlite3_close(self.notesDb);
    }
}

- (NSArray *)getAllNotes {
    if (!self.databasePath) {
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        docsDir = [dirPaths lastObject];
        
        // Build the path to the database file
        self.databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:kDbName]];

    }
    const char *dbpath = [self.databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *notesArr = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &_notesDb) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT id, title, note, date FROM NOTES";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(self.notesDb,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSLog(@"sqlite row : %d", SQLITE_ROW);
            int stepResult = sqlite3_step(statement);
            NSLog(@"sqlite 3 : %d", stepResult);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                
                NSString *idField = [[NSString alloc]
                                     initWithUTF8String:
                                     (const char *) sqlite3_column_text(
                                                                        statement, 0)];
                
                NSString *titleField = [[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 1)];
                
                NSString *noteField = [[NSString alloc]
                                       initWithUTF8String:(const char *)
                                       sqlite3_column_text(statement, 2)];
                
                NSString *dateField = [[NSString alloc]
                                       initWithUTF8String:(const char *)
                                       sqlite3_column_text(statement, 3)];
                NCNoteObject *newObject = [[NCNoteObject alloc] init];
                newObject.title = titleField;
                newObject.noteString = noteField;
                newObject.identifier = idField;
                [notesArr addObject:newObject];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(self.notesDb);
    }
    return notesArr;
}

- (NCNoteObject *)getNoteWithId:(NSString *)noteIdentifier {
    return nil;
}

- (void)showAlertWithMessage:(NSString *)alertMessage withTitle:(NSString *)titleAlert{
    UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:titleAlert message:alertMessage delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alertSuccess show];
}
@end
