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

//retrieves state to show correct settings, not the default
- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    [_delegate retrieveState:self];
    
}

//used to make sure the settings pane defaults to the correct state instead of the default
- (void)restoreStateWithColor:(lineColor)color editingMode:(BOOL)editing childishMode:(BOOL)childish nodeSnapRange:(float)snapRange outputSurreal:(SSurreal*)surreal {
    
    _colorControl.selectedSegmentIndex = color;
    
    [_editingMode setOn:editing];
    
    [_childishMode setOn:childish];
    
    [_snapRange setValue:snapRange];
    
    NSString* string = @"ERROR";
    
    if (!surreal.hasValue) {
        
        string = [surreal toString];
        
    } else {
        
        string = @"0";
        
        double realValue = surreal.value.getReal();
        
        unsigned int starValue = surreal.value.getStar();
        
        if (realValue != 0) {
            
            string = [NSString stringWithFormat:@"%.*f", 12, realValue];
            
            unsigned long i = string.length - 1;
            
            while (YES) {
                
                if ([string characterAtIndex:i] != '0' || [string characterAtIndex:i] == '.') break;
                
                i--;
                
            }
            
            string = [string substringToIndex:i+1];
            
            if (starValue != 0) {
                
                string = [string stringByAppendingString:[NSString stringWithFormat:@" + *%u", starValue]];
                
            }
            
        } else if (starValue != 0) {
            
            string = [NSString stringWithFormat:@"*%u", starValue];
            
        }
        
    }
    
    [_output setText:string];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    [self.delegate flipsideViewControllerDidFinish:self];
}

//change the color of created lines
- (IBAction)changeColor:(UISegmentedControl*)sender {
    
    [_delegate changeColor:(lineColor) sender.selectedSegmentIndex];
    
}

//Change between normal and childish hackenbush
- (IBAction)activateChildishMode:(UISwitch *)sender {
    
    [_delegate activateChildishMode:sender.isOn];
    
}

//switch between editing (line creation) mode, and cutting mode
- (IBAction)activateEditingMode:(UISwitch *)sender {
    
    [_delegate activateEditingMode:sender.isOn];
    
}

//change the range of node snapping
- (IBAction)changeSnapRange:(UISlider *)sender {
    
    [_delegate changeSnapRange:sender.value];
    
}

//Remove all lines and all nodes, cleanup
- (IBAction)maximumDelete:(UIButton *)sender {
    
    [_delegate maximumDelete];
    
}

@end
