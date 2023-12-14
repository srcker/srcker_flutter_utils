import 'package:srcker_utils/date/date_time_formats.dart';

/// 日期时间工具类
class DateTimeUtils {
    /// 将字符串时间转化为DateTime，如果解析失败则返回当前时间  
    static DateTime getDateTime(String dateStr, {bool isUtc = false}) {  
        DateTime dateTime = DateTime.tryParse(dateStr) ?? DateTime.now();  
        return isUtc ? dateTime.toUtc() : dateTime.toLocal();  
    }  
    
    /// 将毫秒时间转化为DateTime  
    static DateTime getDateTimeByMs(int ms, {bool isUtc = false}) => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);  
    
    /// 将字符串时间转化为毫秒值  
    static int getDateMsByTimeString(String dateStr, {bool isUtc = false}) {  
        DateTime dateTime = getDateTime(dateStr, isUtc: isUtc);  
        return dateTime.millisecondsSinceEpoch;  
    }  
    
    /// 获取当前日期返回DateTime，可以指定是否返回UTC时间  
    static DateTime getNowDateTime({bool isUtc = false}) => isUtc ? DateTime.now().toUtc() : DateTime.now();  
    
    /// 获取当前毫秒值  
    static int getNowDateMs() => getNowDateTime().millisecondsSinceEpoch;  
    
    /// 获取日期字符串或指定格式的日期时间，可以指定是否返回UTC时间  
    static String getDateTimeFormat(String dateStr, {bool isUtc = false, String format = 'yyyy-MM-dd HH:mm:ss'}) {  
        DateTime dateTime = getDateTime(dateStr, isUtc: isUtc);  
        return formatDate(dateTime, format: format);  
    }  
  

    /// 获取当前日期返回DateTime(utc)
    static DateTime getNowUtcDateTime() => DateTime.now().toUtc();

    /// 获取当前日期，返回指定格式
    static String getNowDateTimeFormat(String outFormat) => formatDate(getNowDateTime(), format: outFormat);


    /// 获取当前日期，返回指定格式
    static String getUtcDateTimeFormat(String outFormat) => formatDate(getNowUtcDateTime(),format: outFormat);

    /// 格式化日期毫秒时间
    static String formatDateMilliseconds(int ms, {bool isUtc = false, String? format}) => formatDate(getDateTimeByMs(ms, isUtc: isUtc), format: format);

    /// 格式化日期字符串
    static String formatDateString(String dateStr, {bool isUtc = false, String? format}) => formatDate(getDateTime(dateStr, isUtc: isUtc), format: format);

    /// format 转换格式(已提供常用格式 DateTimeFormats，可以自定义格式：'yyyy/MM/dd HH:mm:ss')
    static String formatDate(DateTime dateTime, {String? format}) {
        
        if (dateTime == null) return '';

        format = format ?? DateTimeFormats.FULL;
        if (format.contains('yy')) {
            String year = dateTime.year.toString();
            if (format.contains('yyyy')) {
                format = format.replaceAll('yyyy', year);
            } else {
                format = format.replaceAll('yy', year.substring(year.length - 2, year.length));
            }
        }
        format = _comFormat(dateTime.month, format, 'M', 'MM');
        format = _comFormat(dateTime.day, format, 'd', 'dd');
        format = _comFormat(dateTime.hour, format, 'H', 'HH');
        format = _comFormat(dateTime.minute, format, 'm', 'mm');
        format = _comFormat(dateTime.second, format, 's', 'ss');
        format = _comFormat(dateTime.millisecond, format, 'S', 'SSS');
        return format;
    }

    /// com format.
    static String _comFormat(
        int value, String format, String single, String full) {
        if (format.contains(single)) {
            if (format.contains(full)) {
                format = format.replaceAll(full, value < 10 ? '0$value' : value.toString());
            } else {
                format = format.replaceAll(single, value.toString());
            }
        }
        return format;
    }

    /// get WeekDay.
    /// 获取dateTime是星期几
    static String getWeekday(DateTime dateTime, {String languageCode = 'zh', bool short = false}) {
        if (dateTime == null) return "";
        String weekday = "";
        switch (dateTime.weekday) {
            case 1:
                weekday = languageCode == 'zh' ? '星期一' : 'Monday';
                break;
            case 2:
                weekday = languageCode == 'zh' ? '星期二' : 'Tuesday';
                break;
            case 3:
                weekday = languageCode == 'zh' ? '星期三' : 'Wednesday';
                break;
            case 4:
                weekday = languageCode == 'zh' ? '星期四' : 'Thursday';
                break;
            case 5:
                weekday = languageCode == 'zh' ? '星期五' : 'Friday';
                break;
            case 6:
                weekday = languageCode == 'zh' ? '星期六' : 'Saturday';
                break;
            case 7:
                weekday = languageCode == 'zh' ? '星期日' : 'Sunday';
                break;
            default:
                break;
        }
        return languageCode == 'zh' ? (short ? weekday.replaceAll('星期', '周') : weekday) : weekday.substring(0, short ? 3 : weekday.length);
    }

    /// get WeekDay By Milliseconds.
    /// 获取毫秒值对应是星期几
    static String getWeekdayByMilliseconds(int milliseconds, {bool isUtc = false, String languageCode = 'en', bool short = false}) {
        DateTime dateTime = getDateTimeByMs(milliseconds, isUtc: isUtc);
        return getWeekday(dateTime, languageCode: languageCode, short: short);
    }

    /// get day of year.
    /// 在今年的第几天.
    static int getDayOfYear(DateTime dateTime) {
        int year = dateTime.year;
        int month = dateTime.month;
        int days = dateTime.day;
        for (int i = 1; i < month; i++) {
            days = days + MONTH_DAY[i]!;
        }
        if (isLeapYearByYear(year) && month > 2) {
            days = days + 1;
        }
        return days;
    }

    /// get day of year.
    /// 在今年的第几天.
    static int getDayOfYearByMilliseconds(int ms, {bool isUtc = false}) {
        return getDayOfYear(DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc));
    }

    /// is today.
    /// 根据时间戳判断是否是今天
    static bool isToday(int milliseconds, {bool isUtc = false, int? locMs}) {
        if (milliseconds == null || milliseconds == 0) return false;
        DateTime old = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
        DateTime now;
        if (locMs != null) {
            now = DateTimeUtils.getDateTimeByMs(locMs);
        } else {
            now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
        }
        return old.year == now.year && old.month == now.month && old.day == now.day;
    }

    /// is yesterday by dateTime.
    /// 根据时间判断是否是昨天
    static bool isYesterday(DateTime dateTime, DateTime locDateTime) {
        if (yearIsEqual(dateTime, locDateTime)) {
            int spDay = getDayOfYear(locDateTime) - getDayOfYear(dateTime);
            return spDay == 1;
        } else {
        return ((locDateTime.year - dateTime.year == 1) &&
            dateTime.month == 12 && locDateTime.month == 1 &&
            dateTime.day == 31 && locDateTime.day == 1);
        }
    }

    /// is yesterday by millis.
    /// 是否是昨天.
    static bool isYesterdayByMilliseconds(int ms, int locMs) {
        return isYesterday(DateTime.fromMillisecondsSinceEpoch(ms), DateTime.fromMillisecondsSinceEpoch(locMs));
    }

    /// year is equal.
    /// 是否同年.
    static bool yearIsEqual(DateTime dateTime, DateTime locDateTime) {
        return dateTime.year == locDateTime.year;
    }

    /// year is equal.
    /// 是否同年.
    static bool yearIsEqualByMilliseconds(int ms, int locMs) {
        return yearIsEqual(DateTime.fromMillisecondsSinceEpoch(ms), DateTime.fromMillisecondsSinceEpoch(locMs));
    }

    /// Return whether it is leap year.
    /// 是否是闰年
    static bool isLeapYear(DateTime dateTime) => isLeapYearByYear(dateTime.year);

    /// Return whether it is leap year.
    /// 是否是闰年
    static bool isLeapYearByMilliseconds(int milliseconds) {
        var dateTime = getDateTimeByMs(milliseconds);
        return isLeapYearByYear(dateTime.year);
    }

    /// Return whether it is leap year.
    /// 是否是闰年
    static bool isLeapYearByYear(int year) {
        return year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
    }

    ///判断a和b两个时间是否是同一天
    static bool isSameDay(DateTime a, DateTime b) {
        return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    /// Returns [DateTime] for the beginning of the day (00:00:00).
    ///
    /// (2020, 4, 9, 16, 50) -> (2020, 4, 9, 0, 0)
    static DateTime startOfDay(DateTime dateTime) => _date(dateTime.isUtc, dateTime.year, dateTime.month, dateTime.day);

    /// Returns [DateTime] for the beginning of the next day (00:00:00).
    ///
    /// (2020, 4, 9, 16, 50) -> (2020, 4, 10, 0, 0)
    static DateTime startOfNextDay(DateTime dateTime) => _date(dateTime.isUtc, dateTime.year, dateTime.month, dateTime.day + 1);

    /// Returns [DateTime] for the beginning of today (00:00:00).
    static DateTime startOfToday() => startOfDay(DateTime.now());

    /// Creates a copy of [date] but with time replaced with the new values.
    static DateTime setTime(DateTime date, int hours, int minutes, [int seconds = 0, int milliseconds = 0, int microseconds = 0]) => _date(date.isUtc, date.year, date.month, date.day, hours, minutes, seconds, milliseconds, microseconds);


    /// Returns a number of the next month.
    static int nextMonth(DateTime date) {
        final month = date.month;
        return month == DateTime.monthsPerYear ? 1 : month + 1;
    }

    /// Returns [DateTime] that represents a beginning
    /// of the first day of the month containing [date].
    ///
    /// Example: (2020, 4, 9, 15, 16) -> (2020, 4, 1, 0, 0, 0, 0).
    static DateTime firstDayOfMonth(DateTime date) => _date(date.isUtc, date.year, date.month);


    /// Returns [DateTime] that represents a beginning
    /// of the first day of the next month.
    ///
    /// Example: (2020, 4, 9, 15, 16) -> (2020, 5, 1, 0, 0, 0, 0).
    static DateTime firstDayOfNextMonth(DateTime dateTime) {
        final month = dateTime.month;
        final year = dateTime.year;
        final nextMonthStart = (month < DateTime.monthsPerYear)
            ? _date(dateTime.isUtc, year, month + 1, 1)
            : _date(dateTime.isUtc, year + 1, 1, 1);
        return nextMonthStart;
    }

    /// Returns [DateTime] that represents a beginning
    /// of the last day of the month containing [date].
    ///
    /// Example: (2020, 4, 9, 15, 16) -> (2020, 4, 30, 0, 0, 0, 0).
    static DateTime lastDayOfMonth(DateTime dateTime) {
        return previousDay(firstDayOfNextMonth(dateTime));
    }

    /// Returns [DateTime] that represents a beginning
    /// of the first day of the year containing [date].
    ///
    /// Example: (2020, 3, 9, 15, 16) -> (2020, 1, 1, 0, 0, 0, 0).
    static DateTime firstDayOfYear(DateTime dateTime) {
        return _date(dateTime.isUtc, dateTime.year, 1, 1);
    }

    /// Returns [DateTime] that represents a beginning
    /// of the first day of the next year.
    ///
    /// Example: (2020, 3, 9, 15, 16) -> (2021, 1, 1, 0, 0, 0, 0).
    static DateTime firstDayOfNextYear(DateTime dateTime) {
        return _date(dateTime.isUtc, dateTime.year + 1, 1, 1);
    }

    /// Returns [DateTime] that represents a beginning
    /// of the last day of the year containing [date].
    ///
    /// Example: (2020, 4, 9, 15, 16) -> (2020, 12, 31, 0, 0, 0, 0).
    static DateTime lastDayOfYear(DateTime dateTime) {
        return _date(dateTime.isUtc, dateTime.year, DateTime.december, 31);
    }

    /// Проверяет является ли заданная дата текущей.
    static bool isCurrentDate(DateTime date) {
        final now = DateTime.now();
        return isSameDay(date, now);
    }

    /// Returns number of days in the [month] of the [year].
    static int getDaysInMonth(int year, int monthNum) {
        assert(monthNum > 0);
        assert(monthNum <= 12);
        return DateTime(year, monthNum + 1, 0).day;
    }


    static DateTime copyWith(DateTime date, {
            int? year,
            int? month,
            int? day,
            int? hour,
            int? minute,
            int? second,
            int? millisecond,
            int? microsecond,
        }) {
        return _date(
            date.isUtc,
            year ?? date.year,
            month ?? date.month,
            day ?? date.day,
            hour ?? date.hour,
            minute ?? date.minute,
            second ?? date.second,
            millisecond ?? date.millisecond,
            microsecond ?? date.microsecond,
        );
    }


  /// Returns same time in the next day.
  static DateTime nextDay(DateTime d) {
    return copyWith(d, day: d.day + 1);
  }

  /// Returns same time in the previous day.
  static DateTime previousDay(DateTime d) {
    return copyWith(d, day: d.day - 1);
  }

  /// Returns same date in the next year.
  static DateTime nextYear(DateTime d) {
    return _date(d.isUtc, d.year + 1, d.month, d.day);
  }

  /// Returns same date in the previous year.
  static DateTime previousYear(DateTime d) {
    return _date(d.isUtc, d.year - 1, d.month, d.day);
  }

  /// Returns an iterable of [DateTime] with 1 day step in given range.
  ///
  /// [start] is the start of the rande, inclusive.
  /// [end] is the end of the range, exclusive.
  ///
  /// If [start] equals [end], than [start] still will be included in interbale.
  /// If [start] less than [end], than empty interable will be returned.
  ///
  /// [DateTime] in result uses [start] timezone.
  static Iterable<DateTime> generateWithDayStep(
      DateTime start, DateTime end) sync* {
    if (end.isBefore(start)) return;

    var date = start;
    do {
      yield date;
      date = nextDay(date);
    } while (date.isBefore(end));
  }


  static DateTime _date(bool utc, int year,
      [int month = 1,
        int day = 1,
        int hour = 0,
        int minute = 0,
        int second = 0,
        int millisecond = 0,
        int microsecond = 0]) =>
      utc
          ? DateTime.utc(
          year, month, day, hour, minute, second, millisecond, microsecond)
          : DateTime(
          year, month, day, hour, minute, second, millisecond, microsecond);

}

/// month->days.
Map<int, int> MONTH_DAY = {
  1: 31,
  2: 28,
  3: 31,
  4: 30,
  5: 31,
  6: 30,
  7: 31,
  8: 31,
  9: 30,
  10: 31,
  11: 30,
  12: 31,
};