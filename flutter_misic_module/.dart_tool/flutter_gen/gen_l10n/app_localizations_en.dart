import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'helloWorld';

  @override
  String get welcomeMessage => '欢迎来到我们的应用';

  @override
  String get continueButton => '继续';

  @override
  String get settings => '设置';

  @override
  String get logout => '退出登录';
}
