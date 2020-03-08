import 'package:boostnote_mobile/business_logic/service/ThemeService.dart';
import 'package:boostnote_mobile/presentation/BoostnoteApp.dart';
import 'package:boostnote_mobile/presentation/ThemeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeService().getThemeData().then((themeData){
    runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (context) => ThemeNotifier(themeData),
      child: BoostnoteApp()
  ));
  });
}


