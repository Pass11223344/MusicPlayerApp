
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
 var _addMoreListIsOk = false.obs;
 var _addMoreReplyListIsOk = false.obs;
 var _isSend = false.obs;
 var _sortType = 1.obs;
 var _numPage = 1.obs;
 var _isTraceComment = false.obs;
 set allPage(bool isShow) => _allPage.value = isShow;
 bool get allPage => _allPage.value;
 set secondPage(bool isShow) => _secondPage.value = isShow;
 bool get secondPage => _secondPage.value;
set commentInfo(CommentInfoBean? bean) => _commentInfo.value = bean;
CommentInfoBean? get commentInfo => _commentInfo.value;


set isFocus(bool focus) => _isFocus.value = focus;
 bool get  isFocus =>_isFocus.value;
 set isRePlyFocus(bool focus) => _isRePlyFocus.value = focus;
 bool get  isRePlyFocus =>_isRePlyFocus.value;
 set text(String str) => _text.value = str;
 String get text => _text.value;
 set rePlyText(String str) => _rePlyText.value = str;
 String get rePlyText => _rePlyText.value;
 set replyCommentInfo(CommentInfoBean? bean) => _replyCommentInfo.value = bean;
 CommentInfoBean? get replyCommentInfo => _replyCommentInfo.value;
 set replyPage(bool isShow) => _replyPage.value = isShow;
 bool get replyPage => _replyPage.value;
 bool get  addMoreListIsOk =>_addMoreListIsOk.value;
 set addMoreListIsOk(bool flag) => _addMoreListIsOk.value = flag;
 bool get  addMoreReplyListIsOk =>_addMoreReplyListIsOk.value;
 set addMoreReplyListIsOk(bool flag) => _addMoreReplyListIsOk.value = flag;
 int get  sortType =>_sortType.value;
 set sortType(int type) => _sortType.value = type;
 bool get isSend => _isSend.value;
 set isSend(bool isSend) => _isSend.value = isSend;
 int get  numPage =>_numPage.value;
 set numPage(int num) => _numPage.value = num;
 bool get  isTraceComment =>_isTraceComment.value;
 set isTraceComment(bool flag) => _isTraceComment.value = flag;
 addList(String type,List<Comments> list){

  switch(type){
   case "comment":
    commentInfo?.comments.addAll(list);
    _commentInfo.refresh();
 //   update();
      break;
   case"reply":
    replyCommentInfo?.comments.addAll(list);
    _replyCommentInfo.refresh();
    break;
  }

 }
 removeList(String type,int index){
  switch(type){
   case "comment":
    commentInfo?.comments.removeAt(index);
    _commentInfo.refresh();
    //   update();
    break;
   case"reply":
    replyCommentInfo?.comments.removeAt(index);
    _replyCommentInfo.refresh();
    break;
  }
 }
 }