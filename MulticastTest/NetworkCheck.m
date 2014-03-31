//
//  NetworkCheck.m
//  iNotes
//
//  Created by Administrator on 2/4/14.
//
//

#import "NetworkCheck.h"

@implementation NetworkCheck
+(NSString*) whatIsMySSID{
    
    if([self whatIsMyConnectionType]==1)
    {
        CFArrayRef myArray = CNCopySupportedInterfaces();
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        

        NSString* ssid = (NSString*) CFDictionaryGetValue(myDict, kCNNetworkInfoKeySSID);
        
        CFRelease(myArray);
        CFRelease(myDict);
        
        return ssid;
    }
    else{
        return nil;
    }
    
}

+(int) whatIsMyConnectionType{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable)
    {
        //No internet
        return 0;
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        return 1;
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        return 2;
    }
    else{
        return 0;
    }

}

@end
