//
//  GXWIfiNetTools.m
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXWIfiNetTools.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation GXWIfiNetTools

+ (id)fetchSSIDInfo
{
    char ssid[255];
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
    if (info!=nil)
        strcpy(ssid, [[info objectForKey:@"SSID"]UTF8String]);
    return info;
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
