//
//  ViewController.m
//  CustomCalendar
//
//  Created by 王盛魁 on 16/2/18.
//  Copyright © 2016年 wangsk. All rights reserved.
//

#import "ViewController.h"
#import "Datetime.h"

@interface ViewController ()
@property (nonatomic, copy) NSArray *dayArray;
@property (nonatomic, copy) NSArray *lunarDayArray;
@property (nonatomic ) int strMonth;
@property (nonatomic ) int strYear;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDateTime];
}


- (void)getDateTime{
    
    self.strYear = [[Datetime GetYear] intValue];
    self.strMonth = [[Datetime GetMonth] intValue];
    self.dayArray = [Datetime GetDayArrayByYear:self.strYear andMonth:self.strMonth];
    self.lunarDayArray = [Datetime GetLunarDayArrayByYear:self.strYear andMonth:self.strMonth];
    
    NSLog(@"%d--%d",self.strYear,self.strMonth);
    NSLog(@"%@--%lu",self.dayArray,(unsigned long)self.dayArray.count);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
