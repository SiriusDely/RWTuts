//
//  SCTestController.m
//  SampleProject
//
//  Created by SiriusDely on 6/28/13.
//  Copyright (c) 2013 Suitmedia. All rights reserved.
//

#import "SCTestController.h"
#import "KIFTestScenario+SCAdditions.h"

@implementation SCTestController

- (void)initializeScenarios {
  [self addScenario:[KIFTestScenario scenarioToLogin]];
  // Add additional scenarios you want to test here
}

@end
