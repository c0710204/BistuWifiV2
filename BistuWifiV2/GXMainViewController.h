//
//  GXMainViewController.h
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXFlipsideViewController.h"
#import "GXBTNWifiTogglerAnimat.h"
@interface GXMainViewController : UIViewController <GXFlipsideViewControllerDelegate>
{
    GXBTNWifiTogglerAnimat *AnimatToggler;
    BOOL lock;
    char ssid[255];
}
@property (weak, nonatomic) IBOutlet UIButton *BTNLogin;
@property (weak, nonatomic) IBOutlet UILabel *LInfo;
@property (weak, nonatomic) IBOutlet GXBTNWifiToggler *BTNtoggle;
@property (retain,readwrite)     NSMutableData *receiveData;
-(IBAction)togglewifi;
- (IBAction)login;
- (IBAction)logout;
-(void)loginsuccess:(NSData *)recivedata;
@end
