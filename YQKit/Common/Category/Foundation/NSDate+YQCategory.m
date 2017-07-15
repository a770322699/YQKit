//
//  NSDate+YQCategory.m
//  Demo
//
//  Created by maygolf on 2017/7/12.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "NSDate+YQCategory.h"

static NSString *const kYQDateFormatStringDate = @"yyyy-MM-dd";
static NSString *const kYQDateFormatStringTime = @"HH:mm:ss";
static NSString *const kYQDateFormatStringDateWithTime = @"yyyy-MM-dd HH:mm:ss";

#define YQDate_Minute   60
#define YQDate_Hour     3600
#define YQDate_Day      86400
#define YQDate_Week     604800

@implementation NSDate (YQCategory)

+ (NSCalendar *)yq_sharedCalendar {
    static NSCalendar *shared_calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_calendar = [NSCalendar currentCalendar];
    });
    return shared_calendar;
}

+ (NSDateFormatter *)yq_sharedDateFormatter {
    static NSDateFormatter *shared_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_dateFormatter = [[NSDateFormatter alloc] init];
    });
    return shared_dateFormatter;
}

+ (NSDate *)yq_dateFromString:(NSString *)string {
    return [self.class yq_dateFromString:string format:[self yq_dateFormatString]];
}

+ (NSDate *)yq_dateFromString:(NSString *)string format:(NSString *)format {
    [self yq_sharedDateFormatter].dateFormat = format;
    return [[self yq_sharedDateFormatter] dateFromString:string];
}

+ (NSString *)yq_dateFormatString {
    return kYQDateFormatStringDateWithTime;
}

- (NSString *)yq_string {
    return [self yq_stringWithFormat:[self.class yq_dateFormatString]];
}

- (NSString *)yq_stringWithFormat:(NSString *)format {
    [self.class yq_sharedDateFormatter].dateFormat = format;
    return [[self.class yq_sharedDateFormatter] stringFromDate:self];
}

- (NSString *)yq_stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    [self.class yq_sharedDateFormatter].dateStyle = dateStyle;
    [self.class yq_sharedDateFormatter].timeStyle = timeStyle;
    return [[self.class yq_sharedDateFormatter] stringFromDate:self];
}

+ (NSDate *)yq_dateTomorrow {
    return [self.class yq_dateWithDaysFromNow:1];
}

+ (NSDate *)yq_dateYesterday {
    return [self.class yq_dateWithDaysBeforeNow:1];
}

+ (NSDate *)yq_dateWithDaysFromNow:(NSInteger)days {
    return [[NSDate date] yq_dateByAddingDays:days];
}

+ (NSDate *)yq_dateWithDaysBeforeNow:(NSInteger)days {
    return [[NSDate date] yq_dateBySubtractingDays:days];
}

+ (NSDate *)yq_dateWithHoursFromNow:(NSInteger)hours {
    return [[NSDate date] yq_dateByAddingHours:hours];
}

+ (NSDate *)yq_dateWithHoursBeforeNow:(NSInteger)hours {
    return [[NSDate date] yq_dateBySubtractingHours:hours];
}

+ (NSDate *)yq_dateWithMinutesFromNow:(NSInteger)minutes {
    return [[NSDate date] yq_dateByAddingMinutes:minutes];
}

+ (NSDate *)yq_dateWithMinutesBeforeNow:(NSInteger)minutes {
    return [[NSDate date] yq_dateBySubtractingMinutes:minutes];
}

- (NSDate *)yq_offsetYears:(NSInteger)years {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:years];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:kNilOptions];
}

- (NSDate *)yq_offsetMonths:(NSInteger)months {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];//monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:months];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:kNilOptions];
}

- (NSDate *)yq_offsetDays:(NSInteger)days {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];//monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:days];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:kNilOptions];
}

- (NSDate *)yq_offsetHours:(NSInteger)hours {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];//monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:hours];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:kNilOptions];
}

- (NSDate *)yq_offsetMinutes:(NSInteger)minutes {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];//monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMinute:minutes];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:kNilOptions];
}

- (NSDate *)yq_dateByAddingYears:(NSInteger)years {
    return [self yq_offsetYears:years];
}

- (NSDate *)yq_dateByAddingMonths:(NSInteger)months {
    return [self yq_offsetMonths:months];
}


- (NSDate *)yq_dateByAddingDays:(NSInteger)days {
    //Method 1
    return [self yq_offsetDays:days];
    //Method 2
    /*NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + YQDate_Day * days;
     NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
     return newDate;*/
}

- (NSDate *)yq_dateByAddingHours:(NSInteger)hours {
    //Method 1
    return [self yq_offsetHours:hours];
    //Method 2
    /*NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + YQDate_Hour * hours;
     NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
     return newDate;*/
}

- (NSDate *)yq_dateByAddingMinutes:(NSInteger)minutes {
    //Method 1
    return [self yq_offsetMinutes:minutes];
    //Method 2
    /*NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + YQDate_Minute * minutes;
     NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
     return newDate;*/
}


- (NSDate *)yq_dateBySubtractingYears:(NSInteger)years {
    return [self yq_offsetYears:-years];
}

- (NSDate *)yq_dateBySubtractingMonths:(NSInteger)months {
    return [self yq_offsetMonths:-months];
}

- (NSDate *)yq_dateBySubtractingDays:(NSInteger)days {
    //Method 1
    return [self yq_offsetDays:-days];
    //Method 2
    /*NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + YQDate_Day * -days;
     NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
     return newDate;*/
}

- (NSDate *)yq_dateBySubtractingHours:(NSInteger)hours {
    //Method 1
    return [self yq_offsetHours:-hours];
    //Method 2
    /*NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + YQDate_Hour * -hours;
     NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
     return newDate;*/
}

- (NSDate *)yq_dateBySubtractingMinutes:(NSInteger)minutes {
    //Method 1
    return [self yq_offsetMinutes:-minutes];
    //Method 2
    /*NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + YQDate_Minute * -minutes;
     NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
     return newDate;*/
}

- (BOOL)yq_isLeapYear {
    NSInteger year = self.yq_year;
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
}

- (BOOL)yq_isSameDay:(NSDate *)aDate {
    NSDateComponents *firstComponents =  [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:self];
    NSDateComponents *secondComponents = [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:aDate];
    return (firstComponents.year == secondComponents.year && firstComponents.month == secondComponents.month &&
            firstComponents.day == secondComponents.day);
}

- (BOOL)yq_isSameWeek:(NSDate *)aDate {
    NSDateComponents *firstComponents =  [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:self];
    NSDateComponents *secondComponents = [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:aDate];
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (firstComponents.weekOfYear != secondComponents.weekOfYear) return NO;
    
    // time interval under 1 week.
    return (fabs([self timeIntervalSinceDate:aDate]) < YQDate_Week);
    
}

- (BOOL)yq_isSameMonth:(NSDate *)aDate {
    NSDateComponents *firstComponents =  [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:self];
    NSDateComponents *secondComponents = [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:aDate];
    return (firstComponents.year == secondComponents.year && firstComponents.month == secondComponents.month &&
            firstComponents.month == secondComponents.month);
}

- (BOOL)yq_isSameYear:(NSDate *)aDate {
    NSDateComponents *firstComponents =  [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:self];
    NSDateComponents *secondComponents = [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:aDate];
    return (firstComponents.year == secondComponents.year);
}

- (BOOL)yq_isEqualToDateIgnoreTime:(NSDate *)aDate {
    return [self yq_isSameDay:aDate];
}

- (BOOL)yq_isToday {
    return [self yq_isSameDay:[NSDate date]];
}

- (BOOL)yq_isTomorrow {
    return [self yq_isSameDay:[NSDate yq_dateTomorrow]];
}

- (BOOL)yq_isYesterday {
    return [self yq_isSameDay:[NSDate yq_dateYesterday]];
}

- (BOOL)yq_isThisWeek {
    return [self yq_isSameWeek:[NSDate date]];
}


- (BOOL)yq_isNextWeek {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + YQDate_Week;
    NSDate *compareDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    return [self yq_isSameWeek:compareDate];
}


- (BOOL)yq_isLastWeek {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - YQDate_Week;
    NSDate *compareDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    return [self yq_isSameWeek:compareDate];
}


- (BOOL)yq_isThisMonth {
    return [self yq_isSameMonth:[NSDate date]];
}

- (BOOL)yq_isNextMonth {
    NSDate *compareDate = [NSDate date];
    NSDateComponents *selfComponents =  [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:self];
    NSDateComponents *dateComponents = [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:compareDate];
    if (selfComponents.year == dateComponents.year + 1 && selfComponents.month == 1 && dateComponents.month == 12) {
        return YES;
    } else if (selfComponents.year == dateComponents.year && selfComponents.month == dateComponents.month + 1) {
        return YES;
    }
    
    return NO;
}

- (BOOL)yq_isLastMonth {
    NSDate *compareDate = [NSDate date];
    NSDateComponents *selfComponents =  [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:self];
    NSDateComponents *dateComponents = [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:compareDate];
    if (selfComponents.year == dateComponents.year - 1 && selfComponents.month == 12 && dateComponents.month == 1) {
        return YES;
    } else if (selfComponents.year == dateComponents.year && selfComponents.month == dateComponents.month - 1) {
        return YES;
    }
    
    return NO;
}

- (BOOL)yq_isThisYear {
    return [self yq_isSameYear:[NSDate date]];
}

- (BOOL)yq_isNextYear {
    NSDate *compareDate = [NSDate date];
    NSDateComponents *selfComponents =  [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:self];
    NSDateComponents *dateComponents = [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:compareDate];
    return (selfComponents.year == dateComponents.year + 1);
}

- (BOOL)yq_isLastYear {
    NSDate *compareDate = [NSDate date];
    NSDateComponents *selfComponents =  [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:self];
    NSDateComponents *dateComponents = [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:compareDate];
    return (selfComponents.year == dateComponents.year - 1);
}


- (BOOL)yq_isEarlierDate:(NSDate *)aDate {
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)yq_isLaterDate:(NSDate *)aDate {
    return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL)yq_isInFuture {
    return [self yq_isLaterDate:[NSDate date]];
}

- (BOOL)yq_isInPast {
    return [self yq_isEarlierDate:[NSDate date]];
}

- (BOOL)yq_isOneMonthAgo {
    NSDateComponents *components = [[self.class yq_sharedCalendar] components:(NSCalendarUnitMonth | NSCalendarUnitDay)
                                                                     fromDate:self
                                                                       toDate:[NSDate date]
                                                                      options:0];
    return components.month == 0 && components.day >= 0;
}

- (BOOL)yq_isOneMonthAfter {
    NSDateComponents *components = [[self.class yq_sharedCalendar] components:(NSCalendarUnitMonth | NSCalendarUnitDay)
                                                                     fromDate:[NSDate date]
                                                                       toDate:self
                                                                      options:0];
    return components.month == 0 && components.day >= 0;
}


- (BOOL)yq_isWorkDay {
    return ![self yq_isWeekend];
}

- (BOOL)yq_isWeekend {
    NSDateComponents *components = [[self.class yq_sharedCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return ((components.weekday == 1) ||
            (components.weekday == 7));
}


- (NSInteger)yq_secondsAgo {
    NSDateComponents *components = [[self.class yq_sharedCalendar] components:(NSCalendarUnitSecond) fromDate:self toDate:[NSDate date] options:kNilOptions];
    return components.second;
}

- (NSInteger)yq_minutesAgo {
    NSDateComponents *components = [[self.class yq_sharedCalendar] components:(NSCalendarUnitMinute) fromDate:self toDate:[NSDate date] options:kNilOptions];
    return components.minute;
}

- (NSInteger)yq_hoursAgo {
    NSDateComponents *components = [[self.class yq_sharedCalendar] components:(NSCalendarUnitHour) fromDate:self toDate:[NSDate date] options:kNilOptions];
    return components.hour;
}

- (NSInteger)yq_monthsAgo {
    NSDateComponents *components = [[self.class yq_sharedCalendar] components:(NSCalendarUnitMonth) fromDate:self toDate:[NSDate date] options:kNilOptions];
    return components.month;
}

- (NSInteger)yq_yearsAgo {
    NSDateComponents *components = [[self.class yq_sharedCalendar] components:(NSCalendarUnitYear) fromDate:self toDate:[NSDate date] options:kNilOptions];
    return components.year;
}

- (NSInteger)yq_daysAgo {
    NSDateComponents *components = [[self.class yq_sharedCalendar] components:(NSCalendarUnitDay) fromDate:self toDate:[NSDate date] options:kNilOptions];
    return components.day;
}

- (NSInteger)yq_leftDayCount {
    NSDate *today = [NSDate yq_dateFromString:[[NSDate date] yq_stringWithFormat:@"yyyy-MM-dd"] format:@"yyyy-MM-dd"] ;
    NSDate *selfCopy = [NSDate yq_dateFromString:[self yq_stringWithFormat:@"yyyy-MM-dd"] format:@"yyyy-MM-dd"];//时分清零
    NSCalendar *calendar = [[self class] yq_sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:today
                                                 toDate:selfCopy
                                                options:0];
    return [components day];
}

- (NSUInteger)yq_daysAgoMidnight {
    NSDateFormatter *format = [self.class yq_sharedDateFormatter];
    format.dateFormat = kYQDateFormatStringDate;
    NSDate *midnight = [format dateFromString:[format stringFromDate:self]];
    return [midnight timeIntervalSinceNow] / YQDate_Day * - 1;
}

- (NSInteger)yq_daysFromNow {
    NSDate *today = [NSDate yq_dateFromString:[[NSDate date] yq_stringWithFormat:@"yyyy-MM-dd"] format:@"yyyy-MM-dd"]; //clear Time
    NSDate *selfCopy = [NSDate yq_dateFromString:[self yq_stringWithFormat:@"yyyy-MM-dd"] format:@"yyyy-MM-dd"]; ////clear Time
    
    NSCalendar *calendar = [[self class] yq_sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:today
                                                 toDate:selfCopy
                                                options:0];
    return components.day;
}

- (NSInteger)yq_numberOfDaysInMonth {
    NSRange range = [[self.class yq_sharedCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

- (NSInteger)yq_numberOfWeaksInMonth {
    NSInteger numberOfDays = [self yq_numberOfDaysInMonth];
    NSInteger fristWeek = [self yq_firstWeekDayInThisMonth];
    NSInteger weeks = 0;
    NSInteger daysOffset = numberOfDays + fristWeek;
    if (daysOffset % 7 > 0) {
        weeks = daysOffset / 7 + 1;
    } else {
        weeks = daysOffset / 7;
    }
    return weeks;
}

- (NSDateComponents *)yq_dateComponets {
    return [[self.class yq_sharedCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitYearForWeekOfYear) fromDate:self];
}

- (NSInteger)yq_year {
    return [self yq_dateComponets].year;
}

- (NSInteger)yq_month {
    return [self yq_dateComponets].month;
}

- (NSInteger)yq_day {
    return [self yq_dateComponets].day;
}

- (NSInteger)yq_hour {
    return [self yq_dateComponets].hour;
}

- (NSInteger)yq_minute {
    return [self yq_dateComponets].minute;
}

- (NSInteger)yq_second {
    return [self yq_dateComponets].second;
}

- (NSInteger)yq_nearestHour {
    NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + YQDate_Minute * 30;
    NSDate *nearestDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    NSDateComponents *components = [[self.class yq_sharedCalendar] components:NSCalendarUnitHour fromDate:nearestDate];
    return components.hour;
}

- (NSInteger)yq_week {
    return [self yq_dateComponets].week;
}

- (NSInteger)yq_weekOfYear {
    return [self yq_dateComponets].weekOfYear;
}

- (NSInteger)yq_weekOfMonth {
    return [self yq_dateComponets].weekOfMonth;
}

- (NSInteger)yq_weekday {
    return [self yq_dateComponets].weekday;
}

- (NSInteger)yq_weekdayOrdinal {
    return [self yq_dateComponets].weekdayOrdinal;
}

- (NSInteger)yq_yearForWeekOfYear {
    return [self yq_dateComponets].yearForWeekOfYear;
}

- (NSInteger)yq_beginningWeekOfMonth  {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2]; //monday is first day
    //[gregorian setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"nl_NL"]];
    
    //Set date to first of month
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:comps];
    
    return [gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:newDate];
}

- (NSInteger)yq_firstWeekDayInThisMonth {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:1]; //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    
    //Set date to first of month
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:comps];
    
    return [gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:newDate] - 1;
}

- (NSDate *)yq_beginningOfDay {
    NSDateComponents *components = [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:self];
    return [[self.class yq_sharedCalendar] dateFromComponents:components];
}

- (NSDate *)yq_endOfDay {
    NSDateComponents *components = [self yq_dateComponets];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [[self.class yq_sharedCalendar] dateFromComponents:components];
}

- (NSDate *)yq_beginningOfWeek {
    NSDate *beginningOfWeek = nil;
    BOOL ok = [[self.class yq_sharedCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&beginningOfWeek interval:nil forDate:self];
    if (ok) {
        return beginningOfWeek;
    }
    // couldn't calc via range, so try to grab Sunday;ssuming gregorian style
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [[self.class yq_sharedCalendar] components:NSCalendarUnitWeekday fromDate:self];
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
     */
    NSDateComponents *subtractCommponents = NSDateComponents.new;
    [subtractCommponents setDay:0 - ([weekdayComponents weekday] - 1)];
    beginningOfWeek = [[self.class yq_sharedCalendar] dateByAddingComponents:subtractCommponents toDate:self options:kNilOptions];
    //normalize to midnight, extract the year, month, and day components and create a new date from those components.
    NSDateComponents *compontens = [[self.class yq_sharedCalendar] components:YQCalendarUnitsDate fromDate:beginningOfWeek];
    return [[self.class yq_sharedCalendar] dateFromComponents:compontens];
}

- (NSDate *)yq_endOfWeek {
    NSDateComponents *weekdayComponents = [[[self class] yq_sharedCalendar] components:NSCalendarUnitWeekday fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    NSDate *endOfWeek = [[self.class yq_sharedCalendar] dateByAddingComponents:componentsToAdd toDate:self options:kNilOptions];
    return endOfWeek;
}

@end
