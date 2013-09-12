//
//  GXFlipsideViewController.m
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXFlipsideViewController.h"
#import "GXNetHttpslink.h"
#import "GXSettingTools.h"
#import "GXWIfiNetTools.h"
@interface GXFlipsideViewController ()

@end

@implementation GXFlipsideViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(GXLibtoolViewController *)controller
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate1"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}
#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

#pragma mark - wifi

@synthesize Lusername;
@synthesize Lpassword;
@synthesize Lssid;
@synthesize Lstatus;

@synthesize btnlogin;
@synthesize btnlogout;
@synthesize Barstatus;
@synthesize receiveData;

-(void)reloadsetting
{
    self.Lpassword.text=[GXSettingTools getSettingValueWithItem:@"login_pass"];
    self.Lusername.text=[GXSettingTools getSettingValueWithItem:@"login_name"];
    bool libtool =[GXSettingTools getSettingValueWithItem:@"login_islibtool"];
    if (libtool)
    {
        _BTNLibtool.hidden=NO;
        _BTNLibtool.enabled=YES;
    }
    
    // NSLog(@"reloaded");
}

- (void)viewDidLoad
{
    bool autologin =[GXSettingTools getSettingValueWithItem:@"login_isautologin"];

    
    lock=NO;
    [super viewDidLoad];
    
    //libtool open

    [self reloadsetting];
	// Do any additional setup after loading the view, typically from a nib.
    NSString* info=[GXWIfiNetTools fetchSSIDInfo].SSID;
    if (info!=nil)
    {
       // NSLog(@"%s",ssid);
        self.Lssid.text=info;
        if ([GXWIfiNetTools checknetstatus])
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
    
}

- (IBAction)login {
    if (lock==NO)
    {
        [GXSettingTools setSettingValue:self.Lusername.text WithItem:@"login_name"];
        [GXSettingTools setSettingValue:self.Lpassword.text WithItem:@"login_pass"];
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
        /*
        self.receiveData=[NSMutableData dataWithData:[GXNetHttpslink getHttpsContentbyRequest:request]];
        NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
        NSLog(receiveStr);
         */
        [GXNetHttpslink getHttpsContentbyRequest:request onSuccess:@selector(loginsuccess:) target:self];
        self.Lstatus.text=@"连接中";
        self.Barstatus.progress=0.3;
    }
    
}
-(void)loginsuccess:(NSData *)recivedata
{
    
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
    //[self.WVretShower loadHTMLString:receiveStr baseURL:nil];
    self.Barstatus.progress=1;
    lock=NO;
    
    if ([GXWIfiNetTools checknetstatus])
    {
        self.Lstatus.text=@"已成功连接";
        // self.btnlogin.enabled=NO;
        
    }
    else
    {
        self.Lstatus.text=@"已成功断开连接";
        //  self.btnlogout.enabled=NO;
    }

    
    
    
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
