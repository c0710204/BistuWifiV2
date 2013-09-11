//
//  GXNetHttpslink.h
//  BistuWifiV2
//
//  Created by Apple on 13-9-9.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXNetHttpslink : NSObject
{
    NSCondition *lock;
    bool working;
    SEL _onSuccess;
    SEL _onfail;
    id _target;
}
@property (retain,readwrite)     NSMutableData *receiveData;
@property (retain,readwrite)   NSURLRequest *request;
@property (retain,readwrite)     NSURLConnection *con;
+(NSData*)getHttpsContentbyRequest:(NSURLRequest*)request;
+(void)getHttpsContentbyRequest:(NSURLRequest*)request
                      onSuccess:(SEL)onSuccess
                         target:(id)target;
+(void)getHttpsContentbyRequest:(NSURLRequest*)request
                      onSuccess:(SEL)onSuccess
                         onfail:(SEL)onfail
                         target:(id)target;
-(void)start:(NSURLRequest*)request;
@end
