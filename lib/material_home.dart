import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:batteryplus/home_page.dart';
import 'package:flutter/material.dart';

class MaterialExample extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  //final VoidCallback onChanged;

  const MaterialExample({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: '',
        theme: theme,
        darkTheme: darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
