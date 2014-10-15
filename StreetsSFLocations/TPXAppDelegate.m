//
//  TPXAppDelegate.m
//  StreetsSFLocations
//
//  Created by pixelhacker on 2/1/14.
//  Copyright (c) 2014 tinypixel. All rights reserved.
//

#import "TPXAppDelegate.h"

@implementation TPXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //Parse Hook
    [Parse setApplicationId:@"9bPr0XQlaoxJBNjKKNjyKcvPR34FrxsmdLhouWX7"
                  clientKey:@"HiBGEphkoLRjZoFNQva91BDrgpZn4LXqElr5A6P2"];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:64/255.0 green:77/255.0 blue:87/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:213/255.0 alpha:1.0]];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application{
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
}

- (void)applicationWillTerminate:(UIApplication *)application{
}

@end
