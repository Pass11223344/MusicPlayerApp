
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
      double result = (number/10000) as double;
      var result1 =( (number/100000) as double).floor();

      var d = (result%10).floor();

      if(d!=0){
        return"${result1}.$d亿";
      }else{
        return "$result1亿";
      }
    }
  }
}