
import 'package:intl/intl.dart';

class Utils {
  static  formatNumber(int number) {
    if (number < 10000) {
      return number.toString();
    } else if (number < 100000000) {
      double result = (number/1000) as double;
      var result1 =( (number/10000) as double).floor();

      var d = (result%10).floor();

      if(d!=0){
        return"${result1}.$d万";
      }else{
        return "$result1万";
      }

    }else{
      double result = (number/10000000) as double;
      var result1 =( (number/100000000) as double).floor();

      var d = (result%10).floor();

      if(d!=0){
        return"${result1}.$d亿";
      }else{
        return "$result1亿";
      }
    }
  }

static String formatDate(int timestamp ){
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

  // 定义日期格式
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // 格式化日期
  String formattedDate = dateFormat.format(date);
  return formattedDate;
}
  static String getSubTitle(dynamic info){
    String str = "";
    for (int i = 0; i < info.length; i++) {
      if(i==info.length-1){
        str = str+info[i].name;
      }else{
        str = "$str${info[i].name}/";
      }
    }
    return str;
  }
}