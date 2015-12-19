//
//  ViewController.m
//  unit-3-final-assessment
//
//  Created by Michael Kavouras on 11/30/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

#import "C4QColorPickerViewController.h"
#import "C4QViewController.h"

@interface C4QViewController () <C4QColorPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *onwardButton;

@end

@implementation C4QViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (CGColorEqualToColor(self.view.backgroundColor.CGColor, [UIColor blueColor].CGColor)) {
        
        self.onwardButton.hidden = NO;
        
    } else {
        
        self.onwardButton.hidden = YES;
    }
}

- (void)userDidPickColor:(UIColor *)color {
    
    self.view.backgroundColor = color;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"colorPickerSegue"]) {
        
        C4QColorPickerViewController *destinationVC = [segue destinationViewController];
        destinationVC.delegate = self;
    }
    
}

@end
