//
//  NSDate+YQCategory.h
//  Demo
//
//  Created by maygolf on 2017/7/12.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YQCalendarUnitsDate (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)

@interface NSDate (YQCategory)

+ (NSDate *)yq_dateFromString:(NSString *)string;
+ (NSDate *)yq_dateFromString:(NSString *)string format:(NSString *)format;
+ (NSString *)yq_dateFormatString;

/**
 *  @return 2017-07-07 07:07:07
 */
- (NSString *)yq_string;
- (NSString *)yq_stringWithFormat:(NSString *)format;
- (NSString *)yq_stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

/*!
 Relative dates from the current date
 获得相对与当前时间的时间
 */
+ (NSDate *)yq_dateTomorrow;
+ (NSDate *)yq_dateYesterday;
+ (NSDate *)yq_dateWithDaysFromNow:(NSInteger)days;
+ (NSDate *)yq_dateWithDaysBeforeNow:(NSInteger)days;
+ (NSDate *)yq_dateWithHoursFromNow:(NSInteger)hours;
+ (NSDate *)yq_dateWithHoursBeforeNow:(NSInteger)hours;
+ (NSDate *)yq_dateWithMinutesFromNow:(NSInteger)minutes;
+ (NSDate *)yq_dateWithMinutesBeforeNow:(NSInteger)minutes;


/*!
 Comparing or Adjusting  dates
 */
//加减
- (NSDate *)yq_offsetYears:(NSInteger)years;
- (NSDate *)yq_offsetMonths:(NSInteger)months;
- (NSDate *)yq_offsetDays:(NSInteger)days;
- (NSDate *)yq_offsetHours:(NSInteger)hours;
- (NSDate *)yq_offsetMinutes:(NSInteger)minutes;

//加
- (NSDate *)yq_dateByAddingYears:(NSInteger)years;
- (NSDate *)yq_dateByAddingMonths:(NSInteger)months;
- (NSDate *)yq_dateByAddingDays:(NSInteger)days;
- (NSDate *)yq_dateByAddingHours:(NSInteger)hours;
- (NSDate *)yq_dateByAddingMinutes:(NSInteger)minutes;
//减
- (NSDate *)yq_dateBySubtractingYears:(NSInteger)years;
- (NSDate *)yq_dateBySubtractingMonths:(NSInteger)months;
- (NSDate *)yq_dateBySubtractingDays:(NSInteger)days;
- (NSDate *)yq_dateBySubtractingHours:(NSInteger)hours;
- (NSDate *)yq_dateBySubtractingMinutes:(NSInteger)minutes;

- (BOOL)yq_isLeapYear;

- (BOOL)yq_isSameDay:(NSDate *)aDate;//Ignore Time
- (BOOL)yq_isSameWeek:(NSDate *)aDate;
- (BOOL)yq_isSameMonth:(NSDate *)aDate;
- (BOOL)yq_isSameYear:(NSDate *)aDate;

- (BOOL)yq_isEqualToDateIgnoreTime:(NSDate *)aDate;

- (BOOL)yq_isToday;
- (BOOL)yq_isTomorrow;
- (BOOL)yq_isYesterday;

- (BOOL)yq_isThisWeek;
- (BOOL)yq_isNextWeek;
- (BOOL)yq_isLastWeek;

- (BOOL)yq_isThisMonth;
- (BOOL)yq_isNextMonth;
- (BOOL)yq_isLastMonth;

- (BOOL)yq_isThisYear;
- (BOOL)yq_isNextYear;
- (BOOL)yq_isLastYear;

- (BOOL)yq_isEarlierDate:(NSDate *)aDate;
- (BOOL)yq_isLaterDate:(NSDate *)aDate;
- (BOOL)yq_isInFuture;
- (BOOL)yq_isInPast;

- (BOOL)yq_isOneMonthAgo;
- (BOOL)yq_isOneMonthAfter;
- (BOOL)yq_isWorkDay;
- (BOOL)yq_isWeekend;

// 时间间隔
- (NSInteger)yq_secondsAgo;
- (NSInteger)yq_minutesAgo;
- (NSInteger)yq_hoursAgo;
- (NSInteger)yq_monthsAgo;
- (NSInteger)yq_yearsAgo;
/**
 *  Timestamp comparison; return `distance current time timestamp` /  `one day timestamp`
 *  时间戳比较;返回  `距离当前时间的时间戳` / `一天的时间戳`
 *  @begin e.g:
 [NSDate date] : "2016-1-13 07:07:07";
 if self: "2016-1-11 07:06:00" return `2`;
 else if self: "2016-1-11 07:07:08" retrun `1`;
 @end e.g
 */
- (NSInteger)yq_daysAgo;
//无视时间
- (NSInteger)yq_leftDayCount;
/**
 *  day comparison ignor time,  the date must ago;
 *  @return 日期天数比较忽略时间
 *  @begin e.g:
 [NSDate date] : "2016-1-13 07:07:07";
 if self: "2016-1-11 07:06:00" return `2`;
 else if self: "2016-1-11 07:07:08" retrun `2`;
 @end e.g
 */
- (NSUInteger)yq_daysAgoMidnight;
/**
 *  day comparison ignor time
 *  @return 日期天数比较忽略时间
 *  @begin e.g:
 [NSDate date] : "2016-1-13 07:07:07";
 if self: "2016-1-16 07:06:00" return `3`;
 else if self: "2016-1-11 07:07:08" retrun `-2`;
 @end e.g
 */
- (NSInteger)yq_daysFromNow;

- (NSInteger)yq_numberOfDaysInMonth;
//这个月有几周;
- (NSInteger)yq_numberOfWeaksInMonth;

- (NSDateComponents *)yq_dateComponets;
- (NSInteger)yq_year;
- (NSInteger)yq_month;
- (NSInteger)yq_day;
- (NSInteger)yq_hour;
- (NSInteger)yq_minute;
- (NSInteger)yq_second;

- (NSInteger)yq_nearestHour;


/**
 *  Week index in a year
 *  一年中的第几周
 */
- (NSInteger)yq_week NS_CALENDAR_DEPRECATED(10_4, 10_9, 2_0, 7_0, "Use weekOfMonth or weekOfYear, depending on which you mean");

/**
 *
 *  一年中的第几周
 当该年最后一周不是从周日开始则返回则该日期返回`1`.
 也就是经常看到每个新月份 1号前面有 28,29 30号.
 */
- (NSInteger)yq_weekOfYear;
/**
 *  该日期是本月的第几周。一周从星期日开始。
 */
- (NSInteger)yq_weekOfMonth;
/**
 *  Week index days in this week (The date of week)
 *  这一周中第几天
 */
- (NSInteger)yq_weekday;

/**
 *  The date is which one week of this month.(Focus on which one  not in week. The number of week  in the vertical direction)
 *  该日期是本月的第几个星期几。(重点在第几个不是在星期几,日历中的竖方向,星期几的个数)
 * @begin e.g
 If this month begins on Tuesday,
 the no. 1 is on Tuesday, no.2 is on Wednesday, no.6 is Sunday,
 no.7 is Monday  8 is the second on Tuesday.
 if days:1,2,3,4,5  return WeekOfMonth and weekdayOrdinal is 1
 if days:6,7 return WeekOfMonth is 2 weekdayOrdinal is 1.
 Because although no.6 is the second week, but it is the first Sunday of this month, although  no.7 is also the second week, but it is the first Monday of this month.
 * @end e.g
 */
- (NSInteger)yq_weekdayOrdinal;
/**
 *
 所在的周的年份,
 当该年最后一周不是从周日开始则返回则该日期返回下一年.
 也就是经常看到每个新月份 1号前面有 28,29 30号.
 */
- (NSInteger)yq_yearForWeekOfYear;

/**
 *  这个月的1号在星期几 `这个月从哪个星期开始`
 *  // 1.Mon. 2.Thes. 3.Wed. 4.Thur. 5.Fri. 6.Sat. 7.Sun.
 *  eg:2016-8-31 return 1
 eg:2016-7-27 retrun 5
 eg:2017-1-31 return 7
 */
- (NSInteger)yq_beginningWeekOfMonth;

/**
 *  这个月的1号在星期几 `这个月从哪个星期开始`
 *  //0.Sun. 1.Mon. 2.Thes. 3.Wed. 4.Thur. 5.Fri. 6.Sat.
 *  eg:2016-8-31 return 1
 eg:2016-7-27 retrun 5
 eg:2017-1-31 return 0
 */
- (NSInteger)yq_firstWeekDayInThisMonth;

/**
 *  @return Beginning date of the date
 *  @return 该时间开始的时间.
 *  @begin e.g
 2015-12-30 08:50:30
 return  2015-12-29 16:00:00 +0000;
 *  @end
 */
- (NSDate *)yq_beginningOfDay;
- (NSDate *)yq_endOfDay;

/**
 *  @return 该时间所在周开始的时间.
 *  @begin e.g
 2015-12-30 08:50:30
 return 2015-12-26 16:00:00 +0000;
 *  @end
 */
- (NSDate *)yq_beginningOfWeek;

/**
 *  @return start date of end date in the week of the date (nearest week)
 *  @return 该时间所在周结束的时间的相对时间.
 *  @begin e.g
 2016-9-2 10:10:00 firiday
 return
 *  @end 2016-09-3 02:1:100 +0000 saturday
 */
- (NSDate *)yq_endOfWeek;


@end
