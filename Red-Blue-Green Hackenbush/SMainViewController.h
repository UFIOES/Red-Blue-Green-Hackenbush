//
//  SMainViewController.h
//  Red-Blue-Green Hackenbush
//
//  Created by Sam Carlson on 6/19/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import "SFlipsideViewController.h"

#import "SView.h"

@interface SMainViewController : UIViewController <SFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property (strong, nonatomic) SView* view;

@end
