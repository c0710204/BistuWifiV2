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

@property (weak, nonatomic) id <GXFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
