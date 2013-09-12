//
//  GXLibtoolViewController.h
//  BistuWifiV2
//
//  Created by Apple on 13-9-12.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GXLibtoolViewController;
@protocol GXlibViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(GXLibtoolViewController *)controller;
@end

@interface GXLibtoolViewController : UIViewController
@property (weak, nonatomic) id <GXlibViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;

@end
