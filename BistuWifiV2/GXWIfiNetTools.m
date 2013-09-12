//
//  GXWIfiNetTools.m
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXWIfiNetTools.h"
#import <SystemConfiguration/CaptiveNetwork.h>
@implementation GXWIfiInfo : NSObject
@synthesize SSID;
@synthesize BSSID;
@synthesize SSIDDATA;
@end
@implementation GXWIfiNetTools

+ (id)fetchSSIDInfo
{
   // char ssid[255];
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        NSLog(@"%s: %@ => %@", __func__, ifnam, info);
        if (info && [info count]) {
            break;
        }
        //[info release];
    }
    //[ifs release];
    GXWIfiInfo *ret=nil;
    if (info!=nil)
    {
        ret=[[GXWIfiInfo alloc]init];
        ret.SSID=[info objectForKey:@"SSID"];
        ret.BSSID=[info objectForKey:@"BSSID"];
        ret.SSIDDATA=[[info objectForKey:@"SSIDDATA"]copy];
    }
    
    return ret;
}
+(bool) checknetstatus
{
    NSURL *urllink=[NSURL URLWithString:@"http://www.apple.com/library/test/success.html"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urllink];
    NSData *ret=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];    NSString *receiveStr = [[NSString alloc]initWithData:ret encoding:NSUTF8StringEncoding];
    BOOL retur=[receiveStr isEqualToString:@"<HTML><HEAD><TITLE>Success</TITLE></HEAD><BODY>Success</BODY></HTML>"];
    return retur;
    
}
@end
