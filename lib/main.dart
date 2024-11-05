import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/constants.dart'; // Import your app_theme.dart
import 'views/splashscreen_page.dart'; // Import the splash screen page

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class ThemeProvider with ChangeNotifier {
  String _currentThemeString = 'Light'; // Default theme selection
  
  String get currentThemeString => _currentThemeString;

  void setTheme(String theme) {
    _currentThemeString = theme;
    notifyListeners();
  }

  ThemeData get currentTheme {
    // Create the theme with Poppins font
    final textTheme = GoogleFonts.poppinsTextTheme();

    switch (_currentThemeString) {
      case 'Dark':
        return AppTheme.darkTheme.copyWith(textTheme: textTheme);
      case 'Light':
        return AppTheme.lightTheme.copyWith(textTheme: textTheme);
      case 'System':
      default:
        return WidgetsBinding.instance.window.platformBrightness ==
                Brightness.dark
            ? AppTheme.darkTheme.copyWith(textTheme: textTheme)
            : AppTheme.lightTheme.copyWith(textTheme: textTheme);
    }
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: const SplashScreenPage(), // Set the splash screen as the home
          );
        },
      ),
    );
  }
}
