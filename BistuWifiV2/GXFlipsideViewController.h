//
//  GXFlipsideViewController.h
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXFlipsideViewController;

@protocol GXFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(GXFlipsideViewController *)controller;
@end

@interface GXFlipsideViewController : UIViewController
{
    NSURLConnection *con;
    NSMutableURLRequest *request;
    NSData *data;
    bool lock;
    char ssid[255];
}
@property (weak, nonatomic) id <GXFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

//@property (retain, nonatomic) IBOutlet UIWebView *WVretShower;
@property (retain, nonatomic) IBOutlet UIButton *btnlogout;
@property (retain, nonatomic) IBOutlet UIButton *btnlogin;
@property (retain, nonatomic) IBOutlet UILabel *Lssid;
@property (retain, nonatomic) IBOutlet UIProgressView *Barstatus;
@property (retain, nonatomic) IBOutlet UILabel *Lstatus;
@property (retain,readwrite)     NSMutableData *receiveData;
@property (retain, nonatomic) IBOutlet UITextField *Lusername;
@property (retain, nonatomic) IBOutlet UITextField *Lpassword;
- (IBAction)login;
-(void)loginsuccess:(NSData *)recivedata;
- (IBAction)logout;
- (NSString*)fetchSSIDInfo;
-(bool) checknetstatus;
-(void)reloadseeting;
@end
