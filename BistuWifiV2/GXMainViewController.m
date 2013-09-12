//
//  GXMainViewController.m
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXMainViewController.h"
#import "GXWIfiNetTools.h"
#import "GXNetHttpslink.h"
#import "GXSettingTools.h"
#import <SystemConfiguration/CaptiveNetwork.h>
@interface GXMainViewController ()

@end

@implementation GXMainViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(GXFlipsideViewController *)controller
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}
#pragma mark - wifi

@synthesize receiveData;
@synthesize LInfo;
-(void)reloadseeting
{
    
}
- (void)viewDidLoad
{
    AnimatToggler =[[GXBTNWifiTogglerAnimat alloc]initWithBTN:_BTNtoggle];
    if ([GXWIfiNetTools checknetstatus])
    {
        [AnimatToggler on];
        LInfo.text=@"已连接";
    }
    else
    {
        
        [AnimatToggler off];
        if ([[GXWIfiNetTools fetchSSIDInfo].SSID isEqualToString:@"bistu"]) {
            LInfo.text=@"未连接";
        }
        else
        {
            LInfo.text=@"未连接到热点";
        }
        
    }
    
}
-(IBAction)togglewifi
{
    if ([[GXSettingTools getSettingValueWithItem:@"login_name"] isEqualToString:@""])
    {
        [self performSegueWithIdentifier:@"showAlternate" sender:_BTNLogin];
    }
    else
    {
        if ([GXWIfiNetTools checknetstatus])
        {
            [AnimatToggler start];
            NSURL *urllink=[NSURL URLWithString:@"https://6.6.6.6/login.html"];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urllink];
            [request setHTTPMethod:@"POST"];
            NSString *str=[[NSString alloc]initWithFormat:
                           @"redirect_url=http://www.apple.com/library/test/success.html&buttonClicked=4&username=%@&password=%@"
                           ,[GXSettingTools getSettingValueWithItem:@"login_name"]
                           ,[GXSettingTools getSettingValueWithItem:@"login_pass"]
                           ];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
            [GXNetHttpslink getHttpsContentbyRequest:request onSuccess:@selector(loginsuccess:) target:self];
            
        }
        else
        {
            
            [AnimatToggler off];
            if ([[GXWIfiNetTools fetchSSIDInfo].SSID isEqualToString:@"bistu"]) {
                LInfo.text=@"未连接";
            }
            else
            {
                LInfo.text=@"未连接到热点";
            }
            
        }
    }
}
-(void)loginsuccess:(NSData *)recivedata
{
    
}
-(IBAction)draw
{
    [AnimatToggler toggle];
}

- (IBAction)login {
    if (lock==NO)
    {
        
    }
}
- (IBAction)logout {
    if (lock==NO)
    {
        lock=YES;
        
    }
}


@end
