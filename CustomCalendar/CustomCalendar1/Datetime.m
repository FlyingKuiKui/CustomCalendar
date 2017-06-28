//
//  Datetime.m
//  CalendarTest
//
//  Created by mac on 13-8-27.
//  Copyright (c) 2013年 caobo. All rights reserved.
//

#import "Datetime.h"
#import "LunarCalendar.h"
#import "JBCalendar.h"

@implementation Datetime
//所有年列表
+ (NSArray *)GetAllYearArray{
    NSMutableArray * monthArray = [[NSMutableArray alloc]init];
    for (int i = 1949; i< 2999; i++) {
        NSString * days = [[NSString alloc]initWithFormat:@"%d",i];
        [monthArray addObject:days];
    }
    return monthArray;
}

//所有月列表
+ (NSArray *)GetAllMonthArray{
    NSMutableArray * monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<13; i++) {
        NSString * days = [[NSString alloc]initWithFormat:@"%d",i];
        [monthArray addObject:days];
    }
    return monthArray;
}





//以YYYY.MM.dd格式输出年月日
+ (NSString*)getDateTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}



//以YYYY年M月dd日格式输出年月日
+(NSString*)GetDateTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年M月dd日"];
     NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

//以YYYY年MMdd格式输出此时的农历年月日
+(NSString*)GetLunarDateTime{
    JBCalendar* date = [[JBCalendar alloc]init];
    date.year = [[self GetYear] intValue],date.month =[[self GetMonth] intValue],date.day = [[self GetDay] intValue];
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    NSString * lunar = [[NSString alloc]initWithFormat:
                           @"%@%@年%@%@",lunarCalendar.YearHeavenlyStem,lunarCalendar.YearEarthlyBranch,lunarCalendar.MonthLunar,lunarCalendar.DayLunar];
    return lunar;
}

// 获取指定年份 指定月份的 星期排列表
+ (NSArray *)GetDayArrayByYear:(int) year andMonth:(int) month{
    NSMutableArray *dayArray = [[NSMutableArray alloc]init];
    NSMutableArray *boolArray = [NSMutableArray array];
    for (int i = 0; i < [self SquareNumberOfWithYear:year Month:month]; i++) {
        if (i < [self GetTheWeekOfDayByYear:year andByMonth:month]) {
            // 小于本月
            int backMonthDays = [self GetNumberOfDayByYear:(month - 1 > 0 ? year:(year-1))andByMonth:(month - 1 > 0 ? (month - 1) : 12)];
            [dayArray addObject:[NSString stringWithFormat:@"%d",(backMonthDays - [self GetTheWeekOfDayByYear:year andByMonth:month]+i+1)]];
            [boolArray addObject:@"0"]; // 不属于本月
            
        }else if ((i >[self GetTheWeekOfDayByYear:year andByMonth:month]-1)&&(i<[self GetTheWeekOfDayByYear:year andByMonth:month]+[self GetNumberOfDayByYear:year andByMonth:month])){
            NSString * days;
            if((i - [self GetTheWeekOfDayByYear:year andByMonth:month] +1)< 10)
                days = [NSString stringWithFormat:@"%d",i-[self GetTheWeekOfDayByYear:year andByMonth:month]+1];
            else days = [NSString stringWithFormat:@"%d",i-[self GetTheWeekOfDayByYear:year andByMonth:month]+1];
            [dayArray addObject:days];
            
            if ([days isEqualToString:[self GetDay]]) {
                [boolArray addObject:@"2"]; // 本月本日
            }else{
                [boolArray addObject:@"1"]; // 属于本月
            }
        }else {
            // 大于本月
            [dayArray addObject:[NSString stringWithFormat:@"%d",i - [self GetTheWeekOfDayByYear:year andByMonth:month] - [self GetNumberOfDayByYear:year andByMonth:month] + 1]];
            [boolArray addObject:@"0"]; // 不属于本月
        }
    }
    return [@[boolArray,dayArray]mutableCopy];
}


//获取指定年份指定月份的星期排列表(农历)
+ (NSArray *)GetLunarDayArrayByYear:(int) year andMonth:(int) month{
    NSMutableArray * dayArray = [[NSMutableArray alloc]init];
    for (int i = 0; i< [self SquareNumberOfWithYear:year Month:month]; i++) {
        if (i < [self GetTheWeekOfDayByYear:year andByMonth:month]) {
            int backMonthDays = [self GetNumberOfDayByYear:(month - 1 > 0 ? year : year-1) andByMonth:(month - 1 > 0 ? month-1 : 12)];
            [dayArray addObject:[NSString stringWithFormat:@"%@",[self GetLunarDayByYear:(month - 1 > 0 ? year : year-1) andMonth:(month - 1 > 0 ? month-1 : 12) andDay:(backMonthDays - [self GetTheWeekOfDayByYear:year andByMonth:month]+i+1)]]];
        }else if ((i>[self GetTheWeekOfDayByYear:year andByMonth:month]-1)&&(i<[self GetTheWeekOfDayByYear:year andByMonth:month]+[self GetNumberOfDayByYear:year andByMonth:month])){
            NSString *days = [self GetLunarDayByYear:year andMonth:month andDay:(i-[self GetTheWeekOfDayByYear:year andByMonth:month]+1)];
            [dayArray addObject:days];
        }else {
            [dayArray addObject:[NSString stringWithFormat:@"%@",[self GetLunarDayByYear:(month+1 > 12 ? year+1 : year) andMonth:(month+1 > 12 ? 1 : month+1) andDay:(i - [self GetTheWeekOfDayByYear:year andByMonth:month] - [self GetNumberOfDayByYear:year andByMonth:month] + 1)]]];
        }
    }
    return dayArray;
}

//获取某年某月某日的对应农历日
+(NSString *)GetLunarDayByYear:(int) year
                      andMonth:(int) month
                        andDay:(int) day{
    JBCalendar *date = [[JBCalendar alloc]init];
    date.year = year,date.month = month,date.day = day;
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    NSString * lunarday = [[NSString alloc]initWithString:lunarCalendar.DayLunar];
    if ([lunarday isEqualToString:@"初一"]) {
        lunarday = [NSString stringWithFormat:@"%@",lunarCalendar.MonthLunar];
    }
    // 节气
    NSString *strSolarTerm = lunarCalendar.SolarTermTitle;
    if (strSolarTerm.length == 2) {
        lunarday = strSolarTerm;
    }
    return lunarday;
}



//计算year年month月第一天是星期几，周日则为0
+ (int)GetTheWeekOfDayByYear:(int)year
                  andByMonth:(int)month{
    int numWeek = ((year-1) + (year-1)/4 - (year-1)/100 + (year-1) / 400 + 1)%7;//numWeek为years年的第一天是星期几
    int ar[12] = {0,31,59,90,120,151,181,212,243,273,304,335};
    int numdays = (((year%4 == 0 && year%100 != 0)||(year%400 == 0 && year%100 == 0)) && (month > 2)) ? (ar[month - 1] + 1) : ( ar[month-1] );//numdays为month月years年的第一天是这一年的第几天
    int dayweek = (numdays % 7 + numWeek ) % 7;//month月第一天是星期几，周日则为0
    return dayweek;
}

//判断year年month月有多少天
+ (int)GetNumberOfDayByYear:(int)year
                 andByMonth:(int)month{
    
    int nummonth = 0;
    //判断month月有多少天
    if ((month == 1)|| (month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12)){
        nummonth = 31;
    }
    else if ((month == 4)|| (month == 6)||(month == 9)||(month == 11)){
        nummonth = 30;
    }else{
        // 2月 闰年
        if (( year%4 == 0 && year%100 != 0) || (year%400 == 0 && year%100 == 0)) {
            nummonth = 29;
            // 2月 平年
        } else {
            nummonth = 28;
        }
    }
    return nummonth;
}

+(NSString *)GetYear{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetMonth{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetDay{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetHour{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetMinute{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetSecond{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"ss"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}
//
+ (int)SquareNumberOfWithYear:(int)year Month:(int)month{
    int number;
    int daysOfNumner = [self GetNumberOfDayByYear:year andByMonth:month]; //这个月的天数
    int weekDay = [self GetTheWeekOfDayByYear:year andByMonth:month]; // 第一天周几,周日为0
    int sumOfWeekAndDays = daysOfNumner + weekDay;
    if (sumOfWeekAndDays % 7 == 0) {
        number = sumOfWeekAndDays;
    }else{
        number = (sumOfWeekAndDays / 7 + 1) * 7;
    }
    return number;
}

@end
