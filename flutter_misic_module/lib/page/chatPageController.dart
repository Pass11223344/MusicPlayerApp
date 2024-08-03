

import 'package:get/get.dart';

import '../bean/MsgBean.dart';

class chatPageController extends GetxController{
  RxList<MsgBean> _msgList = <MsgBean>[].obs;
  final _pageIsOk = false.obs;
  get pageIsOk => _pageIsOk.value;
  set pageIsOk(value) => _pageIsOk.value = value;
  addMsgList(List<MsgBean> list){
    _msgList.addAll(list);
  }
  List<MsgBean>  get msgList =>_msgList.value;
}