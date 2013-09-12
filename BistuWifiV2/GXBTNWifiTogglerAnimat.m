//
//  GXBTNWifiTogglerAnimat.m
//  BistuWifiV2
//
//  Created by Apple on 13-9-12.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXBTNWifiTogglerAnimat.h"

@implementation GXBTNWifiTogglerAnimat
-(void)stop
{
    if (self->WifiSignalAnimatSwich )
    {
        [self->WifiSignalAnimat_signal invalidate];
        [self->WifiSignalAnimat_light invalidate];
        [self reloadtimer];
        [_BTNtoggle Active_Signal:-1];
        self->WifiSignalAnimatSwich=NO;
        lightmove=0;
    }
    
}
-(void)start
{
    if (!(self->WifiSignalAnimatSwich ))
    {
        self->WifiSignalAnimatSwich=YES;
        [[NSRunLoop currentRunLoop]addTimer:WifiSignalAnimat_signal
                                    forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop]addTimer:WifiSignalAnimat_light
                                    forMode:NSDefaultRunLoopMode];
    }
}
-(void)on
{
    [self->WifiSignalAnimat_signal invalidate];
    [self->WifiSignalAnimat_light invalidate];
    [self reloadtimer];
    for (int i=1;i<=5;i++)
    [_BTNtoggle Unactive_Signal:i];
    self->WifiSignalAnimatSwich=NO;
    lightmove=360;
    [self drawWifiSignalAnimat_light];
    
}
-(void)off
{
    [self->WifiSignalAnimat_signal invalidate];
    [self->WifiSignalAnimat_light invalidate];
    [self reloadtimer];
    [_BTNtoggle Active_Signal:-1];
    self->WifiSignalAnimatSwich=NO;
    lightmove=0;
    [self drawWifiSignalAnimat_light];
}
-(void)toggle
{
    if (self->WifiSignalAnimatSwich )
    {
        [self stop];
    }
    else
    {
        [self start];
    }
}
-(void)drawWifiSignalAnimat_signal
{
    if (_BTNtoggle!=nil)
    {
        [_BTNtoggle Active_Signal:(activedsign+1)];
        [_BTNtoggle Unactive_Signal:((activedsign+1)%5+1)];
        activedsign=(activedsign+1)%5;
    }
}
-(void)drawWifiSignalAnimat_light
{
    if (_BTNtoggle!=nil)
    {
        lightmove=(lightmove+1)%720;
        if (lightmove<360)
        {
            _BTNtoggle.light_start=(0)%360;
            _BTNtoggle.light_end=(lightmove)%360;
        }
        else if (lightmove>360)
        {
            _BTNtoggle.light_start=(lightmove-360)%360;
            _BTNtoggle.light_end=(0)%360;
        }
        else
        {
            _BTNtoggle.light_start=(0);
            _BTNtoggle.light_end=(360);
        }
        
        [_BTNtoggle setNeedsDisplay];
    }
}
-(id)initWithBTN:(GXBTNWifiToggler*)_BTN
{
    self=[super init];
    if (self)
    {
        _BTNtoggle=_BTN;
        activedsign=5;
        [_BTNtoggle Active_Signal:-1];
        [self reloadtimer];
        self->WifiSignalAnimatSwich=NO;
    }
    return self;
}
-(void)reloadtimer
{
    self->WifiSignalAnimat_signal=[NSTimer timerWithTimeInterval:0.2
                                                          target:self
                                                        selector:@selector(drawWifiSignalAnimat_signal)
                                                        userInfo:nil
                                                         repeats:YES];
    self->WifiSignalAnimat_light=[NSTimer timerWithTimeInterval:0.01
                                                         target:self
                                                       selector:@selector(drawWifiSignalAnimat_light)
                                                       userInfo:nil
                                                        repeats:YES];
}
@end
