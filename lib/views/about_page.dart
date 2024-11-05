import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unawa_home_page/main.dart';
import 'package:unawa_home_page/utils/constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme
              .lightBackgroundColor, // Set background color based on theme
      body: Center(
        child: Text(
          'About Page',
          style: TextStyle(
            fontSize: 24,
            color: isDarkMode
                ? Colors.white
                : Colors.black, // Adjust text color based on theme
          ),
        ),
      ),
    );
  }
}
