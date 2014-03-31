//
//  ViewController.h
//  MulticastTest
//
//  Created by Matthew Prockup on 2/26/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MulticastClient.h"
#import "MulticastServer.h"
#import "SystemConfiguration/CaptiveNetwork.h"
#import "NetworkCheck.h"
#import "AppDelegate.h"
#define MULTICAST_GROUP_ADDRESS @"239.255.255.251"
#define MULTICAST_PORT 12345

@interface ViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    @public
//    MulticastClient* client;
//    MulticastServer* server;
    AppDelegate *delegate;
    @protected
        IBOutlet UITextView* ipField;
        IBOutlet UITextView* ssidField;
        IBOutlet UITextView* sendField;
        IBOutlet UITextView* receiveField;
        NSMutableArray* packetsList;
        NSTimer * timer;
}
- (IBAction)sendData:(id)sender;
- (void) setupMulticast;
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
@property (strong, nonatomic) IBOutlet UITextView *sendField;
@property (strong, nonatomic) IBOutlet UISwitch *sleepSwitch;
@end
