//
//  GXMainViewController.h
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXFlipsideViewController.h"
#import "GXBTNWifiToggler.h"
@interface GXMainViewController : UIViewController <GXFlipsideViewControllerDelegate>
{
    NSTimer *WifiSignalAnim;
    BOOL WifiSignalAnimSwich;
    NSURLConnection *con;
    NSMutableURLRequest *request;
    NSData *data;
    int activedsign;
    bool lock;
    char ssid[255];
}
@property (weak, nonatomic) IBOutlet GXBTNWifiToggler *BTNtoggle;
@property (retain, nonatomic) IBOutlet UIWebView *WVretShower;
@property (retain, nonatomic) IBOutlet UIButton *btnlogout;
@property (retain, nonatomic) IBOutlet UIButton *btnlogin;
@property (retain, nonatomic) IBOutlet UILabel *Lssid;
@property (retain, nonatomic) IBOutlet UIProgressView *Barstatus;
@property (retain, nonatomic) IBOutlet UILabel *Lstatus;
@property (retain,readwrite)     NSMutableData *receiveData;
@property (retain, nonatomic) IBOutlet UITextField *Lusername;
@property (retain, nonatomic) IBOutlet UITextField *Lpassword;
-(IBAction)draw;
-(void)drawWifiSignalAnim;
- (IBAction)login;
- (IBAction)logout;
- (NSString*)fetchSSIDInfo;
-(bool) checknetstatus;
-(void)reloadseeting;
@end
