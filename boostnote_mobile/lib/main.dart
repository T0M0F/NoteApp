import 'package:boostnote_mobile/presentation/BoostnoteApp.dart';
import 'package:boostnote_mobile/presentation/BoostnoteTheme.dart';
import 'package:boostnote_mobile/presentation/ThemeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider<ThemeNotifier>(
  create: (_) => ThemeNotifier(BoostnoteTheme.boostnoteTheme),
  child: BoostnoteApp()
));

