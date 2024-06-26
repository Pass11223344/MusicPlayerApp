import 'app_localizations.dart';

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get helloWorld => '你好，世界！';

  @override
  String get welcomeMessage => '欢迎来到我们的应用';

  @override
  String get continueButton => '继续';

  @override
  String get settings => '设置';

  @override
  String get logout => '退出登录';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw(): super('zh_TW');

  @override
  String get welcomeMessage => '欢迎来到我们的应用';

  @override
  String get continueButton => '继续';

  @override
  String get settings => '设置';
}
