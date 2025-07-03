import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SystemUiStyleManager with WidgetsBindingObserver {
  static final SystemUiStyleManager _instance =
      SystemUiStyleManager._internal();

  factory SystemUiStyleManager() {
    return _instance;
  }

  SystemUiStyleManager._internal();

  void init() {
    WidgetsBinding.instance.addObserver(this);
    _applyStyle();
  }

  void _applyStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFFFFFF),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFFFFFFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _applyStyle();
    }
  }
}
