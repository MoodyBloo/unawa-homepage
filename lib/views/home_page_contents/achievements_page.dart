import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final List<List<String>> imageSets = [
    ['assets/beginner.png'],
    ['assets/firsttime.png'],
    ['assets/highfive.png'],
    ['assets/ben10.png'],
    ['assets/hero.png'],
    ['assets/Ace.png'],
    ['assets/phrase.png'],
    ['assets/fivevowels.png'],
    ['assets/ily.png'],
    ['assets/like.png'],
    ['assets/greetings.png'],
    ['assets/tyt.png'],
    ['assets/uuuuu.png'],
  ];

  final List<String> buttonIcons = [
    'assets/beginner_icon.png',
    'assets/first_icon.png',
    'assets/hi5_icon.png',
    'assets/ben10_icon.png',
    'assets/hero_icon.png',
    'assets/ace_icon.png',
    'assets/phrase_icon.png',
    'assets/fivevowels_icon.png',
    'assets/ily_icon.png',
    'assets/okay_icon.png',
    'assets/greetings_icon.png',
    'assets/tyt_icon.png',
    'assets/uuuuu_icon.png',
  ];

  final Set<int> hoveredButtons = {};
  List<Map<String, String>> userAchievements = [];
  List<String> earnedAchievementTitles = []; // List to track earned achievements

  @override
  void initState() {
    super.initState();
    fetchAchievements();
    checkUserProgress(); // Check user progress on page load
  }

  Future<void> fetchAchievements() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final achievementsRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Achievements');

      final querySnapshot = await achievementsRef.get();
      final achievements = querySnapshot.docs.map((doc) {
        if (doc['title'] != null) earnedAchievementTitles.add(doc['title']); // Track earned achievements
        return {
          'title': doc['title'] ?? 'Untitled Achievement',
          'description': doc['description'] ?? 'No description available',
        };
      }).toList();

      setState(() {
        userAchievements = List<Map<String, String>>.from(achievements);
      });
    } catch (e) {
      print('Error fetching achievements: $e');
    }
  }

  Future<void> checkUserProgress() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    List<String> testedLetters = List<String>.from(userDoc['testedLetters'] ?? []);
    List<String> testedPhrases = List<String>.from(userDoc['testedPhrases'] ?? []);

    // Check if specific achievements are earned based on progress
    if (testedLetters.length >= 1) await awardAchievement('Unawa Beginner', userId);
    if (testedPhrases.length >= 1) await awardAchievement('First time, yes!', userId);
    if (testedLetters.length >= 5) await awardAchievement('Hi five!', userId);
    if (testedLetters.length >= 10) await awardAchievement('Ben-TEN!', userId);
    if (testedLetters.length >= 13) await awardAchievement('Halfway Hero', userId);
    if (testedLetters.length >= 26) await awardAchievement('Alphabet Ace', userId);

    List<String> vowels = ['A', 'E', 'I', 'O', 'U'];
    if (vowels.every((vowel) => testedLetters.contains(vowel))) {
      await awardAchievement('Five Fingers for Five Vowels', userId);
    }

    if (testedPhrases.contains('mahal kita')) await awardAchievement('Mahal Din Kita', userId);
    if (testedPhrases.contains('kumusta')) await awardAchievement('Okay Lang!', userId);
    if (testedPhrases.contains('hi')) await awardAchievement('Greetings Guru', userId);
    if (testedPhrases.contains('salamat')) await awardAchievement('Thank You too?', userId);
    if (testedLetters.contains('U')) await awardAchievement('YOU YOU YOU YOU YOU YOU YOU', userId);
  }

  Future<void> awardAchievement(String title, String userId) async {
    final achievementsRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Achievements');

    final existingAchievement = await achievementsRef.where('title', isEqualTo: title).get();
    if (existingAchievement.docs.isEmpty) {
      await achievementsRef.add({
        'title': title,
        'description': getAchievementDescription(title),
        'earned': true,
        'dateEarned': FieldValue.serverTimestamp(),
      });
      setState(() {
        earnedAchievementTitles.add(title);  // Mark as earned
      });
    }
  }

  String getAchievementDescription(String title) {
    switch (title) {
      case 'Unawa Beginner':
        return "Successfully test your first sign. Congratulations on completing the beginner level.";
      case 'First time, yes!':
        return "Successfully test your first phrase. You did it! Your first achievement unlocked!";
      case 'Hi five!':
        return "Successfully test any five letters of the alphabet. A round of applause for your high five!";
      case 'Ben-TEN!':
        return "Successfully test any ten letters. You are the Ben 10 of achievements!";
      case 'Halfway Hero':
        return "Successfully test 13 letters of the alphabet. A true hero deserves recognition!";
      case 'Alphabet Ace':
        return "Successfully test all 26 alphabet letters. You are the ace in this game!";
      case 'Phrase Pro':
        return "Successfully test all four phrases. Keep up the great work with phrases!";
      case 'Five Fingers for Five Vowels':
        return "Successfully test the \"A, E, I, O, U\" vowel signs. You have mastered all five vowels!";
      case 'Mahal Din Kita':
        return "Successfully test the \"mahal kita\" sign phrase. An expression of love! Well done!";
      case 'Okay Lang!':
        return "Successfully test the \"kumusta\" sign phrase. You did it, and that’s awesome!";
      case 'Greetings Guru':
        return "Successfully test the \"hi\" sign phrase. Well, hello there!";
      case 'Thank You too?':
        return "Successfully test the \"salamat\" sign phrase. Thanks for being awesome!";
      case 'YOU YOU YOU YOU YOU YOU YOU':
        return "Successfully test the letter \"U\". You’ve reached an unbelievable achievement!";
      default:
        return "";
    }
  }

  void showImageDialog(
    BuildContext context,
    List<String> imagePaths,
    String title,
    String description,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F4EC),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var path in imagePaths)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.asset(path),
                ),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4.0),
              Text(description),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Achievements',
          style: TextStyle(
            fontFamily: 'Serif',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: userAchievements.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userAchievements.length,
              itemBuilder: (context, index) {
                final achievement = userAchievements[index];
                final isEarned = earnedAchievementTitles.contains(achievement['title']);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        hoveredButtons.add(index);
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        hoveredButtons.remove(index);
                      });
                    },
                    child: ElevatedButton(
                      onPressed: isEarned
                          ? () {
                              showImageDialog(
                                context,
                                imageSets[index % imageSets.length],
                                achievement['title'] ?? 'Achievement',
                                achievement['description'] ?? '',
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        backgroundColor: isEarned
                            ? hoveredButtons.contains(index)
                                ? const Color(0xFFCFE8E5)
                                : const Color(0xFFEEF7FF)
                            : const Color(0xFFB0BEC5),  // Gray out if not earned
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            buttonIcons[index % buttonIcons.length],
                            height: 40,
                            color: isEarned ? null : Colors.grey,  // Grayscale if not earned
                          ),
                          const Spacer(),
                          Text(
                            achievement['title'] ?? 'Achievement',
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
