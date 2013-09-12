//
//  GXBTNWifiTogglerAnimat.h
//  BistuWifiV2
//
//  Created by Apple on 13-9-12.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXBTNWifiToggler.h"
@interface GXBTNWifiTogglerAnimat : NSObject
{
    BOOL WifiSignalAnimatSwich;
    NSTimer *WifiSignalAnimat_signal;
    NSTimer *WifiSignalAnimat_light;
    int activedsign;
    int lightmove;
    
}
-(void)start;
-(void)stop;
-(void)on;
-(void)off;
-(void)toggle;
-(void)drawWifiSignalAnimat_signal;
-(void)drawWifiSignalAnimat_light;
@property (weak, nonatomic) GXBTNWifiToggler *BTNtoggle;
-(id)initWithBTN:(GXBTNWifiToggler*)_BTN;
@end
