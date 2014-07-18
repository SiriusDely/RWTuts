//
//  SampleProjectTests.m
//  SampleProjectTests
//
//  Created by SiriusDely on 6/28/13.
//  Copyright (c) 2013 Suitmedia. All rights reserved.
//

#import "SampleProjectTests.h"
#import "SCCalculator.h"

@implementation SampleProjectTests

- (void)setUp {
    [super setUp];
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    [super tearDown];
}

- (void)testExample {
    STFail(@"Unit tests are not implemented yet in SampleProjectTests");
}

- (void)testCalculatorAddFunction {
  SCCalculator* calculator = [[SCCalculator alloc] init];
  int expected = 11;
  int result = [calculator add:5 to:6];
  STAssertEquals(expected, result, @"We expected %d, but it was %d", expected, result);
}

@end
