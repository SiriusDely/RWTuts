//
//  SDDailyForecast.m
//  SimpleWeather
//
//  Created by SiriusDely on 7/18/14.
//  Copyright (c) 2014 Sirius Dely. All rights reserved.
//

#import "SDDailyForecast.h"

@implementation SDDailyForecast

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  // 1
  NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
  // 2
  paths[@"tempHigh"] = @"temp.max";
  paths[@"tempLow"] = @"temp.min";
  // 3
  return paths;
}

@end
