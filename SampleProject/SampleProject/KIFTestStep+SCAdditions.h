//
//  KIFTestStep+SCAdditions.h
//  SampleProject
//
//  Created by SiriusDely on 6/28/13.
//  Copyright (c) 2013 Suitmedia. All rights reserved.
//

#import <KIF/KIFTestStep.h>

@interface KIFTestStep (SCAdditions)

// Factory Steps

+ (id)stepToReset;

// Step Collections

// Assumes the application was reset and sitting at the welcome screen
+ (NSArray *)stepsToGoToLoginPage;

@end
