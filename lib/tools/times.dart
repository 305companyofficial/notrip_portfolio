

import 'package:intl/intl.dart';

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes분 $twoDigitSeconds";
}

String printDuration2(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

String printSavedDate(String savedDateStr){
  var savedDate = DateTime.parse(savedDateStr);
  var duration = DateTime.now().difference(savedDate);
  if (duration> Duration(days: 1)){
    return DateFormat('yyyy.MM.dd'). format(savedDate);
  }else if (duration> Duration(hours: 1)){
    return "${duration.inHours.remainder(60)}시간 전";
  }else if(duration> Duration(minutes: 1))
    {
      return "${duration.inMinutes.remainder(60)}분 전";
    }else{
    return "방금 전";
  }
}
String printSavedDate2(String savedDateStr){
  var savedDate = DateTime.parse(savedDateStr);
  return DateFormat('yyyy.MM.dd'). format(savedDate);
}
