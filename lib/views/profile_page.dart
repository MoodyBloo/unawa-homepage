import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:unawa_home_page/main.dart';
import 'package:unawa_home_page/utils/constants.dart';
import 'package:unawa_home_page/views/home_page_contents/achievements_page.dart'; // Import the AchievementsPage

class ProfilePage extends StatefulWidget {
  final String userName;

  const ProfilePage({required this.userName, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    if (_nameController.text.isEmpty) {
      // Show a snackbar for empty validation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your name before saving.',
            style: TextStyle(
              color: isDarkMode ? AppTheme.cardColor : AppTheme.textColor,
            ),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: isDarkMode
              ? AppTheme.lightBackgroundColor
              : AppTheme.darkBackgroundColor,
        ),
      );
      return; // Prevent saving
    }

    setState(() {
      _isEditing = false;
    });
    // Add your save logic here if needed
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.lightBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          SizedBox(
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor:
                      isDarkMode ? AppTheme.cardColor : AppTheme.disabledColor,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: isDarkMode
                        ? AppTheme.disabledColor
                        : AppTheme.lightBackgroundColor,
                  ),
                ),
                const SizedBox(height: 8),
                _isEditing
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Tooltip(
                          message: 'Enter your name',
                          child: TextField(
                            controller: _nameController,
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppTheme.lightBackgroundColor
                                  : AppTheme.cardColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? AppTheme.textColor
                                    : AppTheme.cardColor,
                              ),
                              filled: true,
                              fillColor: isDarkMode
                                  ? AppTheme.cardColor
                                  : AppTheme.lightBackgroundColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: isDarkMode
                                      ? AppTheme.mainColor
                                      : AppTheme.disabledColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        _nameController.text,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppTheme.textColor
                              : AppTheme.cardColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'A verification email has been sent to your email.',
                          style: TextStyle(
                            color: isDarkMode
                                ? AppTheme.cardColor
                                : AppTheme.textColor,
                          ),
                        ),
                        backgroundColor: isDarkMode
                            ? AppTheme.lightBackgroundColor
                            : AppTheme.darkBackgroundColor,
                      ),
                    );
                  },
                  icon: HugeIcon(
                    icon: Icons.email,
                    size: 18,
                    color: isDarkMode
                        ? AppTheme.mainColor
                        : AppTheme.lightBackgroundColor,
                  ),
                  label: const Text(
                    'Verify Profile',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? AppTheme.cardColor : AppTheme.mainColor,
                    foregroundColor: isDarkMode
                        ? AppTheme.cardColor
                        : AppTheme.lightBackgroundColor,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (_isEditing) {
                        _saveProfile(); // Save profile if already editing
                      } else {
                        _isEditing = true; // Enable edit mode
                      }
                    });
                  },
                  icon: Icon(
                    _isEditing ? Icons.save : Icons.edit,
                    color: isDarkMode
                        ? AppTheme.lightBackgroundColor
                        : AppTheme.cardColor,
                    size: 20,
                  ),
                  label: Text(
                    _isEditing ? 'Save' : 'Edit Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: isDarkMode
                          ? AppTheme.lightBackgroundColor
                          : AppTheme.cardColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? AppTheme.cardColor
                        : AppTheme.lightBackgroundColor,
                    foregroundColor: AppTheme.cardColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildStatColumn('10', 'Level', isDarkMode)),
                Expanded(
                    child: _buildStatColumn('120', 'Achievements', isDarkMode)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // New Achievements Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AchievementsPage(), // Navigate to AchievementsPage
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor:
                    isDarkMode ? AppTheme.mainColor : AppTheme.cardColor,
                foregroundColor: isDarkMode
                    ? AppTheme.lightBackgroundColor
                    : AppTheme.textColor,
              ),
              child: const Text(
                'View Achievements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label, bool isDarkMode) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.white54 : Colors.black54,
          ),
        ),
      ],
    );
  }
}
