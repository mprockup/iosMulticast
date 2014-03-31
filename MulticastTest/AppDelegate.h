//
//  AppDelegate.h
//  MulticastTest
//
//  Created by Matthew Prockup on 2/26/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MulticastServer.h"
#import "MulticastClient.h"
#define MULTICAST_GROUP_ADDRESS @"239.255.255.251"
#define MULTICAST_PORT 12345
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MulticastClient* client;
@property (strong, nonatomic) MulticastServer* server;
    
@end
