//
//  GXWIfiNetTools.h
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GXWIfiInfo : NSObject
@property (copy,readwrite)NSString* BSSID;
@property (copy,readwrite)NSString* SSID;
@property (retain,readwrite)id SSIDDATA;
@end
@interface GXWIfiNetTools : NSObject

+ (GXWIfiInfo*)fetchSSIDInfo;
+(bool) checknetstatus;

@end
