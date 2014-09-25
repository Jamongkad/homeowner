//
//  MWAppDelegate.m
//  Homeowner
//
//  Created by Mathew Wong on 8/24/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWAppDelegate.h"
#import "MWNavigationController.h"
#import "MWItemsViewController.h"
#import "MWItemStore.h"

@implementation MWAppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@", self.window.rootViewController);
    if(!self.window.rootViewController) {
        MWItemsViewController *itemsViewController = [[MWItemsViewController alloc] init];
        MWNavigationController *navController = [[MWNavigationController alloc] initWithRootViewController: itemsViewController];
        navController.restorationIdentifier = NSStringFromClass([navController class]);
        self.window.rootViewController = navController;
    }
   
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[MWItemStore sharedStore] saveChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[MWItemStore sharedStore] saveChanges];
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return YES;
}

-(UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    MWNavigationController *vc = [[MWNavigationController alloc] init];
    vc.restorationIdentifier = [identifierComponents lastObject];
    if([identifierComponents count] == 1) {
        self.window.rootViewController = vc;
    }
    
    return vc;
}
@end
