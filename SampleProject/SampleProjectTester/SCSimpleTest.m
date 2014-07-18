//
//  SCSimpleTest.m
//  SampleProject
//
//  Created by SiriusDely on 6/28/13.
//  Copyright (c) 2013 Suitmedia. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>
#import "SCCalculator.h"

@interface SCSimpleTest : GHTestCase

@end

@implementation SCSimpleTest

- (void)testSimplePass {
	// Another test
}

- (void)testSimpleFail {
	GHAssertTrue(NO, nil);
}

// simple test to ensure building, linking,
// and running test case works in the project
- (void)testOCMockPass {
  id mock = [OCMockObject mockForClass:NSString.class];
  [[[mock stub] andReturn:@"mocktest"] lowercaseString];
  
  NSString *returnValue = [mock lowercaseString];
  GHAssertEqualObjects(@"mocktest", returnValue, @"Should have returned the expected string.");
}

- (void)testOCMockFail {
  id mock = [OCMockObject mockForClass:NSString.class];
  [[[mock stub] andReturn:@"mocktest"] lowercaseString];
  
  NSString *returnValue = [mock lowercaseString];
  GHAssertEqualObjects(@"thisIsTheWrongValueToCheck", returnValue, @"Should have returned the expected string.");
}

- (void)testCalculatorAddFunction {
  SCCalculator* calculator = [[SCCalculator alloc] init];
  int expected = 11;
  int result = [calculator add:5 to:6];
  GHAssertEquals(expected, result, @"Should have returned the expected integer.");
}

- (void)testOCMockCalculatorAddFunction {
  id mock = [OCMockObject mockForClass:[SCCalculator class]];
  int expected = 11;
  int result = [mock add:5 to:6];
  GHAssertEquals(expected, result, @"Should have returned the expected integer.");
}

@end
