//
//  GXSettingTools.m
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXSettingTools.h"

@implementation GXSettingTools

+(id)getSettingValueWithItem:(NSString*)item
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:item];
}
+(void)setSettingValue:(id)value WithItem:(NSString*)item
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:item];
}
@end
