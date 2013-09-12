//
//  GXBTNWifiToggler.h
//  BistuWifiV2
//
//  Created by Apple on 13-9-11.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import <UIKit/UIKit.h>
#define __BTNWifiToggler_MaxID__ 7
@interface GXBTNWifiToggler : UIControl
{
    BOOL active_signal[__BTNWifiToggler_MaxID__];
    CGRect selfRECT;
    int light_start;
    int light_end;
    
}
-(void)Active_Signal:(int)ID;
-(void)Unactive_Signal:(int)ID;
@property int light_start;
@property int light_end;
@end
