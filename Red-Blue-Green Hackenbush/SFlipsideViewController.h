//
//  SFlipsideViewController.h
//  Red-Blue-Green Hackenbush
//
//  Created by Sam Carlson on 6/19/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SView.h"

@class SFlipsideViewController;

@protocol SFlipsideViewControllerDelegate

- (void)flipsideViewControllerDidFinish:(SFlipsideViewController *)controller;

- (void)changeColor:(lineColor)color;

- (void)activateChildishMode:(BOOL)state;

- (void)activateEditingMode:(BOOL)state;

- (void)maximumDelete;

- (void)retrieveState:(id)receiver;

@end

@interface SFlipsideViewController : UIViewController

@property (weak, nonatomic) id <SFlipsideViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UISegmentedControl *colorControl;

@property (strong, nonatomic) IBOutlet UISwitch *editingMode;

@property (strong, nonatomic) IBOutlet UISwitch *childishMode;

- (IBAction)done:(UISegmentedControl*)sender;

- (void)restoreStateWithColor:(lineColor)color editingMode:(BOOL)editing childishMode:(BOOL)childish;

@end
