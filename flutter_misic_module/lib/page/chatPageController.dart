import 'dart:ui';

import 'package:get/get.dart';

import '../bean/MsgBean.dart';

class chatPageController extends GetxController{
  RxList<msgBean> _msgList = <msgBean>[].obs;
  final _pageIsOk = false.obs;
  get pageIsOk => _pageIsOk.value;
  set pageIsOk(value) => _pageIsOk.value = value;
  addMsgList(List<msgBean> list){
    _msgList.addAll(list);
  }
  List<msgBean>  get msgList =>_msgList.value;
}