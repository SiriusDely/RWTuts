//
//  KIFTestStep+SCAdditions.m
//  SampleProject
//
//  Created by SiriusDely on 6/28/13.
//  Copyright (c) 2013 Suitmedia. All rights reserved.
//

#import "KIFTestStep+SCAdditions.h"

@implementation KIFTestStep (SCAdditions)

+ (id)stepToReset {
  return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
    BOOL successfulReset = YES;
    
    // Do the actual reset for your app. Set successfulReset = NO if it fails.
    
    KIFTestCondition(successfulReset, error, @"Failed to reset the application.");
    
    return KIFTestStepResultSuccess;
  }];
}

#pragma mark - Step Collections

+ (NSArray *)stepsToGoToLoginPage {
  NSMutableArray *steps = [NSMutableArray array];
  
  // Dismiss the welcome message
  [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"That's awesome!"]];
  
  // Tap the "I already have an account" button
  [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"I already have an account."]];
  
  return steps;
}

@end
