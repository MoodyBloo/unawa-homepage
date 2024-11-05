import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unawa_home_page/main.dart';
import 'package:unawa_home_page/utils/constants.dart';

class HowToPage extends StatelessWidget {
  const HowToPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How To',
          style: TextStyle(
            color: AppTheme.textColor,
          ),
        ),
        backgroundColor:
            isDarkMode ? Colors.black : AppTheme.mainColor,
      ),
      body: Center(
          child: Text(
        'How To Page',
        style: TextStyle(
          color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
        ),
      )),
      backgroundColor: isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.lightBackgroundColor,
    );
  }
}
