//
//  GXBTNWifiToggler.h
//  BistuWifiV2
//
//  Created by Apple on 13-9-11.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXBTNWifiToggler : UIControl
{
    BOOL active_signal[6];
    CGRect selfRECT;
}
-(void)Active_Signal:(int)ID;
-(void)Unactive_Signal:(int)ID;
@end
