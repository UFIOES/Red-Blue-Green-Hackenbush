//
//  SMainViewController.m
//  Red-Blue-Green Hackenbush
//
//  Created by Sam Carlson on 6/19/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import "SMainViewController.h"

@interface SMainViewController ()

@end

@implementation SMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view = [self.view init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(SFlipsideViewController *)controller {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)changeColor:(lineColor)color {
    
    self.view.color = color;
    
}

- (void)activateChildishMode:(BOOL)state {
    
    self.view.childishMode = state;
    
}

- (void)activateEditingMode:(BOOL)state {
    
    self.view.editingMode = state;
    
}

- (void)maximumDelete {
    
    [self.view maximumDelete];
    
}

- (void)retrieveState:(id)receiver {
    
    lineColor color = self.view.color;
    
    BOOL editing = self.view.editingMode;
    
    BOOL childish = self.view.childishMode;
    
    [receiver restoreStateWithColor:color editingMode:editing childishMode:childish];
    
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender {
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
