
import 'package:get/get.dart';

import '../bean/CommentInfoBean.dart';


class commentPageController extends GetxController{

 var _allPage = false.obs ;
 var _secondPage = true.obs;
 var _commentInfo = Rx<CommentInfoBean?>(null);
 var _isFocus = false.obs;
 var _isRePlyFocus = false.obs;
 var _text = "".obs;
 var _rePlyText = "".obs;
 var _replyCommentInfo = Rx<CommentInfoBean?>(null);
 var _replyPage = false.obs;
 set allPage(bool isShow) => _allPage.value = isShow;
 bool get allPage => _allPage.value;
 set secondPage(bool isShow) => _secondPage.value = isShow;
 bool get secondPage => _secondPage.value;
set commentInfo(CommentInfoBean bean) => _commentInfo.value = bean;
CommentInfoBean? get CommentInfo => _commentInfo.value;

set isFocus(bool focus) => _isFocus.value = focus;
 bool get  isFocus =>_isFocus.value;
 set isRePlyFocus(bool focus) => _isRePlyFocus.value = focus;
 bool get  isRePlyFocus =>_isRePlyFocus.value;
 set text(String str) => _text.value = str;
 String get text => _text.value;
 set rePlyText(String str) => _rePlyText.value = str;
 String get rePlyText => _rePlyText.value;
 set replyCommentInfo(CommentInfoBean bean) => _replyCommentInfo.value = bean;
 CommentInfoBean? get ReplyCommentInfo => _replyCommentInfo.value;
 set replyPage(bool isShow) => _replyPage.value = isShow;
 bool get replyPage => _replyPage.value;
 }