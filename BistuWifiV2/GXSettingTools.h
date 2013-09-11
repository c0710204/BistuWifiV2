//
//  GXSettingTools.h
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXSettingTools : NSObject
+(id)getSettingValueWithItem:(NSString*)item;
+(void)setSettingValue:(id)value WithItem:(NSString*)item;
@end

