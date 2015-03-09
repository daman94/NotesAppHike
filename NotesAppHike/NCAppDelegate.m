//
//  NCAppDelegate.m
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import "NCAppDelegate.h"
#import "NCNotesListViewController.h"
#import "NCDBHandler.h"

@implementation NCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initDb];
    [self prepareWindow];
    return YES;
}

- (void)prepareWindow {
    NCNotesListViewController *notesListController = [[NCNotesListViewController alloc] init];
    
    UINavigationController *navigationControllerBase = [[UINavigationController alloc] initWithRootViewController:notesListController];
    [self setupNavBarForController:navigationControllerBase];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationControllerBase;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)setupNavBarForController:(UINavigationController *)controller {
    controller.navigationBar.translucent = NO;
}

- (void)initDb {
    [[NCDBHandler defaultHandler] createInitNotesDb];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
