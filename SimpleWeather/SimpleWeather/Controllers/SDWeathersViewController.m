//
//  SDWeathersViewController.m
//  SimpleWeather
//
//  Created by SiriusDely on 7/17/14.
//  Copyright (c) 2014 Sirius Dely. All rights reserved.
//

#import "SDWeathersViewController.h"

#import <LBBlurredImage/UIImageView+LBBlurredImage.h>

@interface SDWeathersViewController () <
UIScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIImageView *blurredImageView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSDateFormatter *dailyFormatter;

@end

@implementation SDWeathersViewController

- (id)init {
  if (self = [super init]) {
    _hourlyFormatter = [[NSDateFormatter alloc] init];
    _hourlyFormatter.dateFormat = @"h a";
    
    _dailyFormatter = [[NSDateFormatter alloc] init];
    _dailyFormatter.dateFormat = @"EEEE";
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIImage *background = [UIImage imageNamed:@"bg"];
  
  self.blurredImageView.alpha = 0;
  [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
  // 1
  CGRect headerFrame = [UIScreen mainScreen].bounds;
  // 2
  CGFloat inset = 20;
  // 3
  CGFloat temperatureHeight = 110;
  CGFloat hiloHeight = 40;
  CGFloat iconHeight = 30;
  // 4
  CGRect hiloFrame = CGRectMake(inset,
                                headerFrame.size.height - hiloHeight,
                                headerFrame.size.width - (2 * inset),
                                hiloHeight);
  
  CGRect temperatureFrame = CGRectMake(inset,
                                       headerFrame.size.height - (temperatureHeight + hiloHeight),
                                       headerFrame.size.width - (2 * inset),
                                       temperatureHeight);
  
  CGRect iconFrame = CGRectMake(inset,
                                temperatureFrame.origin.y - iconHeight,
                                iconHeight,
                                iconHeight);
  // 5
  CGRect conditionsFrame = iconFrame;
  conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
  conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
  
  // 1
  UIView *header = [[UIView alloc] initWithFrame:headerFrame];
  header.backgroundColor = [UIColor clearColor];
  self.tableView.tableHeaderView = header;
  
  // 2
  // bottom left
  UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
  temperatureLabel.backgroundColor = [UIColor clearColor];
  temperatureLabel.textColor = [UIColor whiteColor];
  temperatureLabel.text = @"0°";
  temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
  [header addSubview:temperatureLabel];
  
  // bottom left
  UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
  hiloLabel.backgroundColor = [UIColor clearColor];
  hiloLabel.textColor = [UIColor whiteColor];
  hiloLabel.text = @"0° / 0°";
  hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
  [header addSubview:hiloLabel];
  
  // top
  UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
  cityLabel.backgroundColor = [UIColor clearColor];
  cityLabel.textColor = [UIColor whiteColor];
  cityLabel.text = @"Loading...";
  cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
  cityLabel.textAlignment = NSTextAlignmentCenter;
  [header addSubview:cityLabel];
  
  UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
  conditionsLabel.backgroundColor = [UIColor clearColor];
  conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
  conditionsLabel.textColor = [UIColor whiteColor];
  conditionsLabel.text = @"Clear";
  [header addSubview:conditionsLabel];
  
  // 3
  // bottom left
  UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
  iconView.image = [UIImage imageNamed:@"weather-clear"];
  iconView.contentMode = UIViewContentModeScaleAspectFit;
  iconView.backgroundColor = [UIColor clearColor];
  [header addSubview:iconView];
  [[SDLocationManager sharedManager] findCurrentLocation];
  
  // 1
  [[RACObserve([SDLocationManager sharedManager], currentCondition)
    // 2
    deliverOn:RACScheduler.mainThreadScheduler]
   subscribeNext:^(SDWeather *newCondition) {
     // 3
     temperatureLabel.text = [NSString stringWithFormat:@"%.0f°", newCondition.temperature.floatValue];
     conditionsLabel.text = [newCondition.condition capitalizedString];
     cityLabel.text = [newCondition.locationName capitalizedString];
     
     // 4
     iconView.image = [UIImage imageNamed:[newCondition imageName]];
   }];
  
  // 1
  RAC(hiloLabel, text) = [[RACSignal combineLatest:@[
                                                     // 2
                                                     RACObserve([SDLocationManager sharedManager], currentCondition.tempHigh),
                                                     RACObserve([SDLocationManager sharedManager], currentCondition.tempLow)
                                                     ]
                           // 3
                                            reduce:^(NSNumber *hi, NSNumber *low) {
                                              return [NSString  stringWithFormat:@"%.0f° / %.0f°",hi.floatValue,low.floatValue];
                                            }]
                          // 4
                          deliverOn:RACScheduler.mainThreadScheduler];
  [[[RACSignal combineLatest:@[ RACObserve([SDLocationManager sharedManager], hourlyForecast),
                                RACObserve([SDLocationManager sharedManager], dailyForecast)
                                ]]
    deliverOn:[RACScheduler mainThreadScheduler]]ter
   subscribeNext:^(id x) {
     [self.tableView reloadData];
   }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}
/*
- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  CGRect bounds = self.view.bounds;
  
  self.backgroundImageView.frame = bounds;
  self.blurredImageView.frame = bounds;
  self.tableView.frame = bounds;
}
*/
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  // 1
  CGFloat height = scrollView.bounds.size.height;
  CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
  // 2
  CGFloat percent = MIN(position / height, 1.0);
  // 3
  self.blurredImageView.alpha = percent;
}

// 1
#pragma mark - UITableViewDataSource

// 2
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // 1
  if (section == 0) {
    return MIN([[SDLocationManager sharedManager].hourlyForecast count], 6) + 1;
  }
  // 2
  return MIN([[SDLocationManager sharedManager].dailyForecast count], 6) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (! cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
  }
  
  // 3
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
  cell.textLabel.textColor = [UIColor whiteColor];
  cell.detailTextLabel.textColor = [UIColor whiteColor];
  
  if (indexPath.section == 0) {
    // 1
    if (indexPath.row == 0) {
      [self configureHeaderCell:cell title:@"Hourly Forecast"];
    } else {
      // 2
      SDWeather *weather = [SDLocationManager sharedManager].hourlyForecast[indexPath.row - 1];
      [self configureHourlyCell:cell weather:weather];
    }
  } else if (indexPath.section == 1) {
    // 1
    if (indexPath.row == 0) {
      [self configureHeaderCell:cell title:@"Daily Forecast"];
    } else {
      // 3
      SDWeather *weather = [SDLocationManager sharedManager].dailyForecast[indexPath.row - 1];
      [self configureDailyCell:cell weather:weather];
    }
  }
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
  return [UIScreen mainScreen].bounds.size.height / (CGFloat)cellCount;
}

#pragma mark - Private Methods

// 1
- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
  cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
  cell.textLabel.text = title;
  cell.detailTextLabel.text = @"";
  cell.imageView.image = nil;
}

// 2
- (void)configureHourlyCell:(UITableViewCell *)cell weather:(SDWeather *)weather {
  cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
  cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
  cell.textLabel.text = [self.hourlyFormatter stringFromDate:weather.date];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f°",weather.temperature.floatValue];
  cell.imageView.image = [UIImage imageNamed:[weather imageName]];
  cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

// 3
- (void)configureDailyCell:(UITableViewCell *)cell weather:(SDWeather *)weather {
  cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
  cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
  cell.textLabel.text = [self.dailyFormatter stringFromDate:weather.date];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f° / %.0f°",
                               weather.tempHigh.floatValue,
                               weather.tempLow.floatValue];
  cell.imageView.image = [UIImage imageNamed:[weather imageName]];
  cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
