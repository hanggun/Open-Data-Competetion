import 'dart:ui';

import 'package:business_mining/common/cupertino_localizations.dart';
import 'package:business_mining/provider/local_profile_model.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nav_router/nav_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'common/color.dart';
import 'common/global.dart';

import 'demo/home/home_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Global.init();

  runApp(BaseApp());

  /// 状态栏透明
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
}

class BaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LocalProfileModel()),
      ],
      child: MyApp(),
    );
  }
}

final EventBus eventBus = EventBus();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color primaryColor = const Color(0xff4D7CFE);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "商探风险评估系统",
      navigatorKey: navGK,
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorLight: const Color(0xff296df6),
        accentColor: const Color(0xFFFFCF54),
        hintColor: TextColor.textGrayLight,
        errorColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,

        ///用于突出显示切换Widget（如Switch，Radio和Checkbox）的活动状态的颜色。
        toggleableActiveColor: primaryColor,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(brightness: Brightness.dark),
        primaryColorBrightness: Brightness.light,
        textTheme: TextTheme(
          //黑色14
          bodyText1:
              TextStyle(color: TextColor.textBlack, fontSize: 14, fontWeight: FontWeight.normal),
          //灰色12
          bodyText2: TextStyle(
              color: TextColor.textGrayLight, fontSize: 12, fontWeight: FontWeight.normal),
          //黑色12
          subtitle2:
              TextStyle(color: TextColor.textBlack, fontSize: 12, fontWeight: FontWeight.normal),
          //黑色14加粗
          headline6:
              TextStyle(color: TextColor.textBlack, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        primaryTextTheme: TextTheme(
          bodyText1: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.normal),
          bodyText2: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.normal),
        ),
      ),
      home: HomeRoute(),
      localizationsDelegates: [
        RefreshLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // 美国英语
        const Locale('zh', 'CN'), // 中文简体
      ],
      locale: const Locale('zh', 'CN'),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus.unfocus();
            }
          },
          child: child,
        );
      },
    );
  }
}
