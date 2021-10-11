import 'package:intl/intl.dart';

class TimeUtil {
  TimeUtil._();

  ///yyyy/MM/dd
  static const String FORMAT_YMD = "yyyy/MM/dd";

  ///yyyy年MM月dd日
  static const String FORMAT_YMD_CN = "yyyy年MM月dd日";

  ///yyyy-MM-dd
  static const String FORMAT_YMD_HORIZONTAL_LINE = "yyyy-MM-dd";

  ///yyyy-MM
  static const String FORMAT_YM_HORIZONTAL_LINE = "yyyy-MM";

  ///"yyyy-MM-dd HH:mm:ss"
  static const String FORMAT_YMD_HMS = "yyyy-MM-dd HH:mm:ss";

  ///yyyy-MM-dd HH:mm
  static const String FORMAT_YMD_HM = "yyyy-MM-dd HH:mm";

  ///格式gmt时间，默认yyyy/MM/dd
  static String formatGmt(String gmtString, {String format = FORMAT_YMD}) {
    DateTime parse = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(gmtString);
    return DateFormat(format).format(parse);
  }

  ///格式2020-10-28 16:16:20时间
  static DateTime parse(String time, {String format = FORMAT_YMD_HMS}) {
    try {
      DateTime parse = DateFormat(format).parse(time);
      return parse;
    } catch (e) {
      return null;
    }
  }

  ///格式2020-10-28 16:16:20时间
  static String format({DateTime time, String format = FORMAT_YMD_HMS}) {
    return DateFormat(format).format(time ?? DateTime.now());
  }
}
