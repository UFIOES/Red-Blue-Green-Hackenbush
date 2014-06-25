//
//  SFlipsideViewController.m
//  Red-Blue-Green Hackenbush
//
//  Created by Sam Carlson on 6/19/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import "SFlipsideViewController.h"

@interface SFlipsideViewController ()

@end

@implementation SFlipsideViewController

- (void)awakeFromNib {
    self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    [_delegate retrieveState:self];
    
}

- (void)restoreStateWithColor:(lineColor)color editingMode:(BOOL)editing childishMode:(BOOL)childish {
    
    _colorControl.selectedSegmentIndex = color;
    
    [_editingMode setOn:editing];
    
    [_childishMode setOn:childish];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)changeColor:(UISegmentedControl*)sender {
    
    [_delegate changeColor:sender.selectedSegmentIndex];
    
}

- (IBAction)activateChildishMode:(UISwitch *)sender {
    
    [_delegate activateChildishMode:sender.isOn];
    
}
- (IBAction)activateEditingMode:(UISwitch *)sender {
    
    [_delegate activateEditingMode:sender.isOn];
    
}

- (IBAction)maximumDelete:(UIButton *)sender {
    
    [_delegate maximumDelete];
    
}

@end
