//
//  GXNetHttpslink.m
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXNetHttpslink.h"
#include <unistd.h>
@implementation GXNetHttpslink
#pragma mark - static init
+(NSData*)getHttpsContentbyRequest:(NSURLRequest*)request
{
        assert(request!=nil);
    GXNetHttpslink *link=[[GXNetHttpslink alloc]init];
    link->lock=[[NSCondition alloc]init];

    link->working=YES;
    //NSThread *t=[[NSThread alloc]initWithTarget:link selector:@selector(start:) object:request];
    //[t start];
    [link start:request];
//    int i=0;
    while (link->working)
    {
    printf("locking \n");
            [link->lock lock];
    [link->lock waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
              [link->lock unlock];
    }

    printf("unlocked \n");
    return [NSData dataWithData:link.receiveData];
}
+(void)getHttpsContentbyRequest:(NSURLRequest*)request
                      onSuccess:(SEL)onSuccess
                         target:(id)target
{
    [GXNetHttpslink getHttpsContentbyRequest:request onSuccess:onSuccess onfail:nil target:target];
}
+(void)getHttpsContentbyRequest:(NSURLRequest*)request
                      onSuccess:(SEL)onSuccess
                         onfail:(SEL)onfail
                         target:(id)target
{
    GXNetHttpslink *link=[[GXNetHttpslink alloc]init];
    link->lock=[[NSCondition alloc]init];
    link->_onfail=onfail;
    link->_onSuccess=onSuccess;
    link->_target=target;
    [link start:request];
}
-(void)start:(NSURLRequest*)request{
    self.receiveData=[[NSMutableData alloc]init];
    assert(request!=nil);
   self.con=[[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
}
#pragma mark - protocol
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
        self->working=YES;
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
       NSLog(@"code=%d",res.statusCode);
    if (res.statusCode!=200)
    {
    }
    //NSLog(@"%@",[res allHeaderFields]);
  //  self.receiveData = [NSMutableData data];

}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    self->working=YES;
    NSLog(@"recive data\n");
    [self.receiveData appendData:data1];
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
          [self->lock lock];
    self->working=NO;
    [self->lock signal];
          [self->lock unlock];
    if ((_target!=nil)&&(_onSuccess!=nil))
    {
        IMP returnlink=[_target methodForSelector:_onSuccess];
        returnlink(_target,_onSuccess,self.receiveData);
    }
//    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    //  NSLog(@"%@",receiveStr);
    
    
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
        self->working=YES;
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
        self->working=YES;
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        //if ([trustedHosts containsObject:challenge.protectionSpace.host])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ((_target!=nil)&&(_onfail!=nil))
    {
        IMP returnlink=[_target methodForSelector:_onfail];
        returnlink(_target,_onfail,self.receiveData);
    }
}

@end
