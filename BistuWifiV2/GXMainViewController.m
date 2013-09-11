//
//  GXMainViewController.m
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXMainViewController.h"
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

@synthesize Lusername;
@synthesize Lpassword;
@synthesize Lssid;
@synthesize Lstatus;
@synthesize WVretShower;
@synthesize btnlogin;
@synthesize btnlogout;
@synthesize Barstatus;
@synthesize receiveData;

-(void)reloadseeting
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.Lpassword.text=[defaults objectForKey:@"login_pass"];
    self.Lusername.text=[defaults objectForKey:@"login_name"];
    // NSLog(@"reloaded");
}
-(bool) checknetstatus
{
    lock=YES;
    self.receiveData =[[NSMutableData alloc]init];
    NSURL *urllink=[NSURL URLWithString:@"http://www.apple.com/library/test/success.html"];
    request = [NSMutableURLRequest requestWithURL:urllink];
    NSData *ret=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];    NSString *receiveStr = [[NSString alloc]initWithData:ret encoding:NSUTF8StringEncoding];
    BOOL retur=[receiveStr isEqualToString:@"<HTML><HEAD><TITLE>Success</TITLE></HEAD><BODY>Success</BODY></HTML>"];
    lock=NO;
    return retur;
    
}
- (id)fetchSSIDInfo
{
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        NSLog(@"%s: %@ => %@", __func__, ifnam, info);
        if (info && [info count]) {
            break;
        }
            //[info release];
    }
    //[ifs release];
    if (info!=nil)
        strcpy(ssid, [[info objectForKey:@"SSID"]UTF8String]);
    return info;
}
- (void)viewDidLoad
{
    /*
    lock=NO;
    [super viewDidLoad];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.Lpassword.text=[defaults objectForKey:@"login_pass"];
    self.Lusername.text=[defaults objectForKey:@"login_name"];
    bool autologin=[defaults objectForKey:@"login_isautologin"];
	// Do any additional setup after loading the view, typically from a nib.
    NSString* info=[self fetchSSIDInfo];
    if (info!=nil)
    {
        NSLog(@"%s",ssid);
        self.Lssid.text=[NSString stringWithUTF8String: ssid];
        if (self.checknetstatus)
        {
            self.Lstatus.text=@"已连接";
            // self.btnlogin.enabled=NO;
            
        }
        else
        {
            self.Lstatus.text=@"未连接";
            //  self.btnlogout.enabled=NO;
        }
        //     NSLog(@"status check ok!");
    }
    else
    {
        self.Lstatus.text=@"无网络连接";
    }
    //    NSLog(@"status check ok!");
    if ((autologin)&&([self.Lstatus.text isEqualToString: @"未连接"])&&([self.Lssid.text isEqualToString: @"Bistu"]))
    {
        NSLog(@"autologin");
        [self login];
    }
     */
    //_BTNtoggle dr
    activedsign=5;
    [_BTNtoggle Active_Signal:-1];
    self->WifiSignalAnim=    [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(drawWifiSignalAnim) userInfo:nil repeats:YES];
            self->WifiSignalAnimSwich=NO;
}
-(IBAction)draw
{
    if (self->WifiSignalAnimSwich )
    {
        [self->WifiSignalAnim invalidate];
        self->WifiSignalAnim=[NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(drawWifiSignalAnim) userInfo:nil repeats:YES];
    [_BTNtoggle Active_Signal:-1];
        self->WifiSignalAnimSwich=NO;
    }
    else
    {        self->WifiSignalAnimSwich=YES;
        [[NSRunLoop currentRunLoop]addTimer:WifiSignalAnim
                                    forMode:NSDefaultRunLoopMode];
    }
}
-(void)drawWifiSignalAnim
{
    [_BTNtoggle Active_Signal:(activedsign+1)];
    [_BTNtoggle Unactive_Signal:((activedsign+1)%5+1)];
    activedsign=(activedsign+1)%5;
    NSLog(@"activesign=%d\n",activedsign);
}
- (IBAction)login {
    if (lock==NO)
    {
        lock=YES;
        self.btnlogout.enabled=NO;
        self.btnlogin.enabled=NO;
        NSURL *urllink=[NSURL URLWithString:@"https://6.6.6.6/login.html"];
        
        request = [NSMutableURLRequest requestWithURL:urllink];
        [request setHTTPMethod:@"POST"];
        NSString *str=[[NSString alloc]initWithFormat:
                        @"redirect_url=http://www.apple.com/library/test/success.html&buttonClicked=4&username=%@&password=%@",
                        self.Lusername.text,
                        self.Lpassword.text
                        ];
        data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        self->con=[[NSURLConnection alloc]initWithRequest:request delegate:self];
        self.Lstatus.text=@"连接中";
        self.Barstatus.progress=0.3;
    }
    
}
//接收到服务器回应的时候调用此方法

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    //   NSLog(@"code=%d",res.statusCode);
    if (res.statusCode!=200)
    {
        self.btnlogout.enabled=YES;
        self.btnlogin.enabled=YES;
        self.Lstatus.text=@"连接失败";
        // _TVretShower.text=[NSString stringWithFormat:@"%d",res.statusCode];
        self.Barstatus.progress=0;
        
    }
    //NSLog(@"%@",[res allHeaderFields]);
    self.receiveData = [NSMutableData data];
    self.Lstatus.text=@"传输中";
    self.Barstatus.progress=0.6;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [self.receiveData appendData:data1];
}//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    self.btnlogout.enabled=YES;
    self.btnlogin.enabled=YES;
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    //  NSLog(@"%@",receiveStr);
    self.Lstatus.text=@"处理完成";
    //   self.TVretShower.text=receiveStr;
    [self.WVretShower loadHTMLString:receiveStr baseURL:nil];
    self.Barstatus.progress=1;
    lock=NO;
    
    
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        //if ([trustedHosts containsObject:challenge.protectionSpace.host])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
- (IBAction)logout {
    if (lock==NO)
    {
        lock=YES;
        self.btnlogout.enabled=NO;
        self.btnlogin.enabled=NO;
        NSURL *urllink=[NSURL URLWithString:@"https://6.6.6.6/logout.html"];
        
        request = [NSMutableURLRequest requestWithURL:urllink];
        [request setHTTPMethod:@"POST"];
        NSString *str=[[NSString alloc]initWithFormat:
                        @"logout=logout&userStatus=1"
                        ];
        data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
                con=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.btnlogout.enabled=YES;
    self.btnlogin.enabled=YES;
    self.Lstatus.text=@"连接失败";
    // self.TVretShower.text=[error description];
    self.Barstatus.progress=0;
    lock=NO;
}

@end
