//
//  ISAppDelegate.m
//  ImageSlicer
//
//  Created by Markus on 26.10.13.
//  Copyright (c) 2013 nxtbgthng. All rights reserved.
//

#import "ISViewController.h"

#import "ISAppDelegate.h"

@implementation ISAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController: [[ISViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
