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

//change the color of created lines from the main view
- (IBAction)changeColorAndEditing:(UISegmentedControl*)sender {
    
    if (sender.selectedSegmentIndex == 3) {
        
        self.view.editingMode = NO;
        
    } else {
        
        self.view.editingMode = YES;
        
        self.view.color = (lineColor) sender.selectedSegmentIndex;
        
    }
    
    [self.view setNeedsDisplay];
    
}

//change the color of created lines
- (void)changeColor:(lineColor)color {
    
    self.view.color = color;
    
    [self.view setNeedsDisplay];
    
}

//Change between normal and childish hackenbush
- (void)activateChildishMode:(BOOL)state {
    
    self.view.childishMode = state;
    
    [self.view setNeedsDisplay];
    
}

//switch between editing (line creation) mode, and cutting mode
- (void)activateEditingMode:(BOOL)state {
    
    self.view.editingMode = state;
    
    [self.view setNeedsDisplay];
    
}

- (void)changeSnapRange:(float)value {
    
    self.view.nodeSnapRange = value;
    
    [self.view setNeedsDisplay];
    
}

//Remove all lines and all nodes, cleanup
- (void)maximumDelete {
    
    [self.view maximumDelete];
    
    [self.view setNeedsDisplay];
    
}

//used to make sure the settings pane defaults to the correct state instead of the default
- (void)retrieveState:(id)receiver {
    
    lineColor color = self.view.color;
    
    BOOL editing = self.view.editingMode;
    
    BOOL childish = self.view.childishMode;
    
    float snapRange = self.view.nodeSnapRange;
    
    double value = [self.view findValue];
    
    [receiver restoreStateWithColor:color editingMode:editing childishMode:childish nodeSnapRange:snapRange outputValue:value];
    
}

//
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.flipsidePopoverController = nil;
}

//
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

//
- (IBAction)togglePopover:(id)sender {
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
