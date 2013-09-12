//
//  GXLibtoolViewController.m
//  BistuWifiV2
//
//  Created by Apple on 13-9-12.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXLibtoolViewController.h"

@interface GXLibtoolViewController ()

@end

@implementation GXLibtoolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}
@end
