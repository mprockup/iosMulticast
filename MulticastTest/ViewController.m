//
//  ViewController.m
//  MulticastTest
//
//  Created by Matthew Prockup on 2/26/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize sendField,sleepSwitch;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //The Multicast setup command is called from the app delegate so we can use the app entering/leaving background commands to open and close sockets properly
    delegate = [[UIApplication sharedApplication] delegate];
    sendField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    packetsList = [[NSMutableArray alloc] init];
    
    
}


-(void)dismissKeyboard {
    [sendField resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"view will appear");
    [self setupMulticast];
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"view will disappear");
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    NSData* data = [sendField.text dataUsingEncoding:NSUTF8StringEncoding];
    //  Send data:
    BOOL success = [delegate.server sendMulticast:data];
    
    if(success)
    {
        [sendField setBackgroundColor:[UIColor greenColor]];
    }
    else
    {
        [sendField setBackgroundColor:[UIColor redColor]];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [sendField setBackgroundColor:[UIColor blackColor]];
    [UIView commitAnimations];
    return YES;
}

-(IBAction)onOffSwitch:(id)sender{
    
    if(sleepSwitch.on) {
        // sleep on
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
    
    else {
        //sleep off
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}



-(void)setupMulticast
{
//    CFArrayRef myArray = CNCopySupportedInterfaces();
//    CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
//    NSString* ssid = (__bridge NSString*) CFDictionaryGetValue(myDict, kCNNetworkInfoKeySSID);
    
    
    NSString* ssid = @"";
    if([NetworkCheck whatIsMyConnectionType] == 0)
    {
        ssid = @"No Connection";
    }
    else if([NetworkCheck whatIsMyConnectionType] == 1)
    {
        ssid = [NetworkCheck whatIsMySSID];
    }
    else{
        ssid = @"Cell Network";
    }
    
    //NSLog(@"SSID: %@",ssid);
    [ssidField setText:ssid];
    NSString* addressPort = [[NSString alloc] initWithFormat:@"%@ : %d",MULTICAST_GROUP_ADDRESS,MULTICAST_PORT];
    
    [ipField setText:addressPort];
    
       
    //  Poll for most recent reveived data
    [NSThread detachNewThreadSelector:@selector(receiveLoop:) toTarget:self withObject:nil];
    
}


- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

- (IBAction)sendData:(id)sender
{
    [sendField resignFirstResponder];
    NSData* data = [sendField.text dataUsingEncoding:NSUTF8StringEncoding];
    //  Send data:
    BOOL success = [delegate.server sendMulticast:data];
    
    if(success)
    {
        [sendField setBackgroundColor:[UIColor greenColor]];
    }
    else
    {
        [sendField setBackgroundColor:[UIColor redColor]];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [sendField setBackgroundColor:[UIColor blackColor]];
    [UIView commitAnimations];
    
    
}

//Loop to slurp the latest sent message from the multicast
-(void)receiveLoop:(id)param
{
    @autoreleasepool {
        while (1)
        {
            NSData* buffer = [delegate.client getCurrentData];
            NSString* strBuffer  = [[NSString alloc] initWithData:buffer encoding:[NSString defaultCStringEncoding]];
            
            [packetsList addObject:strBuffer];
            if([packetsList count]>24)
            {
                [packetsList removeObjectAtIndex:0];
               
            }
            NSMutableString *bigList = [[NSMutableString alloc] init];
            for(int i = 0;i<[packetsList count];i++)
            {
                [bigList appendString:[packetsList objectAtIndex:i]];
                [bigList appendString:@"\n"];
            }
            
            [receiveField performSelectorOnMainThread:@selector(setText:) withObject:bigList waitUntilDone:TRUE];
            
            sleep(1);
        }
        
        
    }
    
}

@end

