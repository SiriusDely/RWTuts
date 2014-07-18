//
//  WXClient.m
//  SimpleWeather
//
//  Created by SiriusDely on 7/18/14.
//  Copyright (c) 2014 Sirius Dely. All rights reserved.
//

#import "WXClient.h"

#import "WXCondition.h"
#import "WXDailyForecast.h"


@interface WXClient ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation WXClient

- (id)init {
  if (self = [super init]) {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
  }
  return self;
}

@end
