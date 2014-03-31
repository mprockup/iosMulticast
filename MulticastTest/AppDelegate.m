//
//  AppDelegate.m
//  MulticastTest
//
//  Created by Matthew Prockup on 2/26/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//
#import "AppDelegate.h"

@implementation AppDelegate
@synthesize client, server;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSLog(@"Finished Launch: Creating Server and Client");
    
    //  Create the client:
    client = [[MulticastClient alloc] init];
    
    //  Setup the multicast parameters
    [client startMulticastListenerOnPort:MULTICAST_PORT withAddress:MULTICAST_GROUP_ADDRESS];
    
    //  Start the listener thread
    [client startListen];
    
    //  Create the server:
    server = [[MulticastServer alloc] init];
    
    //  Setup the multicast parameters:
    [server startMulticastServerOnPort:MULTICAST_PORT withAddress:MULTICAST_GROUP_ADDRESS];

    
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
    NSLog(@"Entering Background: closing Server and Client");
    [client closeSocket];
    [server closeSocket];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    NSLog(@"Enter Foreground: Creating Server and Client");
    
    //  Create the client:
    client = [[MulticastClient alloc] init];
    
    //  Setup the multicast parameters
    [client startMulticastListenerOnPort:MULTICAST_PORT withAddress:MULTICAST_GROUP_ADDRESS];
    
    //  Start the listener thread
    [client startListen];
    
    //  Create the server:
    server = [[MulticastServer alloc] init];
    
    //  Setup the multicast parameters:
    [server startMulticastServerOnPort:MULTICAST_PORT withAddress:MULTICAST_GROUP_ADDRESS];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"Closing App: closing Server and Client");
    
    [client closeSocket];
    [server closeSocket];
}

@end
