//
//  NetworkCheck.h
//  iNotes
//
//  Created by Administrator on 2/4/14.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface NetworkCheck : NSObject


+(NSString*) whatIsMySSID; //checks ssid
//Returns:
//      SSID if Wifi Connected
//      nil if Wifi Not Connected

+(int) whatIsMyConnectionType; //checks network connection type
//Returns:
//          0 if no connection
//          1 if cell connection
//          2 if wifi connection

@end
