//
//  KIFTestScenario+SCAdditions.m
//  SampleProject
//
//  Created by SiriusDely on 6/28/13.
//  Copyright (c) 2013 Suitmedia. All rights reserved.
//

#import "KIFTestScenario+SCAdditions.h"
#import "KIFTestStep+SCAdditions.h"

@implementation KIFTestScenario (SCAdditions)

+ (id)scenarioToLogin {
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
  [scenario addStep:[KIFTestStep stepToReset]];
  // [scenario addStepsFromArray:[KIFTestStep stepsToGoToLoginPage]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"user@example.com" intoViewWithAccessibilityLabel:@"Username or Email Address"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"thisismypassword" intoViewWithAccessibilityLabel:@"Password"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Login"]];
  
  // Verify that the login succeeded
  [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Welcome"]];
  
  return scenario;
}

@end
