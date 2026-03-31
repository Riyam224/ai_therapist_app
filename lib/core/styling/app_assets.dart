import 'package:flutter/material.dart';

class AppAssets {
  static const emojisPath = 'assets/emojis/';

  // ── Illustrated mood SVGs (mood selector on home screen) ──────────────────
  static const String moodAwful = '${emojisPath}mood_awful.svg';
  static const String moodMeh = '${emojisPath}mood_meh.svg';
  static const String moodOkay = '${emojisPath}mood_okay.svg';
  static const String moodGood = '${emojisPath}mood_good.svg';
  static const String moodGreat = '${emojisPath}mood_great.svg';

  // Legacy PNG aliases kept for non-selector widgets (response card, history, etc.)
  static const String moodBad = '${emojisPath}confused.png';
  static const String moodAmazing = '${emojisPath}star-eyes.png';

  // Additional Emotion Emojis (expanded emotion tracking)
  static const String emojiAngry = '${emojisPath}angry.png';
  static const String emojiAnxious = '${emojisPath}anxious.png';
  static const String emojiCalm = '${emojisPath}calm.png';
  static const String emojiStressed = '${emojisPath}stressed.png';
  static const String emojiExcited = '${emojisPath}excited.png';
  static const String emojiTired = '${emojisPath}tired.png';
  static const String emojiFrustrated = '${emojisPath}frustrated.png';
  static const String emojiHopeful = '${emojisPath}hopeful.png';
  static const String emojiLonely = '${emojisPath}lonely.png';
  static const String emojiGrateful = '${emojisPath}grateful.png';
  static const String emojiOverwhelmed = '${emojisPath}overwhelmed.png';
  static const String emojiNeutral = '${emojisPath}neutral.png';
  static const String emojiWorried = '${emojisPath}worried.png';
  static const String emojiRelaxed = '${emojisPath}relaxed.png';
  static const String emojiContent = '${emojisPath}content.png';
  static const String emojiSurprised = '${emojisPath}surprised.png';
  static const String emojiProud = '${emojisPath}proud.png';
  static const String emojiEmbarrassed = '${emojisPath}embarrassed.png';

  // Greeting Emojis
  static const String greetingMorning = '${emojisPath}flower.png';
  static const String greetingAfternoon = '${emojisPath}sun.png';
  static const String greetingEvening = '${emojisPath}moon.png';

  // Action Icons
  static const String actionChat = '${emojisPath}chat.png';
  static const String actionHistory = '${emojisPath}book.png';

  /// Color tint applied to each mood SVG (colorFilter BlendMode.srcIn).
  static const Map<String, Color> moodSvgColors = {
    moodAwful: Color(0xFF85B7EB), // soft blue — awful/sad
    moodMeh:   Color(0xFF6C5CE7), // primary purple — meh/bad
    moodOkay:  Color(0xFF18A887), // mint green — okay
    moodGood:  Color(0xFF9180E8), // lavender — good
    moodGreat: Color(0xFFE84393), // pink — great/amazing
  };

  /// Maps unicode emoji characters (as received from the API) to local SVG asset paths.
  /// Only the 5 core mood SVGs are mapped; other emojis fall back to unicode rendering.
  static const Map<String, String> emojiAssetMap = {
    '😢': moodAwful,
    '😔': moodMeh,
    '😊': moodOkay,
    '😃': moodGood,
    '🤩': moodGreat,
  };
}
