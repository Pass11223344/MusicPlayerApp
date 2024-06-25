
import 'package:get/get.dart';
import 'package:wangyiyun_flutter_module/bean/SongSheetList.dart';

class PageControllers extends GetxController{
  final  _isOverlayVisible = false.obs;
  final _pageIsOk = false.obs;

  get pageIsOk => _pageIsOk.value;

  set pageIsOk(value) => _pageIsOk.value = value;


  bool get isOverlayVisible => _isOverlayVisible.value;
  set isOverlayVisible(bool isOverlayVisible ) => _isOverlayVisible.value = isOverlayVisible;
}
class myPageController extends GetxController{

  var _selectedIndex = 0.obs;
  var _isExpanded = true.obs;
  var _isListExpanded=true.obs;
  var _songSheetInfo = Rx<SongSheetList?>(null);
  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int index) => _selectedIndex.value = index;
  bool get isExpanded => _isExpanded.value;
  set isExpanded(bool flag) => _isExpanded.value = flag;
  bool get isListExpanded => _isListExpanded.value;
  set isListExpanded(bool flag) => _isListExpanded.value = flag;
  SongSheetList? get songSheetInfo =>_songSheetInfo.value;
  set SongSheetInfo(SongSheetList info) =>_songSheetInfo.value = info;

 //  final  _avatarUrl = myPage().users?.avatarUrl.obs;
 //  final  _backgroundUrl =myPage().users?.backgroundUrl.obs;
 //  final  _nickname = myPage().users?.nickname.obs;
 //  final   _birthday = myPage().users?.birthday.obs;
 //  final  _province = myPage().users?.province.obs;
 //  final  _gender = myPage().users?.gender.obs;
 //  final  _city = myPage().users?.city.obs;
 //  final  _followeds = myPage().users?.followeds.obs;
 //  final  _follows = myPage().users?.follows.obs;
 //  final  _eventCount = myPage().users?.eventCount.obs;
 //  final _userId = myPage().users?.userId.obs;
 //
 //
 //  String get avatar  => _avatarUrl!.value;
 // set avatar(String str) => _avatarUrl!.value = str;
 //
 // String get background => _backgroundUrl!.value;
 // set background(String str) => _backgroundUrl!.value = str;
 //
 // String get nickname => _nickname!.value;
 // set nickname(String str) => _nickname!.value = str;
 //
 // int get birthday => _birthday!.value;
 // set birthday(int num) => _birthday!.value = num;
 //
 // int get province => _province!.value;
 // set province(int num) => _province!.value = num;
 //
 //
 // int get gender => _gender!.value;
 // set gender(int num) => _gender!.value = num;
 //
 // int get city => _city!.value;
 // set city(int num) => _city!.value = num;
 //
 // int get followeds => _followeds!.value;
 // set followeds(int num) => _followeds!.value = num;
 //
 //
 // int get follows => _follows!.value;
 // set follows(int num) => _follows!.value = num;int
 //
 //  get eventCount => _eventCount!.value;
 // set eventCount(int num) => _eventCount!.value = num;int
 //
 //  get userId => _userId!.value;
 // set userId(int num) => _userId!.value = num;
}


