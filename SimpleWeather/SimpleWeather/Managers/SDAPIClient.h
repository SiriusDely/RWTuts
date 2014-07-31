//
//  SDAPIClient.h
//  SimpleWeather
//
//  Created by SiriusDely on 7/18/14.
//  Copyright (c) 2014 Sirius Dely. All rights reserved.
//

@import CoreLocation;
@import Foundation;

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SDAPIClient : NSObject

- (RACSignal *)fetchJSONFromURL:(NSURL *)url;
- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate;

@end
