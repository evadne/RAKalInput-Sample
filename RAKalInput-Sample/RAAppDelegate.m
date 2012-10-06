//
//  RAAppDelegate.m
//  RAKalInput-Sample
//
//  Created by Evadne Wu on 10/5/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "RAAppDelegate.h"
#import "RAViewController.h"

@implementation RAAppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor blackColor];
	
	self.window.rootViewController = [RAViewController new];
	
	[self.window makeKeyAndVisible];
	
	return YES;
	
}

@end
