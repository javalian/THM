//
//  TestViewController.m
//  THM
//
//  Created by Michael Friel on 2/4/13.
//  Copyright (c) 2013 Central DuPage Hospital. All rights reserved.
//

#import "TestViewController.h"


@implementation TestViewController

@synthesize textField;

- (IBAction)doTheThing:(id)sender
{
    //action here
    [[self textField] setText:@"Hi There"];
}

@end
