import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'features/notes/view/notes_list_screen.dart';
import 'features/settings/view_model/theme_viewmodel.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (context, themeVm, _) {
      final light = AppTheme.light(themeVm.seedColor);
      final dark = AppTheme.dark(themeVm.seedColor);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FAZ Flutter Task',
        theme: light,
        darkTheme: dark,
        themeMode: themeVm.isDark ? ThemeMode.dark : ThemeMode.light,
        home: const NotesListScreen(),
      );
    });
  }
}
